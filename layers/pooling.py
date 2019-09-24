from util.misc import get_file_dependence, get_operator_delay
from layers.layer import Layer
import math
from util.math2 import is_power
from util.resource import get_brams
from settings import *
import numpy as np

class Pooling(Layer):
    def __init__(self, layer_name, input_shape, input_width, input_stride, output_shape,
                 pool, kernel_size, stride, pad, kpf=1):

        super(Pooling, self).__init__(layer_name, 'Pooling', input_shape, input_width, input_stride, output_shape)
        self.pool = pool
        self.kernel_size = kernel_size
        self.stride = stride
        self.pad = pad
        self.kpf = kpf

        self.controller_name = 'controller_v2_a'
        if self.pool == 0:
            self.operator_name = 'vector_max'
        elif self.pool == 1:
            self.operator_name = 'vector_ave'
        else:
            raise Exception('Not supported pooling type.')

    def get_output_stride(self):
        return 1

    def module_params_compute(self, ddr_data_width=DDR_DATA_WIDTH):
        # check the CPF and KPF
        if not is_power(self.kpf):
            raise Exception ('The KPF should be power of 2.')

        self.input_channel_group = self.input_shape[0] / self.input_width
        #check the kernel parallelism factor.
        if self.kpf > self.input_shape[0]:
            raise Exception('%s: Kernel parallelism factor %d is too large, can not exceed %d.'
                            %(self.layer_name, self.kpf, self.input_shape[0]))

        self.output_width = self.kpf
        #compute the params of the reshape memory.
        self.rm_wr_width = self.input_width * self.input_dw
        # only cache DB_C*DB_H*(WB_W+stride)
        self.rm_ring_length = self.stride + self.kernel_size
        self.rm_wr_depth = self.input_shape[0] *  self.input_shape[1] * self.rm_ring_length / self.input_width
        self.rm_rd_width = self.kpf * self.input_dw
        self.rm_rd_depth = self.rm_wr_width * self.rm_wr_depth / self.rm_rd_width
        
        #check the reshape memory alignment, otherwise the block memory ip will take error.
        if (max(self.rm_wr_width, self.rm_rd_width) % min(self.rm_wr_width, self.rm_rd_width)) != 0:
            raise Exception('Reshape Memory write and read width are not aligned.')

        #Check if could use distributed memory instead of block memory to save block memory resource
        adjusted_depth = int(math.ceil(float(self.rm_wr_depth)/float(DIST_MEM_MIN_DEPTH)))*DIST_MEM_MIN_DEPTH
        if DIST_MEM_ENABLE and (self.rm_wr_width==self.rm_rd_width) and (self.rm_wr_width <= DIST_MEM_MAX_WIDTH) \
                           and adjusted_depth <=DIST_MEN_MAX_DEPTH:
            self.rm_type = 'dist'
            self.rm_wr_depth = adjusted_depth
            self.rm_rd_depth = self.rm_wr_depth

        #the block memory can not generate instance with write depth = 1  or read depth = 1
        #otherwiese its depth will be doubled
        if self.rm_wr_depth == 1 or self.rm_rd_depth == 1:
            self.rm_wr_depth = self.rm_wr_depth * 2
            self.rm_rd_depth = self.rm_rd_depth * 2
        #calculate the address width of the write and read port
        self.rm_wr_addr_width = int(math.ceil(math.log(float(self.rm_wr_depth)) / math.log(2.0)))
        self.rm_rd_addr_width = int(math.ceil(math.log(float(self.rm_rd_depth)) / math.log(2.0)))

        # check the delay of the operators to decide if needs to insert a fifo after the dout
        data_access_delay = 5 if self.rm_type == 'blk' else 3
        access_operator_delay = data_access_delay + get_operator_delay(self.operator_name)
        cycle_per_dout = self.kernel_size * self.kernel_size

        if cycle_per_dout <= access_operator_delay:
            print '%s: Too higher CPF, will insert a fifo before layer output.'%self.layer_name
            self.insert_fifo = True
            self.fifo_depth = int(math.ceil(float(access_operator_delay + 1) / float(cycle_per_dout)))

    def ips_generate(self):
        self.ips = []
        #Reshape memory params generate, here we use block memory
        ip_info = {}
        if self.rm_type == 'blk':
            ip_info['ip_name'] = 'blk_mem_gen'
            ip_info['memory_type'] = 'Simple_Dual_Port_RAM'
        else:
           ip_info['ip_name'] = 'dist_mem_gen'
           ip_info['memory_type'] = 'simple_dual_port_ram'
        ip_info['module_name'] = self.layer_name + '_rm_ram'
        ip_info['wr_width'] = self.rm_wr_width
        ip_info['wr_depth'] = self.rm_wr_depth
        ip_info['rd_width'] = self.rm_rd_width
        self.ips.append(ip_info)
        return self.ips

    def wires_generate(self, batch_size=1):
        #internal interconnection wire
        self.wires = {}
        for batch_idx in range(batch_size):
            self.wires['op_data_' + str(batch_idx)] = tuple([self.rm_rd_width, 'wire'])
        self.wires['rm_wr_en'] = tuple([1, 'wire'])
        self.wires['rm_wr_addr'] = tuple([self.rm_wr_addr_width, 'wire'])
        self.wires['rm_rd_addr'] = tuple([self.rm_rd_addr_width, 'wire'])

        self.wires['op_din_eop'] = tuple([1, 'wire'])
        self.wires['op_din_en'] = tuple([1, 'wire'])
        
        for batch_idx in range(batch_size):
            for i in range(self.kpf):
                wire_name = 'op_dout_' + str(batch_idx) + '_' + str(i)
                self.wires[wire_name] = tuple([self.output_dw, 'wire'])

    def code_ram_gen(self, batch_size=1):
        # reshape memory generate
        code_str = ''
        rm_wr_width = self.input_width * self.input_dw
        for batch_idx in range(batch_size):
            if self.rm_type == 'blk':
                code_str += self.layer_name + '_rm_ram u_' + self.layer_name + '_rm_ram_' + str(batch_idx) + '(\n' + \
                        '.clka(clk),\n' + \
                        '.wea(rm_wr_en),\n' + \
                        '.addra(rm_wr_addr),\n' + \
                        '.dina(blob_din[' + str(rm_wr_width * (batch_idx+1) -1) + ':' + str(rm_wr_width * batch_idx)+ ']),\n' + \
                        '.clkb(clk),\n' + \
                        '.addrb(rm_rd_addr),\n' + \
                        '.doutb(op_data_' + str(batch_idx) + '));\n\n'
            else:
                code_str += self.layer_name + '_rm_ram u_' + self.layer_name + '_rm_ram_' + str(batch_idx) + '(\n' + \
                        '.clk(clk),\n' + \
                        '.we(rm_wr_en),\n' + \
                        '.a(rm_wr_addr),\n' + \
                        '.d(blob_din[' + str(rm_wr_width * (batch_idx+1) -1) + ':' + str(rm_wr_width * batch_idx)+ ']),\n' + \
                        '.dpra(rm_rd_addr),\n' + \
                        '.dpo(op_data_' + str(batch_idx) + '));\n\n'
 
        return code_str

    def code_controller_gen(self):
        operator_delay = get_operator_delay(self.operator_name)
        data_access_delay = 5 if self.rm_type == 'blk' else 3
        rm_rd_phy_addr_jump = self.input_shape[2] - self.stride * (self.output_shape[2] - 1)

        code_str = self.controller_name + ' #(\n' + \
                   '.DB_W_IN (' + str(self.input_shape[2]) + '),\n' + \
                   '.DB_H_IN (' + str(self.input_shape[1]) + '),\n' + \
                   '.DB_C_IN (' + str(self.input_shape[0]) + '),\n' + \
                   '.DB_W_OUT (' + str(self.output_shape[2]) + '),\n' + \
                   '.DB_H_OUT (' + str(self.output_shape[1]) + '),\n' + \
                   '.DB_C_OUT (' + str(self.output_shape[0]) + '),\n' + \
                   '.WB_W (' + str(self.kernel_size) + '),\n' + \
                   '.WB_H (' + str(self.kernel_size) + '),\n' + \
                   '.WB_K (' + str(self.input_shape[0]) + '),\n' + \
                   '.RM_WR_ADDR_WIDTH (' + str(self.rm_wr_addr_width) + '),\n' + \
                   '.RM_WR_NUM_PER_CHANNEL (' + str(self.input_channel_group) + '),\n' + \
                   '.RM_WR_STRIDE (' + str(self.rm_wr_stride) + '),\n' + \
                   '.RM_RING_LENGTH (' + str(self.rm_ring_length) + '),\n' + \
                   '.RM_RD_PHY_ADDR_JUMP (' + str(rm_rd_phy_addr_jump) + '),\n' + \
                   '.RM_RD_ADDR_WIDTH (' + str(self.rm_rd_addr_width) + '),\n' + \
                   '.KPF (' + str(self.kpf) + '),\n' + \
                   '.STRIDE_H (' + str(self.stride) + '),\n' + \
                   '.STRIDE_W (' + str(self.stride) + '),\n' + \
                   '.PAD (' + str(self.pad) + '),\n' + \
                   '.DATA_ACCESS_DELAY (' + str(data_access_delay) + '),\n' + \
                   '.OP_DELAY (' + str(operator_delay) + '))\n' + \
                   'u_controller(\n' + \
                   '.clk(clk),\n' + \
                   '.rst(rst),\n' + \
                   '.rm_wr_en(rm_wr_en), \n' + \
                   '.rm_wr_addr(rm_wr_addr),\n' + \
                   '.rm_rd_addr(rm_rd_addr),\n' + \
                   '.op_din_eop(op_din_eop),\n' + \
                   '.op_din_en(op_din_en),\n' + \
                   '.blob_din_rdy(blob_din_rdy),\n' + \
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
        for batch_idx in range(batch_size):
            for i in range(self.kpf):
                code_str += self.operator_name + ' #(' + \
                        '.RELU('+ str(self.hasrelu)+'),\n' + \
                        '.DIN_W('+ str(self.input_dw) + '),\n' + \
                        '.Q(' + str(WQ) + '))\n' + \
                        'u_' + self.operator_name + '_' + str(batch_idx) + '_' + str(i) + '(\n' + \
                        '.clk(clk),\n' + \
                        '.rst(rst),\n' + \
                        '.op_din_en(op_din_en),\n' + \
                        '.op_din_eop(op_din_eop),\n' + \
                        '.op_din(op_data_'+str(batch_idx)+'['+str(self.input_dw*(i+1)-1)+':'+str(self.input_dw * i) + ']),\n' + \
                        '.op_dout(op_dout_' + str(batch_idx) + '_' + str(i) + '));\n\n'

        code_str += 'assign blob_dout = {' if self.insert_fifo is False else 'assign blob_dout_fifo = {'
        for batch_idx in range(batch_size):
            for i in range(self.kpf):
                code_str += 'op_dout_' + str(batch_size - 1 - batch_idx) + '_' + str(self.kpf - 1 - i) + ','
        code_str = code_str[:-1] #remove the last ','
        code_str += '};\n\n'

        return code_str
    
    def profile(self, batch_size=1):
        # Computation resource
        self.ops = self.output_shape[0] * self.output_shape[1] * self.output_shape[2] * self.kernel_size * self.kernel_size
        self.macs = 0
        self.dsps = 0
        self.multiplier = self.dsps
        self.clocks = self.ops / self.kpf

        # Reshape memory
        self.rm_size = self.rm_wr_width * self.rm_wr_depth * batch_size
        self.rm_blks = get_brams(self.rm_wr_width, self.rm_wr_depth, self.rm_rd_width, \
                       self.rm_rd_depth, True) * batch_size if self.rm_type == 'blk' else 0
        self.wm_size = 0
        self.wm_blks = 0
        self.bm_size = 0
        self.bm_blks = 0
        # No weights memory
        self.weights_num = 0

        # No bandwidth requirement
        self.ddr_bandwidth = 0.0


if __name__  == '__main__':
    pass
