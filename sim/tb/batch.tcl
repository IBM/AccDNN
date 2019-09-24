vlib work
vmap work work

#compile the model
vlog ./model_tb.v ../lib/blk_mem_gen_v8_1.v ../lib/glbl.v ../src/*.v \
	 ../lib/ddr/*.v ../lib/ddr/clocking/*.v ../lib/ddr/controller/*.v ../lib/ddr/ecc/*.v ../lib/ddr/ip_top/*.v \
     ../lib/ddr/phy/*.v ../lib/ddr/sim/*.v ../lib/ddr/ui/*.v ../lib/dma/*.v \
     -novopt -time
	     
exec vmake > makefile.tb

# do simulation
vsim -L /home/uchen/xilinxlib/lib32/unisims_ver -L /home/uchen/xilinxlib/lib32/unimacro_ver -L /home/uchen/xilinxlib/lib32/secureip \
     -vopt -voptargs=+acc work.model_tb glbl

run -all
