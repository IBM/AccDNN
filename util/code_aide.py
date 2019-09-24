#!/usr/bin/env python

from settings import *
import math

def code_module_header_gen(module_name, ios):
    code_str = 'module ' + module_name + '(\n' + \
               '    clk,\n' + \
               '    rst,\n'

    for k, v in ios.items():
        code_str += '    ' + k + ',\n'
    code_str = code_str[:-2] #remove the last ','

    code_str += ');\n\n'

    code_str += 'input clk;\n'+ \
                'input rst;\n'
    code_str += code_signals_gen(ios)
    code_str += '\n'
    return code_str


def code_signals_gen(signals):
    code_str = ''
    for k, v in signals.items():
        if v[0] > 1: 
            code_str += v[1] + '[' + str(v[0] - 1) + ':0]\t' + k + ';\n' 
        else:
            code_str += v[1] + '\t' + k + ';\n'
    code_str += '\n'
    return code_str

def code_instance_gen(module_name, blob_din_name, blob_din_en_name, blob_din_rdy_name, blob_din_eop_name, \
                     blob_dout_name, blob_dout_en_name, blob_dout_rdy_name, blob_dout_eop_name, param_list=None, instance_num=0):
    code_str = ''
    if param_list:
        code_str += module_name + ' #( \n'
        for param in param_list:
            code_str += '.' + param[0] + '(' + param[1] + '),\n'
        code_str = code_str[:-2] + ')\n'
        code_str += 'u' + str(instance_num) + '_' + module_name + '(\n'
    else:
        code_str += module_name + ' u' + str(instance_num) + '_' + module_name + '(\n'

    code_str +='.clk(clk),\n' + \
               '.rst(rst),\n' + \
               '.blob_din(' + blob_din_name + '),\n' + \
               '.blob_din_en(' + blob_din_en_name + '),\n' + \
               '.blob_din_rdy(' + blob_din_rdy_name + '),\n' + \
               '.blob_din_eop(' + blob_din_eop_name + '),\n' + \
               '.blob_dout(' + blob_dout_name + '),\n' + \
               '.blob_dout_en(' + blob_dout_en_name + '),\n' + \
               '.blob_dout_rdy(' + blob_dout_rdy_name + '),\n' + \
               '.blob_dout_eop(' + blob_dout_eop_name + '));\n\n'
    return code_str

def code_instance_ddr_gen(module_name, blob_din_name, blob_din_en_name, blob_din_rdy_name, blob_din_eop_name, \
                     blob_dout_name, blob_dout_en_name, blob_dout_rdy_name, blob_dout_eop_name, \
                     ddr_read_req_name, ddr_read_ack_name, ddr_read_start_addr_name, ddr_read_req_length_name, \
                     ddr_dout_name, ddr_dout_en_name, ddr_dout_eop_name, instance_num=0):
    code_str = module_name + ' u' + str(instance_num) + '_' + module_name + '(\n' + \
               '.clk(clk),\n' + \
               '.rst(rst),\n' + \
               '.blob_din(' + blob_din_name + '),\n' + \
               '.blob_din_en(' + blob_din_en_name + '),\n' + \
               '.blob_din_rdy(' + blob_din_rdy_name + '),\n' + \
               '.blob_din_eop(' + blob_din_eop_name + '),\n' + \
               '.blob_dout(' + blob_dout_name + '),\n' + \
               '.blob_dout_en(' + blob_dout_en_name + '),\n' + \
               '.blob_dout_rdy(' + blob_dout_rdy_name + '),\n' + \
               '.blob_dout_eop(' + blob_dout_eop_name + '),\n' + \
               '.dma_engineer_req(' + ddr_read_req_name + '),\n' + \
               '.dma_engineer_ack(' + ddr_read_ack_name + '),\n' + \
               '.dma_engineer_start_addr(' + ddr_read_start_addr_name + '),\n' + \
               '.dma_engineer_length(' + ddr_read_req_length_name+ '),\n' + \
               '.dma_engineer_dout(' + ddr_dout_name + '),\n' + \
               '.dma_engineer_dout_en(' + ddr_dout_en_name + '),\n' + \
               '.dma_engineer_dout_eop(' + ddr_dout_eop_name + '));\n\n'

    return code_str

def code_dma_delay_gen(delays, ddr_data_width=DDR_DATA_WIDTH, instance_num=0):    
    inter_signals = {}
    for dma_idx in range(DDR_DMA_ENGINE_NUM):
        inter_signals['layer_ddr_read_req_'+str(dma_idx)] = tuple([1, 'wire'])
        inter_signals['layer_ddr_read_length_'+str(dma_idx)] = tuple([27, 'wire'])
        inter_signals['layer_ddr_read_addr_'+str(dma_idx)] = tuple([27, 'wire'])
        inter_signals['layer_ddr_read_ack_'+str(dma_idx)] = tuple([1, 'wire'])
        inter_signals['layer_ddr_dout_'+str(dma_idx)] = tuple([ddr_data_width, 'wire'])
        inter_signals['layer_ddr_dout_en_'+str(dma_idx)] = tuple([1, 'wire'])
        inter_signals['layer_ddr_dout_eop_'+str(dma_idx)] = tuple([1, 'wire'])
    code_str = code_signals_gen(inter_signals)

    module_name = 'ddr_read_delay'
    code_str += module_name + ' #(\n'
    code_str += '.DDR_DATA_WIDTH('+ str(ddr_data_width)+'),\n'
    for dma_idx in range(DDR_DMA_ENGINE_NUM):
        code_str += '.delay_req_port' + str(dma_idx) + '('+ str(delays[dma_idx])+'),\n'
    code_str = code_str[:-2] + ')\n'
    code_str += 'u' + str(instance_num) + '_' + module_name + '(\n' + \
                '.clk(clk),\n' + \
                '.rst(rst),\n'
    for dma_idx in range(DDR_DMA_ENGINE_NUM):
        code_str += '.engine_ddr_read_req_'+str(dma_idx)+'_o(ddr_read_req_' + str(dma_idx) + '),\n' + \
                    '.engine_ddr_read_length_'+str(dma_idx)+'_o(ddr_read_length_' + str(dma_idx) + '),\n' + \
                    '.engine_ddr_read_addr_'+str(dma_idx)+'_o(ddr_read_start_addr_' + str(dma_idx) + '),\n' + \
                    '.engine_ddr_read_ack_'+str(dma_idx)+'_i(ddr_read_ack_' + str(dma_idx) + '),\n' 
    code_str += '.engine_ddr_dout_i(ddr_dout),\n' + \
                '.engine_ddr_dout_en_i(ddr_dout_en),\n' + \
                '.engine_ddr_dout_eop_i(ddr_dout_eop),\n'
    
    for dma_idx in range(DDR_DMA_ENGINE_NUM):
        code_str += '.layer_ddr_read_req_'+str(dma_idx)+'_i(layer_ddr_read_req_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_read_length_'+str(dma_idx)+'_i(layer_ddr_read_length_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_read_addr_'+str(dma_idx)+'_i(layer_ddr_read_addr_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_read_ack_'+str(dma_idx)+'_o(layer_ddr_read_ack_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_dout_'+str(dma_idx)+'_o(layer_ddr_dout_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_dout_en_'+str(dma_idx)+'_o(layer_ddr_dout_en_' + str(dma_idx) + '),\n' + \
                    '.layer_ddr_dout_eop_'+str(dma_idx)+'_o(layer_ddr_dout_eop_' + str(dma_idx) + '),\n'
    code_str = code_str[:-2] + ');\n\n'

    return code_str

def interlayer_fifo_gen(width, depth):
    depth_power2 = max(1, int(math.ceil(math.log(float(depth)) / math.log(2.0))))
    
    code_str = ''
    code_str += 'wire empty_fifo;\n' + \
                'wire blob_dout_eop_tmp;\n' + \
                'assign blob_dout_en = blob_dout_rdy & (~empty_fifo);\n' + \
                'assign blob_dout_eop = blob_dout_en & blob_dout_eop_tmp;\n'
    code_str += 'interlayer_sync_fifo' + ' #(\n' + \
                   '.aw(' + str(depth_power2) + '),\n' + \
                   '.dw(' + str(width + 1) + '),\n' + \
                   '.afull_t(' + str(depth) + '))\n' + \
                   'u_interlayer_sync_fifo (\n' + \
                   '.clk_i(clk),\n' + \
                   '.reset_i(rst),\n' + \
                   '.w_en_i(blob_dout_en_fifo), \n' + \
                   '.w_din_i({blob_dout_eop_fifo, blob_dout_fifo}),\n' + \
                   '.r_en_i(blob_dout_en),\n' + \
                   '.r_dout_o({blob_dout_eop_tmp, blob_dout}),\n' + \
                   '.empty_o(empty_fifo),\n' + \
                   '.w_num_used_o(),\n' + \
                   '.r_num_val_o(),\n' + \
                   '.afull_o(),\n' + \
                   '.full_o());\n'

    return code_str


                              
   
