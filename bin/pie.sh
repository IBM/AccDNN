#!/bin/bash


board_list=()
chip_list=()

get_hardware(){
	if [ -z $FPGA_SDK_PATH ]; then
		echo "Variable \"FPGA_SDK_PATH\" is not set."
		echo "Please export this variable in current environment."
		exit 1
	fi

	sdk_package=`find $FPGA_SDK_PATH -maxdepth 2 -name psl_fpga.tcl | sed "s/\/psl_fpga.tcl//" | sed "s/.*\///"`
	package_list=($sdk_package)

	i=0
	for package in ${package_list[@]}; do
		if [ -f $FPGA_SDK_PATH/$package/chip_define ]; then
			source $FPGA_SDK_PATH/$package/chip_define
			board_list[i]=$package
			chip_list[i]=$CHIP_NAME
			let i++
		fi
	done
}

echo_hardware(){
	get_hardware

	if [ -z $board_list ]; then
		echo "Can not find any valid SDK package in path :$FPGA_SDK_PATH"
		return
	fi

    #echo -e "\nSupported FPGA board:"
	echo -e "\n    === FPGA Board : FPGA Chip ==="
	i=0
	for board in ${board_list[@]}; do
		echo $board : ${chip_list[i]}
		let i++
	done
}


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
            echo_hardware
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

if [ -z $VIVADO_PATH ]; then
	echo "Variable \"VIVADO_PATH\" is not set."
	echo "Please export this variable in current environment."
	exit 1
fi

if [ -z $FPGA_SDK_PATH ]; then
	echo "Variable \"FPGA_SDK_PATH\" is not set."
	echo "Please export this variable in current environment."
	exit 1
fi

if [ ! -f $VIVADO_PATH/vivado ]; then
	echo "Can not find $VIVADO_PATH/vivado"
	echo "Please check the variable \"VIVADO_PATH\" in current environment."
	exit 1
fi

# Scan the supported SDK pakcage for target FPGA board
get_hardware
if [ -z $board_list ]; then
	echo "Can not find any valid SDK package in path :$FPGA_SDK_PATH"
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


#check if the board is supported
CHECK_RESULT=false
i=0
for board in ${board_list[@]}; do
	if [ $board = $BOARD ]; then
        CHECK_RESULT=true
        FPGA_TYPE=${chip_list[i]}
	fi
	let i++
done
if [ $CHECK_RESULT = false ];then
    echo "$0: Board '$BOARD' is not supported. please use '$0 -l' to get supported boards"
    exit 1
fi  
echo $FPGA_TYPE



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
#echo $ARGS
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
#run the tcl file to generate the dependent ipcores
echo -e "$0: Start to Generate ipcores.\n"
cd $OUTPUT_DIR/ && $VIVADO_PATH/vivado -mode batch -source ./build/ips.tcl -notrace && cd -

FPGA_PROJECT=$OUTPUT_DIR/$BOARD
cp -r $FPGA_SDK_PATH/$BOARD $OUTPUT_DIR

#add the depdence file to the vivoda project/XILINX SDK Project
echo -e "$0: Add file to Vivado Project.\n"
cat $OUTPUT_DIR/build/file_list.txt >> $FPGA_PROJECT/Sources/prj/psl_fpga.prj

#copy acc src files
mkdir -p $FPGA_PROJECT/Sources/acc

while read line
do
    cp $OUTPUT_DIR/$line $FPGA_PROJECT/Sources/acc
done < $OUTPUT_DIR/build/imp_file.f

#copy ipcores
cp -r $OUTPUT_DIR/build/ips_prj/ips_prj.srcs/sources_1/ip/* $FPGA_PROJECT/Sources/cores

#copy timing file.
cp $OUTPUT_DIR/build/timing/dma_timing.xdc $FPGA_PROJECT/Sources/xdc

#copy config file
cp $OUTPUT_DIR/build/parameters.v $FPGA_PROJECT/Sources/afu

# compile FPGA using vivado
echo -e "$0: Start to Synthesize and Implement.\n"
cd $FPGA_PROJECT && $VIVADO_PATH/vivado -mode batch -source psl_fpga.tcl -notrace && cd -
if [ ! -f $FPGA_PROJECT/Implement/psl_fpga/psl_fpga_route_design.dcp ]; then
    exit 1
fi
echo -e "$0: Start to generate FPGA bit file.\n"
cd $FPGA_PROJECT && $VIVADO_PATH/vivado -mode batch -source write_bitstream.tcl -notrace && cd -
if [ ! -f $FPGA_PROJECT/AccDNN.bin ]; then
    exit 1
fi
python freqency.py $FPGA_PROJECT/Implement/psl_fpga/reports/psl_fpga_timing_summary.rpt $OUTPUT_DIR/pie-run.conf
cp $OUTPUT_DIR/build/coe/weights.bin $OUTPUT_DIR/weights.bin
echo "$0: Successed. The fpga binary file has been write to $FPGA_PROJECT/AccDNN.bin"
echo "$0: The weights file has been writed to $OUTPUT_DIR/weights.bin"
echo "$0: The frequency config file has been write to $OUTPUT_DIR/pie-run.conf"

