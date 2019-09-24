from util.data import save2coe, mat2uint16
from util.misc import get_file_dependence, get_operator_delay
from layers.layer import Layer
import math
from util.math2 import is_power
from util.resource import get_brams
from settings import *
import ConfigParser
import numpy as np

class Convolution(Layer):
    def __init__(self, layer_name, input_shape, input_width, input_stride, output_shape,
                 params, stride, pad, cpf=1, kpf=1, group=1):

        super(Convolution, self).__init__(layer_name, 'Convolution', input_shape, input_width, input_stride, output_shape)
        self.params = params
        self.cpf = cpf
        self.kpf = kpf
        self.stride = stride
        self.pad = pad
        self.group = group
        self.dsp_split = False

        self.kernel_num = self.params[0].shape[0]
        self.kernel_shape = self.params[0].shape[1:]

        self.ddr_start_addr = 0 # by default
   
    def get_output_stride(self):
        return self.kernel_num / self.kpf  #KG*GROUP

    def module_params_compute(self, ddr_data_width=DDR_DATA_WIDTH):
        # check the input, output activation's width and the parameter's width.
        if self.input_dw > DW or self.output_dw > DW or self.param_ww > DW:
            raise Exception ('The input/output activations and weights\' width can\'t larger than {}.'.format(DW))
        if (not is_power(self.input_dw)) or (not is_power(self.output_dw)) or (not is_power(self.param_ww)):
            raise Exception ('The input/output activations and weights should be power of 2.')
        # check the CPF and KPF
        if (not is_power(self.cpf)) or (not is_power(self.kpf)):
           raise Exception ('The CPF/KPF should be power of 2.')
          
        # stride of the output data stream
        self.input_channel_group = self.input_shape[0] / self.input_width
        # check the kernel parallelism factor.
        if self.kpf > (self.kernel_num / self.group):
            raise Exception('%s: Kernel parallelism factor %d is too large, can not exceed %d.'
                            %(self.layer_name, self.kpf, self.kernel_num / self.group))
        # check the kernel parallelism factor.
        if self.cpf > (self.input_shape[0] / self.group): 
            raise Exception('%s: Kernel parallelism factor %d is too large, can not exceed %d.'
                            %(self.layer_name, self.cpf, self.input_shape[0]/self.group))

        # check bitwidth  compatibility
        if self.input_dw == 16:
            if self.param_ww not in [16, 8, 4]:
                raise Exception ('The bitwidth of weight should be 16/8/4 when input bitwidth is 16.')
        elif self.input_dw == 8:
            if self.param_ww not in [8, 4]:
                raise Exception ('The bitwidth of weight should be 8/4 when input bitwidth is 8.')
        else:
            raise Exception('The input bitwidth should be 16 or 8 bits')

        # one dsp could be used for two 8bits multipliers
        if self.input_dw == 8 and (self.kernel_num % 2) == 0: 
            self.dsp_split = True
            # kpf should be even whe dsp_split is true
            self.kpf = max(2, self.kpf) 
            print '%s:The dsp will be splited for two channels.'%(self.layer_name)
            #if self.kpf % 2 != 0:
            #    raise Exception('%s:KPF should be even when dsp is splited.'%(self.layer_name))

        self.output_width = self.kpf
        # compute the params of the reshape memory.
        self.rm_wr_width = self.input_width * self.input_dw
        self.rm_ring_length = self.stride + self.kernel_shape[2] if self.stride > 0 else self.kernel_shape[2] + 1
        # only cache DB_C*DB_H*(WB_W+stride)
        self.rm_wr_depth = self.input_shape[0] *  self.input_shape[1] * self.rm_ring_length / self.input_width
        self.rm_rd_width = self.cpf * self.input_dw
        self.rm_rd_depth = self.rm_wr_width * self.rm_wr_depth / self.rm_rd_width
        
        # check the reshape memory alignment, otherwise the block memory ip will take error.
        if (max(self.rm_wr_width, self.rm_rd_width) % min(self.rm_wr_width, self.rm_rd_width)) != 0:
            raise Exception('Reshape Memory write and read width are not aligned.')

        # the block memory can not generate instance with write depth = 1  or read depth = 1
        # otherwiese its depth will be doubled
        if self.rm_wr_depth == 1 or self.rm_rd_depth == 1:
            self.rm_wr_depth = self.rm_wr_depth * 2
            self.rm_rd_depth = self.rm_rd_depth * 2
        # calculate the address width of the write and read port
        self.rm_wr_addr_width = int(math.ceil(math.log(float(self.rm_wr_depth)) / math.log(2.0)))
        self.rm_rd_addr_width = int(math.ceil(math.log(float(self.rm_rd_depth)) / math.log(2.0)))

        # Compute the size of the weight memory, to decide if use memory hierarchy
        if np.prod(self.kernel_shape) * self.kernel_num * self.param_ww  >= (WM_HIERARCHY_THRES * 1024 * 8):
            self.wm_hier_enable = True 

        # compute the params of the weight memory, use ping pong buffer
        if self.wm_hier_enable is True:
            self.wm_rd_width = self.cpf * self.param_ww * self.kpf
            self.wm_rd_depth = self.kernel_shape[0] * self.kernel_shape[1] * self.kernel_shape[2] / self.cpf
            self.wm_wr_width = ddr_data_width
            if (self.wm_rd_width * self.wm_rd_depth) % self.wm_wr_width == 0:
                # no padding
                self.wm_wr_depth = self.wm_rd_width * self.wm_rd_depth / self.wm_wr_width
            else:
                # with padding
                self.wm_wr_depth = self.wm_rd_width * self.wm_rd_depth / self.wm_wr_width + 1
                self.wm_rd_depth = self.wm_wr_width * self.wm_wr_depth / self.wm_rd_width
            # double the depth to form a ping-pong buf
            self.wm_wr_depth = self.wm_wr_depth * 2
            self.wm_rd_depth = self.wm_rd_depth * 2
        else:
            self.wm_rd_width = self.cpf * self.param_ww * self.kpf
            self.wm_rd_depth = np.prod(self.kernel_shape) * self.kernel_num / (self.cpf * self.kpf)
            self.wm_wr_width = self.wm_rd_width
            self.wm_wr_depth = self.wm_rd_depth
            # the block memory can not generate instance with write depth = 1  or read depth = 1
            # otherwiese its depth will be double
            if self.wm_wr_depth == 1 or self.wm_rd_depth == 1:
               self.wm_wr_depth = self.wm_wr_depth * 2
               self.wm_rd_depth = self.wm_rd_depth * 2

        self.wm_rd_addr_width = int(math.ceil(math.log(float(self.wm_rd_depth)) / math.log(2.0)))
        self.wm_wr_addr_width = int(math.ceil(math.log(float(self.wm_wr_depth)) / math.log(2.0)))

        if self.bn:
            # compute the params of the batch normalization
            self.bm_rd_width = self.bn_dw * 2 * self.kpf
        else:
            # compute the params of the bias memory
            self.bm_rd_width = self.param_ww * self.kpf
        self.bm_rd_depth = self.kernel_num / self.kpf
        if self.bm_rd_depth == 1:
            self.bm_rd_depth = self.bm_rd_depth * 2
        self.bm_rd_addr_width = int(math.ceil(math.log(float(self.bm_rd_depth)) / math.log(2.0)))

        if self.wm_rd_width > MAX_BUS_WIDTH:   #weight memory split
            raise Exception ('%s: Weight memory read width too large.'%self.layer_name)

        # check the delay of the operators to decide if needs to insert a fifo after the dout
        data_access_delay = 5
        self.operator_name = 'vector_muladd'
        access_operator_delay = data_access_delay + get_operator_delay(self.operator_name, self.cpf, self.bn) \
                                + (2 if self.dsp_split else 0)
        cycle_per_dout = self.kernel_shape[0] * self.kernel_shape[1] * self.kernel_shape[2] / self.cpf
       
        if cycle_per_dout <= access_operator_delay:
            print '%s: Too higher CPF, will insert a fifo before layer output.'%self.layer_name
            self.insert_fifo = True
            self.fifo_depth = int(math.ceil(float(access_operator_delay + 1) / float(cycle_per_dout)))

    def memory_coe_gen(self, ddr_data_width=DDR_DATA_WIDTH):
        KG = self.kernel_num / self.group / self.kpf
        CG = self.kernel_shape[0] / self.cpf
        param_group = np.array_split(self.params[0], self.group, axis = 0)

        weights_array = np.array([])
        weights_align = ddr_data_width / self.param_ww
        for param_cur in param_group:
            param_tmp = param_cur.transpose(0, 3, 2, 1) \
                          .reshape(self.kernel_num / self.group * self.kernel_shape[1] * self.kernel_shape[2] * CG, self.cpf)
            param_tmp = np.concatenate(np.array_split(param_tmp, self.kernel_num / self.group, axis = 0), axis = 1)
            weight_array_list = np.array_split(param_tmp, KG, axis = 1)
            for weight_mem in weight_array_list:
                weights = weight_mem.flatten()
                if (self.wm_hier_enable is True) and ((len(weights) % weights_align) != 0):
                    # if using memory hierarchy, should padding to ddr data bitwidth
                    weights = np.append(weights, np.zeros(weights_align - len(weights) % weights_align, dtype=float))
                weights_array = np.append(weights_array, weights)

        # if don't use memory hierarchy, will use ROM to store all the weights
        if self.wm_hier_enable is not True:
            file_path_name = MEM_COE_FILE_PATH + '/' + self.layer_name + '_wm_ram.coe'
            save2coe(file_path_name, weights_array.reshape(-1, self.cpf * self.kpf), self.param_ww, self.param_wq)
            mem_name = self.layer_name + '_wm_ram'
            wm_mif_file_path_name = IP_FILE_PATH + '/' + mem_name + '/' + mem_name + '.mif'

        # compute batch normalization parameters
        if self.bn:
            print self.bn[1]
            bn_scale = self.bn[2] / np.sqrt(self.bn[1] + 1e-10)
            bn_bias = self.bn[3] - self.bn[0] * self.bn[2] / np.sqrt(self.bn[1] + 1e-10)
            #print bn_scale, bn_bias
            # search the best quantization for scale and bias
            self.bn_scale_dq = int(math.floor(math.log(1.0/np.max(np.abs(bn_scale))) / math.log(2.0))) + 15
            self.bn_bias_dq = int(math.floor(math.log(1.0/np.max(np.abs(bn_bias))) / math.log(2.0))) + 15
            print 'Layer {}:\tSCALE_Q:{}, BIAS_Q:{}, SCALE_MAX:{}, BIAS:{}'\
                .format(self.layer_name, self.bn_scale_dq, self.bn_bias_dq, np.max(np.abs(bn_scale)), np.max(np.abs(bn_bias)))
            #normalize the bias Q to scale Q, in order to have a uniformed Q
            bn_bias = bn_bias * (2 ** self.bn_bias_dq) / (2 ** self.bn_scale_dq)
            bn_array = np.concatenate([bn_scale.reshape(-1, 1), bn_bias.reshape(-1, 1)], axis = 1)\
                         .reshape(KG * self.group, 2 * self.kpf)
        else:
            bias_array = self.params[1].reshape(KG * self.group, self.kpf)

        file_path_name = MEM_COE_FILE_PATH + '/' + self.layer_name + '_bm_ram.coe'
        if self.bn:
            save2coe(file_path_name, bn_array, self.bn_dw, self.bn_scale_dq)
        else:
            save2coe(file_path_name, bias_array, self.param_ww, self.param_wq)
        mem_name = self.layer_name + '_bm_ram'
        bm_mif_file_path_name = IP_FILE_PATH + '/' + mem_name + '/' + mem_name + '.mif'

        if self.wm_hier_enable is True:
            return mat2uint16(weights_array, self.param_ww, self.param_wq), [bm_mif_file_path_name]
        else:
            return [], [wm_mif_file_path_name, bm_mif_file_path_name]

    def ips_generate(self):
        self.ips = []
        #Reshape memory params generate, here we use block memory
        ip_info = {}
        ip_info['ip_name'] = 'blk_mem_gen'
        ip_info['module_name'] = self.layer_name + '_rm_ram'
        ip_info['memory_type'] = 'Simple_Dual_Port_RAM'
        ip_info['wr_width'] = self.rm_wr_width
        ip_info['wr_depth'] = self.rm_wr_depth
        ip_info['rd_width'] = self.rm_rd_width
        self.ips.append(ip_info)

        if self.wm_hier_enable is True:
            ip_info = {}
            ip_info['ip_name'] = 'blk_mem_gen'
            ip_info['module_name'] = self.layer_name + '_wm_ram'
            ip_info['memory_type'] = 'Simple_Dual_Port_RAM'
            ip_info['wr_width'] = self.wm_wr_width
            ip_info['wr_depth'] = self.wm_wr_depth
            ip_info['rd_width'] = self.wm_rd_width
            self.ips.append(ip_info)
        else:
            ip_info = {}
            ip_info['ip_name'] = 'blk_mem_gen'
            ip_info['module_name'] = self.layer_name + '_wm_ram'
            ip_info['memory_type'] = 'Single_Port_ROM'
            ip_info['rd_width'] = self.wm_rd_width
            ip_info['rd_depth'] = self.wm_rd_depth
            ip_info['coe_path'] = '../../../../../coe/' + '/' + ip_info['module_name'] + '.coe'
            self.ips.append(ip_info)            

        ip_info = {}
        ip_info['ip_name'] = 'blk_mem_gen'
        ip_info['module_name'] = self.layer_name + '_bm_ram'
        ip_info['memory_type'] = 'Single_Port_ROM'
        ip_info['rd_width'] = self.bm_rd_width
        ip_info['rd_depth'] = self.bm_rd_depth
        ip_info['coe_path'] = '../../../../../coe/' + '/' + ip_info['module_name'] + '.coe'
        self.ips.append(ip_info)
        
        return self.ips

    def ios_generate(self, batch_size=1, ddr_data_width=DDR_DATA_WIDTH):
        #input and output signal
        self.ios['blob_din'] = tuple([self.input_width * self.input_dw * batch_size, 'input'])
        self.ios['blob_din_en'] = tuple([1, 'input'])
        self.ios['blob_din_rdy'] = tuple([1, 'output'])
        self.ios['blob_din_eop'] = tuple([1, 'input'])
       
        self.ios['blob_dout'] =  tuple([self.output_width * self.output_dw * batch_size, 'output'])
        self.ios['blob_dout_en'] = tuple([1, 'output'])
        self.ios['blob_dout_rdy'] = tuple([1, 'input'])
        self.ios['blob_dout_eop'] = tuple([1, 'output'])

        if self.wm_hier_enable is True:
            # DMA interface for weights memory
            self.ios['dma_engineer_req'] = tuple([1, 'output'])
            self.ios['dma_engineer_ack'] = tuple([1, 'input'])
            self.ios['dma_engineer_dout_en'] = tuple([1, 'input'])
            self.ios['dma_engineer_dout'] = tuple([ddr_data_width, 'input'])
            self.ios['dma_engineer_dout_eop'] = tuple([1, 'input'])
            self.ios['dma_engineer_start_addr'] = tuple([27, 'output'])
            self.ios['dma_engineer_length'] = tuple([27, 'output'])
        
    def wires_generate(self, batch_size=1):
        #internal interconnection wire
        self.wires = {}
        for batch_idx in range(batch_size):
            self.wires['op_data_' + str(batch_idx)] = tuple([self.rm_rd_width, 'wire'])
        self.wires['rm_wr_en'] = tuple([1, 'wire'])
        self.wires['rm_wr_addr'] = tuple([self.rm_wr_addr_width, 'wire'])
        self.wires['rm_rd_addr'] = tuple([self.rm_rd_addr_width, 'wire'])

        if self.wm_hier_enable is True:
            self.wires['double_buf_wr_en'] = tuple([1, 'wire'])
            self.wires['double_buf_wr_addr'] = tuple([self.wm_wr_addr_width, 'wire'])
        
        self.wires['double_buf_rd_addr'] = tuple([self.wm_rd_addr_width, 'wire'])
        
        self.wires['op_weight'] = tuple([self.wm_rd_width, 'wire'])
        self.wires['bm_rd_addr'] = tuple([self.bm_rd_addr_width, 'wire'])
        self.wires['op_bias'] = tuple([self.bm_rd_width, 'wire'])

        self.wires['op_din_eop'] = tuple([1, 'wire'])
        self.wires['op_din_en'] = tuple([1, 'wire'])

        instance_num = self.kpf if self.dsp_split is False else self.kpf/2
        data_channel_num = 2 if self.dsp_split is True else 1
        for batch_idx in range(batch_size):  
            for i in range(instance_num):
                wire_name = 'op_dout_' + str(batch_idx) + '_' + str(i)
                self.wires[wire_name] = tuple([self.output_dw * data_channel_num, 'wire']) 

    def code_ram_gen(self, batch_size=1):
        # reshape memory generate
        code_str = ''
        rm_wr_width = self.input_width * self.input_dw
        for batch_idx in range(batch_size):
            code_str += self.layer_name + '_rm_ram u_' + self.layer_name + '_rm_ram_' + str(batch_idx) +'(\n' + \
                    '.clka(clk),\n' + \
                    '.wea(rm_wr_en),\n' + \
                    '.addra(rm_wr_addr),\n' + \
                    '.dina(blob_din[' + str(rm_wr_width * (batch_idx + 1)-1)+':'+ str(rm_wr_width * batch_idx)+ ']),\n' + \
                    '.clkb(clk),\n' + \
                    '.addrb(rm_rd_addr),\n' + \
                    '.doutb(op_data_' + str(batch_idx) + '));\n\n'

        if self.wm_hier_enable is True:
            # weights memory
            code_str += self.layer_name + '_wm_ram u_' + self.layer_name + '_wm_ram(\n' + \
                    '.clka(clk),\n' + \
                    '.wea(double_buf_wr_en),\n' + \
                    '.addra(double_buf_wr_addr),\n' + \
                    '.dina(dma_engineer_dout),\n' + \
                    '.clkb(clk),\n' + \
                    '.addrb(double_buf_rd_addr),\n' + \
                    '.doutb(op_weight));\n\n'
        else:
            code_str += self.layer_name + '_wm_ram u_' + self.layer_name + '_wm_ram(\n' + \
                    '.clka(clk),\n' + \
                    '.addra(double_buf_rd_addr),\n' + \
                    '.douta(op_weight));\n\n'
        # bias
        code_str += self.layer_name + '_bm_ram u_' + self.layer_name + '_bm_ram(\n' + \
                    '.clka(clk),\n' + \
                    '.addra(bm_rd_addr),\n' + \
                    '.douta(op_bias));\n\n'

        return code_str

    def code_controller_gen(self):
        self.controller_name = 'controller_v2' if self.wm_hier_enable is True else 'controller_v2_b'
        data_access_delay = 5
        operator_delay = get_operator_delay(self.operator_name, self.cpf, self.bn) + (2 if self.dsp_split else 0)
        rm_rd_phy_addr_jump = self.input_shape[2] - self.stride * (self.output_shape[2] - 1) if self.stride > 0 else 1

        code_str = self.controller_name + ' #(\n' + \
                   '.DB_W_IN (' + str(self.input_shape[2]) + '),\n' + \
                   '.DB_H_IN (' + str(self.input_shape[1]) + '),\n' + \
                   '.DB_C_IN (' + str(self.input_shape[0]) + '),\n' + \
                   '.DB_W_OUT (' + str(self.output_shape[2]) + '),\n' + \
                   '.DB_H_OUT (' + str(self.output_shape[1]) + '),\n' + \
                   '.DB_C_OUT (' + str(self.output_shape[0]) + '),\n' + \
                   '.WB_W (' + str(self.kernel_shape[2]) + '),\n' + \
                   '.WB_H (' + str(self.kernel_shape[1]) + '),\n' + \
                   '.WB_C (' + str(self.kernel_shape[0]) + '),\n' + \
                   '.WB_K (' + str(self.kernel_num / self.group) + '),\n' + \
                   '.GROUP (' + str(self.group) + '),\n' + \
                   '.RM_WR_ADDR_WIDTH (' + str(self.rm_wr_addr_width) + '),\n' + \
                   '.RM_WR_NUM_PER_CHANNEL (' + str(self.input_channel_group) + '),\n' + \
                   '.RM_WR_STRIDE (' + str(self.rm_wr_stride) + '),\n' + \
                   '.RM_RING_LENGTH (' + str(self.rm_ring_length) + '),\n' + \
                   '.RM_RD_PHY_ADDR_JUMP (' + str(rm_rd_phy_addr_jump) + '),\n' + \
                   '.RM_RD_ADDR_WIDTH (' + str(self.rm_rd_addr_width) + '),\n'
        if self.wm_hier_enable is True:
            code_str += '.DOUBLE_BUF_WR_DEPTH (' + str(self.wm_wr_depth) + '),\n' + \
                        '.DOUBLE_BUF_RD_DEPTH (' + str(self.wm_rd_depth) + '),\n' + \
                        '.DOUBLE_BUF_WR_ADDR_WIDTH (' + str(self.wm_wr_addr_width) + '),\n' + \
                        '.DOUBLE_BUF_RD_ADDR_WIDTH (' + str(self.wm_rd_addr_width) + '),\n'
        else:
            code_str += '.WM_RD_ADDR_WIDTH (' + str(self.wm_rd_addr_width) + '),\n'

        code_str +='.START_ADDR (' + str(self.ddr_start_addr) + '),\n' + \
                   '.LENGTH (' + str(self.wm_wr_depth / 2) + '),\n' + \
                   '.BM_RD_ADDR_WIDTH (' + str(self.bm_rd_addr_width) + '),\n' + \
                   '.CPF (' + str(self.cpf) + '),\n' + \
                   '.KPF (' + str(self.kpf) + '),\n' + \
                   '.STRIDE_H (' + str(self.stride) + '),\n' + \
                   '.STRIDE_W (' + str(self.stride) + '),\n' + \
                   '.PAD (' + str(self.pad) + '),\n' + \
                   '.OP_DELAY (' + str(operator_delay) + '))\n' + \
                   'u_controller(\n' + \
                   '.clk(clk),\n' + \
                   '.rst(rst),\n' + \
                   '.rm_wr_en(rm_wr_en), \n' + \
                   '.rm_wr_addr(rm_wr_addr),\n' + \
                   '.rm_rd_addr(rm_rd_addr),\n' + \
                   '.op_din_eop(op_din_eop),\n' + \
                   '.op_din_en(op_din_en),\n'
        if self.wm_hier_enable is True:
            code_str += '.double_buf_wr_en(double_buf_wr_en),\n' + \
                        '.double_buf_wr_addr(double_buf_wr_addr),\n'
        code_str +='.double_buf_rd_addr(double_buf_rd_addr),\n' + \
                   '.bm_rd_addr(bm_rd_addr),\n'
        if self.wm_hier_enable is True:
            code_str += '.dma_engineer_req(dma_engineer_req),\n' + \
                        '.dma_engineer_ack(dma_engineer_ack),\n' + \
                        '.dma_engineer_dout_en(dma_engineer_dout_en),\n' + \
                        '.dma_engineer_dout_eop(dma_engineer_dout_eop),\n' + \
                        '.dma_engineer_start_addr(dma_engineer_start_addr),\n' + \
                        '.dma_engineer_length(dma_engineer_length),\n'
        code_str +='.blob_din_rdy(blob_din_rdy),\n' + \
                   '.blob_din_en(blob_din_en), \n' + \
                   '.blob_din_eop(blob_din_eop),\n' + \
                   '.blob_dout_rdy(blob_dout_rdy),\n'
        if self.insert_fifo is False:
            code_str += '.blob_dout_en(blob_dout_en),\n' + \
                        '.blob_dout_eop(blob_dout_eop));\n\n'
        else:
            code_str += '.blob_dout_en(blob_dout_en_fifo),\n' + \
                        '.blob_dout_eop(blob_dout_eop_fifo));\n\n'

        return code_str

    def code_operator_gen(self, batch_size=1):
        code_str = ''
        instance_num = self.kpf if self.dsp_split is False else self.kpf/2
        data_channel = 2 if self.dsp_split is True else 1
        acc_width = 24 if self.dsp_split is True else 40
        for batch_idx in range(batch_size):
            for i in range(instance_num):
                # BN_SCALE_Q, BN_BIAS_Q, MID_Q is valid only when bn is enabled.
                # BIAS_DW and op_bias signal was reused by batch normalization.
                code_str += self.operator_name + ' #(' + \
                        '.CPF('+ str(self.cpf)+'),\n' + \
                        '.RELU('+ str(self.hasrelu)+'),\n' + \
                        '.BN('+ str(1 if self.bn else 0)+'),\n' + \
                        '.DIN_Q('+ str(self.input_dq)+'),\n' + \
                        '.DOUT_Q('+ str(self.output_dq)+'),\n' + \
                        '.BN_SCALE_Q('+ str(self.bn_scale_dq)+'),\n' + \
                        '.BN_BIAS_Q('+ str(self.bn_bias_dq)+'),\n' + \
                        '.MID_Q('+ str(self.mid_dq)+'),\n' + \
                        '.BIAS_DW('+ str(2 * MAX_DW if self.bn else max(8, self.param_ww))+'),\n' + \
                        '.Q(' + str(self.param_wq) + '),\n' + \
                        '.DIN_DW('+ str(self.input_dw)+ '), \n' + \
                        '.DOUT_DW('+ str(self.output_dw)+ '), \n' + \
                        '.DATA_CHANNEL('+ str(data_channel) + '), \n' + \
                        '.ACC_WIDTH('+ str(acc_width) + '), \n' + \
                        '.WW(' + str(max(8, self.param_ww) if self.dsp_split is True else MAX_DW) + '))\n' + \
                        'u_' + self.operator_name + '_' + str(batch_idx) + '_'+ str(i) + '(\n' + \
                        '.clk(clk),\n' + \
                        '.rst(rst),\n' + \
                        '.op_din_en(op_din_en),\n' + \
                        '.op_din_eop(op_din_eop),\n'

                if self.input_dw == 8 and self.dsp_split is False:
                    # only occurs when kernel number is odd.
                    op_data_name = 'op_data_' + str(batch_idx)
                    code_str +='.op_din({{8{%s[7]}}, %s}), \n'%(op_data_name, op_data_name)
                else:
                    code_str +='.op_din(op_data' + '_' + str(batch_idx) + '), \n'

                if self.param_ww == MAX_DW:
                    code_str += '.op_weight(op_weight[' + str(self.param_ww * data_channel * self.cpf* (i+1)-1)+':' \
                                    +str(self.param_ww * data_channel * self.cpf*i) + ']),\n'
                elif self.dsp_split is True:
                    bitsel_base = self.param_ww * data_channel * self.cpf*i
                    weight_str = '}'
                    for j in range(self.cpf):
                        if self.param_ww == 8:
                            weight_str = ',op_weight[%d:%d],op_weight[%d:%d]'%\
                                     (bitsel_base + self.param_ww * self.cpf + self.param_ww*(j+1)-1, \
                                      bitsel_base + self.param_ww * self.cpf + self.param_ww*j,
                                      bitsel_base + self.param_ww*(j+1)-1, bitsel_base + self.param_ww*j) + weight_str
                        else:
                            weight_str = ',{{%d{op_weight[%d]}},op_weight[%d:%d]},{{%d{op_weight[%d]}},op_weight[%d:%d]}'%\
                                     (8 - self.param_ww, \
                                      bitsel_base + self.param_ww * self.cpf + self.param_ww*(j+1)-1, \
                                      bitsel_base + self.param_ww * self.cpf + self.param_ww*(j+1)-1, \
                                      bitsel_base + self.param_ww * self.cpf + self.param_ww*j, \
                                      8 - self.param_ww, \
                                      bitsel_base + self.param_ww*(j+1)-1, \
                                      bitsel_base + self.param_ww*(j+1)-1, \
                                      bitsel_base + self.param_ww*j) + weight_str
                    weight_str = '{'+weight_str[1:]
                    code_str += '.op_weight(' + weight_str + '),\n'
                else:
                    weight_str = '}'
                    for j in range(self.cpf):
                        weight_str = ',{{%d{op_weight[%d]}},op_weight[%d:%d]}'%(MAX_DW-self.param_ww, \
                              self.param_ww*self.cpf*i + self.param_ww*(j+1)-1, \
                              self.param_ww*self.cpf*i + self.param_ww*(j+1)-1, \
                              self.param_ww*self.cpf*i + self.param_ww*j) + weight_str
                    weight_str = '{'+weight_str[1:]
                    code_str += '.op_weight(' + weight_str + '),\n'
                if self.bn:
                    code_str += '.op_bias(op_bias[' + str(self.bn_dw * 2 * data_channel * (i + 1) - 1) + ':' \
                                    + str(self.bn_dw * data_channel * 2  * i) + ']),\n'
                else:
                    if self.param_ww == MAX_DW:
                        code_str += '.op_bias(op_bias[' + str(self.param_ww * data_channel * (i + 1) - 1) + ':' \
                                    + str(self.param_ww * data_channel * i) + ']),\n' 
                    elif self.dsp_split is True:
                        if self.param_ww == 8:
                            code_str += '.op_bias(op_bias[' + str(self.param_ww * data_channel * (i + 1) - 1) + ':' \
                                    + str(self.param_ww * data_channel * i) + ']),\n'
                        else:
                            code_str += '.op_bias({{%d{op_bias[%d]}},op_bias[%d:%d]}),\n'%(8-self.param_ww, \
                              self.param_ww*(i+1)-1, self.param_ww*(i+1)-1, self.param_ww*i)                            
                    else:
                        code_str += '.op_bias({{%d{op_bias[%d]}},op_bias[%d:%d]}),\n'%(MAX_DW-self.param_ww, \
                              self.param_ww*(i+1)-1, self.param_ww*(i+1)-1, self.param_ww*i)

                code_str +='.op_dout(op_dout_' + str(batch_idx) + '_' + str(i) + '));\n\n'

        code_str += 'assign blob_dout = {' if self.insert_fifo is False else 'assign blob_dout_fifo = {'
        for batch_idx in range(batch_size):
            for i in range(instance_num):
              code_str += 'op_dout_' + str(batch_size - 1 - batch_idx)+ '_' + str(instance_num - 1 - i) + ','
        code_str = code_str[:-1] #remove the last ','
        code_str += '};\n\n'
        return code_str
    
    def profile(self, batch_size=1):
        # Computation resource
        self.ops = self.output_shape[0] * self.output_shape[1] * self.output_shape[2] * \
              self.kernel_shape[0] * self.kernel_shape[1] * self.kernel_shape[2] * batch_size
        self.macs = self.ops
        self.dsps = self.kpf * self.cpf * batch_size
        self.multiplier = self.dsps
        if self.bn:
            self.dsps += self.kpf * batch_size
        self.dsps = self.dsps / 2 if self.dsp_split is True else self.dsps
        self.clocks = self.ops / (self.kpf * self.cpf * batch_size)

        # Memory resource
        # Reshape memory, multipy batch_size
        self.rm_size = self.rm_wr_width * self.rm_wr_depth * batch_size
        self.rm_blks = get_brams(self.rm_wr_width, self.rm_wr_depth, self.rm_rd_width, self.rm_rd_depth, True) * batch_size

        # Weights memory, only single instance
        self.weights_num = self.kernel_shape[0] * self.kernel_shape[1] * self.kernel_shape[2] * self.kernel_num
        self.wm_size =  self.wm_rd_width * self.wm_rd_depth
        self.wm_blks = get_brams(self.wm_wr_width, self.wm_wr_depth, self.wm_rd_width, self.wm_rd_depth, True)
        self.bm_size =  self.bm_rd_width * self.bm_rd_depth
        self.bm_blks = get_brams(self.bm_rd_width, self.bm_rd_depth, self.bm_rd_width, self.bm_rd_depth, True)
        
        # Bandwidth requirement
        if self.wm_hier_enable is True:
            self.ddr_bandwidth = float(self.wm_size / 2 * self.cpf) / float(self.output_shape[1] * self.kernel_shape[0] \
                * self.kernel_shape[1] * self.kernel_shape[2])
        else:
            self.ddr_bandwidth = 0.0

if __name__  == '__main__':
    pass
