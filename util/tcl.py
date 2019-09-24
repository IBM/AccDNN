#!/usr/bin/env python

from settings import *

def ipcore_tcl_gen(ips):
    tcl_str = ''
    for ip in ips:
        if ip['ip_name'] == 'blk_mem_gen':
            if ip['memory_type'] == 'Simple_Dual_Port_RAM':
                tcl_str += ''.join(['create_ip -name blk_mem_gen -vendor xilinx.com -library ip ',
                                   '-module_name %s\n'%ip['module_name']])
                tcl_str += ''.join(['set_property -dict [list ',
                                   'CONFIG.Memory_Type {Simple_Dual_Port_RAM} ',
                                   'CONFIG.Write_Width_A {%d} '%ip['wr_width'],
                                   'CONFIG.Write_Depth_A {%d} '%ip['wr_depth'],
                                   'CONFIG.Write_Width_B {%d} '%ip['rd_width'],
                                   'CONFIG.Enable_A {Always_Enabled} ',
                                   'CONFIG.Enable_B {Always_Enabled}] ',
                                   #'CONFIG.Read_Width_A {%d} '%ip['wr_width'],
                                   #'CONFIG.Operating_Mode_A {NO_CHANGE} ',
                                   #'CONFIG.Read_Width_B {%d} '%ip['rd_width'],
                                   #'CONFIG.Register_PortA_Output_of_Memory_Primitives {false} ',
                                   #'CONFIG.Register_PortB_Output_of_Memory_Primitives {true} ',
                                   #'CONFIG.Port_B_Clock {100} ',
                                   #'CONFIG.Port_B_Enable_Rate {100}] ',
                                   '[get_ips %s]\n'%ip['module_name']])
            
            elif ip['memory_type'] == 'Single_Port_ROM':
                tcl_str += ''.join(['create_ip -name blk_mem_gen -vendor xilinx.com -library ip ',
                                   '-module_name %s\n'%ip['module_name']])
                tcl_str += ''.join(['set_property -dict [list ',
                                   'CONFIG.Memory_Type {Single_Port_ROM} ',
                                   'CONFIG.Write_Width_A {%d} '%ip['rd_width'],
                                   'CONFIG.Write_Depth_A {%d} '%ip['rd_depth'],
                                   #'CONFIG.Read_Width_A {%d} '%ip['rd_width'],
                                   #'CONFIG.Write_Width_B {%d} '%ip['rd_width'],
                                   #'CONFIG.Read_Width_B {%d} '%ip['rd_width'],
                                   'CONFIG.Enable_A {Always_Enabled} ',
                                   'CONFIG.Load_Init_File {true} ',
                                   'CONFIG.Coe_File {%s} '%(ip['coe_path']),
                                   'CONFIG.Fill_Remaining_Memory_Locations {true}] ',
                                   #'CONFIG.Register_PortB_Output_of_Memory_Primitives {false} ',
                                   #'CONFIG.Port_A_Write_Rate {0} ',
                                   #'CONFIG.Port_B_Clock {0} ',
                                   #'CONFIG.Port_B_Enable_Rate {0}] ',
                                   '[get_ips %s]\n'%ip['module_name']])
            else:
                raise Exception('Block Memory type is not supported.')

        elif ip['ip_name'] == 'dist_mem_gen':
            if ip['memory_type'] == 'simple_dual_port_ram':
                tcl_str += ''.join(['create_ip -name dist_mem_gen -vendor xilinx.com -library ip ',
                                   '-module_name %s\n'%ip['module_name']])
                tcl_str += ''.join(['set_property -dict [list ',
                                   'CONFIG.memory_type {simple_dual_port_ram} ',
                                   'CONFIG.data_width {%d} '%ip['wr_width'],
                                   'CONFIG.depth {%d}] '%ip['wr_depth'],
                                   '[get_ips %s]\n'%ip['module_name']])
            else:
                raise Exception('Block Memory type is not supported.')

        else:
            raise Exception('IP Core type is not supported.')
        #Generate_target
        tcl_str += ''.join([ \
        'generate_target all [get_files  $src_path/sources_1/ip/%s/%s.xci]\n\n' \
                 %(ip['module_name'], ip['module_name'])])
        if not SIMULATION_ONLY:
            tcl_str += ''.join([ \
                          'create_ip_run [get_files -of_objects [get_fileset sources_1] $src_path/sources_1/ip/%s/%s.xci]\n' \
                              %(ip['module_name'], ip['module_name']), \
                          'launch_run  %s_synth_1\n'%(ip['module_name']), \
                          'wait_on_run %s_synth_1\n\n'%(ip['module_name'])])
    return tcl_str

