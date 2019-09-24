#!/bin/bash
print_help () {
	echo ""
	echo "usage: pie.sh [-h] [-l] -m MODLE_FILE -w WEIGHT_FILE -b TARGET_BOARD -f CONF_FILE -o OUT_PUT"
	echo ""
	echo "optinal arguments:"
	echo "  -h  show this help message and exit"
	echo "  -l  list supported FPGA board"
	echo "  -m  modle file from trained result"
	echo "  -w  weight file from trained result"
	echo "  -b  target FPGA board in the listed supported FPGA board"
	echo "  -f  configuration file for optimization"
	echo "  -o  output folder for compiled result"
    echo "  -s  batch size, only available when manual optimization"
}

#parse opts
while getopts "m:w:o:b:f:s:lh" arg
do
    case $arg in
        m)
            MODLE=$OPTARG
            ;;
        w)
            WEIGHTS=$OPTARG
            ;;
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        b) 
            BOARD=$OPTARG
            ;;
        f)
            OPTIM_FILE=$OPTARG
            ;;
        s)
            BATCH_SIZE=$OPTARG
            ;;
        l)
            echo xc7z045ffg900-2, xc7z035ffg676-2, xcku115-flva1517-2-e
            exit 0
            ;;
        h)
			print_help
            exit 0
            ;;           
        ?)
			print_help
            exit 1
            ;;
    esac
done

python -c "import caffe"
if [ $? != 0 ]; then
	echo -e "\nError. Caffe environment is not detected in current environment."
	echo "Please make sure caffe python is complied by command \"make pycaffe\""
	echo "or make sure export variable PYTHONPATH=/path/to/caffe/python."
	exit 1
fi

#check the input files and output dir
if [ ! -f $MODLE ]; then
  echo "$0: cannot find file '$MODLE': No such file or directory"
  exit 1
fi
if [ ! -f $WEIGHTS ]; then
  echo "$0: cannot find file '$WEIGHTS': No such file or directory"
  exit 1
fi
if [ -d $OUTPUT_DIR ]; then
  echo "$0: Output directory '$OUTPUT_DIR' has already existed."
  exit 1
fi

FPGA_TYPE=$BOARD
#check if use the optim file
ARGS="$MODLE $WEIGHTS"
if [ $OPTIM_FILE ]; then
    if [ ! -f $OPTIM_FILE ]; then
      echo "$0: cannot find file '$OPTIM_FILE': No such file or directory"
      exit 1
    fi
    ARGS="$ARGS --optim_file $OPTIM_FILE"
fi
ARGS="$ARGS --fpga_type $FPGA_TYPE"

if [ $BATCH_SIZE ]; then
    ARGS="$ARGS --batch_size $BATCH_SIZE"
fi

echo $ARGS
#perform the model to RTL code converion
python codegen.py $ARGS
ret=$?
if [ $ret -ne 0 ]
then
    echo "$0: AccDNN service failed, exist with : $ret"
    exit $ret
fi

mkdir -p $OUTPUT_DIR
#copy the generate file to output dir
cp -r ./build $OUTPUT_DIR/ && cp -r ./lib $OUTPUT_DIR/

#copy acc src files
mkdir -p $OUTPUT_DIR/acc

while read line
do
    cp $OUTPUT_DIR/$line $OUTPUT_DIR/acc
done < $OUTPUT_DIR/build/imp_file.f

# copy the compile script
cp bin/compile.sh $OUTPUT_DIR/

# board type information
echo $BOARD >> $OUTPUT_DIR/board.txt
