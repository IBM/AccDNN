set fpga_part xc7vx690tffg1157-2
#set fpga_part xcku060-ffva1156-2-e
set project_name ips_$fpga_part
set project_path ./$project_name
set src_path $project_path/$project_name.srcs
set ip_path $src_path/sources_1/ip
create_project $project_name $project_path -part $fpga_part

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name acc_pll
set_property -dict [list CONFIG.PRIMITIVE {PLL} CONFIG.USE_PHASE_ALIGNMENT {false} CONFIG.PRIM_SOURCE {No_buffer} CONFIG.PRIM_IN_FREQ {250.000} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000}] [get_ips acc_pll]
generate_target all [get_files $ip_path/acc_pll/acc_pll.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_path/acc_pll/acc_pll.xci]
launch_run acc_pll_synth_1
wait_on_run acc_pll_synth_1

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name input_fifo
set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Builtin_FIFO} CONFIG.Performance_Options {First_Word_Fall_Through} CONFIG.Input_Data_Width {257} CONFIG.Input_Depth {512} CONFIG.Output_Data_Width {257} CONFIG.Output_Depth {512} CONFIG.Read_Clock_Frequency {125} CONFIG.Write_Clock_Frequency {250} CONFIG.Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant} CONFIG.Full_Threshold_Assert_Value {256}] [get_ips input_fifo]
generate_target all [get_files  $ip_path/input_fifo/input_fifo.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_path/input_fifo/input_fifo.xci]
launch_run input_fifo_synth_1
wait_on_run input_fifo_synth_1

create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name output_fifo
set_property -dict [list CONFIG.Fifo_Implementation {Independent_Clocks_Builtin_FIFO} CONFIG.Performance_Options {First_Word_Fall_Through} CONFIG.Input_Data_Width {257} CONFIG.Input_Depth {512} CONFIG.Output_Data_Width {257} CONFIG.Output_Depth {512} CONFIG.Read_Clock_Frequency {250} CONFIG.Write_Clock_Frequency {125} CONFIG.Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant} CONFIG.Full_Threshold_Assert_Value {256}] [get_ips output_fifo]
generate_target all [get_files  $ip_path/output_fifo/output_fifo.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_path/output_fifo/output_fifo.xci]
launch_run output_fifo_synth_1
wait_on_run output_fifo_synth_1

create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul16_signed
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Signed} CONFIG.PortAWidth {16} CONFIG.PortBType {Signed} CONFIG.PortBWidth {16} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul16_signed]
generate_target all [get_files  $ip_path/mul16_signed/mul16_signed.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_path/mul16_signed/mul16_signed.xci]
launch_run mul16_signed_synth_1
wait_on_run mul16_signed_synth_1

create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul16_unsigned
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Unsigned} CONFIG.PortAWidth {16} CONFIG.PortBType {Unsigned} CONFIG.PortBWidth {16} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul16_unsigned]
generate_target {instantiation_template} [get_files $ip_path/mul16_unsigned/mul16_unsigned.xci]
generate_target all [get_files  $ip_path/mul16_unsigned/mul16_unsigned.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_path/mul16_unsigned/mul16_unsigned.xci]
launch_run mul16_unsigned_synth_1
wait_on_run mul16_unsigned_synth_1
