from settings import *
from util.code_aide import code_signals_gen, code_module_header_gen, interlayer_fifo_gen
from util.misc import get_file_dependence

class Layer(object):
    def __init__(self, layer_name, layer_type, input_shape, input_width, input_stride, output_shape):
        self.layer_name = layer_name
        self.layer_type = layer_type
        self.input_shape = input_shape
        self.output_shape = output_shape
        self.input_width = input_width
        self.output_width = 1
        self.rm_type = 'blk'
        self.params = None
        self.ips = []
        self.ios = {}   
        self.rm_wr_stride = input_stride
        self.hasrelu = 0
        self.insert_fifo = False

        # Default quantization scheme
        self.input_dw = DW
        self.input_dq = DQ
        self.param_ww = DW
        self.param_wq = WQ
        self.output_dw = DW
        self.output_dq = DQ

        # Default quantization for batch normalization
        self.bn = None
        self.bn_dw = MAX_DW
        self.bn_scale_dq = DQ
        self.bn_bias_dq = DQ
        self.mid_dq = DQ

        # Default to disable memory hierarchy for weight memory
        self.wm_hier_enable = False

        # Default no ddr dma channel needed
        self.ddr_dma_id = -1

    def set_quantization(self, input_dw, input_dq, param_ww, param_wq, output_dw, output_dq):
        self.input_dw = input_dw
        self.input_dq = input_dq
        self.param_ww = param_ww
        self.param_wq = param_wq
        self.output_dw = output_dw
        self.output_dq = output_dq
        
    def module_params_compute(self):
        pass
    
    def memory_coe_gen(self, ddr_data_width=DDR_DATA_WIDTH):
        return [], []

    def ips_generate(self):
        return []

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

    def wires_generate(self, batch_size=1):
        pass

    def code_ram_gen(self, batch_size=1):
        pass

    def code_interconnector_gen(self):
        code_str = code_signals_gen(self.wires)
        code_str += '\n'
        return code_str

    def code_controller_gen(self):
        pass

    def code_gen(self, batch_size=1, ddr_data_width=DDR_DATA_WIDTH):
        self.ios_generate(batch_size, ddr_data_width)
        self.wires_generate(batch_size)

        # signal for fifo before layer out if necessary
        if self.insert_fifo is True:
            self.wires['blob_dout_fifo'] = tuple([self.ios['blob_dout'][0], 'wire'])
            self.wires['blob_dout_en_fifo'] = tuple([1, 'wire'])
            self.wires['blob_dout_eop_fifo'] = tuple([1, 'wire'])

        file_path_name = VERILOG_FILE_PATH + '/' + self.layer_name + '_layer.v'
        fd = open(file_path_name, 'w')
        code_str = ''
        code_str += code_module_header_gen(self.layer_name + '_layer', self.ios)
        code_str += self.code_interconnector_gen()
        code_str += self.code_controller_gen()
        code_str += self.code_ram_gen(batch_size)
        code_str += self.code_operator_gen(batch_size)

        if self.insert_fifo is True:
            fifo_width = self.ios['blob_dout'][0]
            code_str += interlayer_fifo_gen(fifo_width, self.fifo_depth)
       
        code_str += 'endmodule\n'

        #print code_str
        fd.write(code_str)
        fd.close() 

    def code_operator_gen(self, batch_size=1):
        pass

    def get_file_list(self):
        lib_source_file_list = []
        lib_ip_file_list = []
        #add source file for controller
        lib_source_file_list.extend(get_file_dependence(self.controller_name, 'source_dependence'))
        lib_ip_file_list.extend(get_file_dependence(self.controller_name, 'ip_dependence'))
        #add source file for operator
        lib_source_file_list.extend(get_file_dependence(self.operator_name, 'source_dependence'))
        lib_ip_file_list.extend(get_file_dependence(self.operator_name, 'ip_dependence'))

        #add the lib source file
        if self.operator_name == 'vector_muladd':
            lib_source_file_list.append(self.operator_name + '.sv')
        else:
            lib_source_file_list.append(self.operator_name + '.v')
        lib_source_file_list.append(self.controller_name + '.v')

        if self.insert_fifo is True:
            lib_source_file_list.append('interlayer_sync_fifo.v')

        #verilog source file list
        source_file_list = []
        source_file_list.append(self.layer_name + '_layer.v')

        #ip file list
        ip_file_list = []
        for ip_inst in self.ips:
            ip_file_list.append(ip_inst.get('module_name'))

        return lib_source_file_list, lib_ip_file_list, source_file_list, ip_file_list


    def profile(self):
        pass       

if __name__  == '__main__':
    pass
