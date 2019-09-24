create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul16_signed
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Signed} CONFIG.PortAWidth {16} CONFIG.PortBType {Signed} CONFIG.PortBWidth {16} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul16_signed]
generate_target all [get_files  $src_path/sources_1/ip/mul16_signed/mul16_signed.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] $src_path/sources_1/ip/mul16_signed/mul16_signed.xci]
launch_run mul16_signed_synth_1
wait_on_run mul16_signed_synth_1

create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul16_unsigned
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Unsigned} CONFIG.PortAWidth {16} CONFIG.PortBType {Unsigned} CONFIG.PortBWidth {16} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul16_unsigned]
generate_target all [get_files  $src_path/sources_1/ip/mul16_unsigned/mul16_unsigned.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] $src_path/sources_1/ip/mul16_unsigned/mul16_unsigned.xci]
launch_run mul16_unsigned_synth_1
wait_on_run mul16_unsigned_synth_1

create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul16x16_signed
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Signed} CONFIG.PortAWidth {16} CONFIG.PortBType {Signed} CONFIG.PortBWidth {16} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul16x16_signed]
generate_target all [get_files  $src_path/sources_1/ip/mul16x16_signed/mul16x16_signed.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] $src_path/sources_1/ip/mul16x16_signed/mul16x16_signed.xci]
launch_run mul16x16_signed_synth_1
wait_on_run mul16x16_signed_synth_1

create_ip -name mult_gen -vendor xilinx.com -library ip -module_name mul24x8_signed
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Signed} CONFIG.PortAWidth {24} CONFIG.PortBType {Signed} CONFIG.PortBWidth {8} CONFIG.Multiplier_Construction {Use_Mults}] [get_ips mul24x8_signed]
generate_target all [get_files  $src_path/sources_1/ip/mul24x8_signed/mul24x8_signed.xci]

create_ip_run [get_files -of_objects [get_fileset sources_1] $src_path/sources_1/ip/mul24x8_signed/mul24x8_signed.xci]
launch_run mul24x8_signed_synth_1
wait_on_run mul24x8_signed_synth_1




