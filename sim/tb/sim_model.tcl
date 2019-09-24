vlib work
vmap work work

proc comp_model {} {
    vlog \
	    ./model_tb.v \
        ../lib/blk_mem_gen_v8_1.v \
        ../lib/dist_mem_gen_v8_0.v \
        ../lib/glbl.v \
        -novopt \
        -time 
	vlog ../src/*.v \
         ../src/*.sv \
		 ../lib/ddr3_dma/*.v \
         ../lib/ddr_mode.sv \
     	-novopt \
		-time
	     
	exec vmake > makefile.tb
}

proc sim {} {
    #load simulation lib
    vsim -L /home/bjzhuc/xilinxlib/lib32/unisims_ver \
         -L /home/bjzhuc/xilinxlib/lib32/unimacro_ver \
		 -L /home/bjzhuc/xilinxlib/lib32/secureip	-voptargs=+acc work.model_tb glbl
    view wave
    radix h
#	add wave /model_tb/*
    do ../wave/cifar10.do
#    do ../wave/zf.do
#    do ../wave/tiny_yolov2.do
    view structure
    view signals
    view wave
    run -all	
}
