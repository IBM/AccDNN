#!/bin/bash

#run the tcl file to generate the dependent ipcores
echo -e "$0: Start to Generate ipcores.\n"
$VIVADO_PATH/vivado -mode batch -source ./build/ips.tcl -notrace

FPGA_PROJECT=$( cat board.txt )
#copy ipcores
cp -r ./build/ips_prj/ips_prj.srcs/sources_1/ip/* $FPGA_PROJECT/Sources/cores

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
python freqency.py $FPGA_PROJECT/Implement/psl_fpga/reports/psl_fpga_timing_summary.rpt ./pie-run.conf
cp ./build/coe/weights.bin ./weights.bin
echo "$0: Successed. The fpga binary file has been write to $FPGA_PROJECT/AccDNN.bin"
echo "$0: The weights file has been writed to ./weights.bin"
echo "$0: The frequency config file has been write to ./pie-run.conf"

