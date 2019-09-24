import numpy as np
import caffe
from layers.convolution import Convolution
from layers.innerproduct import InnerProduct
from layers.pooling import Pooling
from util.proto import readProtoFile
from util.code_aide import code_module_header_gen, code_signals_gen, code_instance_ddr_gen, code_instance_gen, code_dma_delay_gen
from util.data import uint16_dump_hex_aligned
from util.misc import get_layer_cpf, get_layer_kpf, get_layer_dma_delay, get_file_dependence
from util.optim import get_conv_pfs, get_pooling_pf
from util.tcl import ipcore_tcl_gen
from util.math2 import lcm
from util.resource import get_dsps_resource, get_brams_resource, get_ddr_bandwidth
from web.pack import pack_layer_profile, pack_model_profile, pack_optim_info
from settings import *
import ConfigParser
from caffe.proto import caffe_pb2
from google.protobuf import text_format
import math
import struct

class Model(caffe.Net):
    def __init__(self, model_file, pretrained_file, batch_size=1):
        if pretrained_file is not None:
            caffe.Net.__init__(self, model_file, pretrained_file, caffe.TEST)
        else:
            caffe.Net.__init__(self, model_file, caffe.TEST)     
        
        self.batch_size = batch_size
        # parse the model file to get the basic informtions, such as padding, stride, kernel_size
        # which can not be obtained from the caffe.net
        net_config = caffe.proto.caffe_pb2.NetParameter()
        parse_object = readProtoFile(model_file, net_config)
        self.layer_info_list = parse_object.layer
    
    def get_layer_info(self, layer_name):
        for object_ in self.layer_info_list:
            if object_.name == layer_name:
                return object_
        return None

    def get_inst_by_layer_name(self, layer_name):
        for module_inst in self.modules:
            if module_inst.layer_name == layer_name:
                return module_inst
        return None
        
    def parser(self, optim_file=None):
        self.modules = []
        # there is no explicit input layer, the first functional layer will dirctly 
        # connect to the input data steam (DMA input, 16*3bits), each data is 16bits, 
        # thus the data width is 3
        up_layer_data_shape = self.blobs.get('data').data.shape[1:]
        up_layer_data_width = 1
        up_layer_output_stride = 1
        
        layer_list = list(self._layer_names)
        for layer_name in layer_list:
            layer_cur = self.layers[layer_list.index(layer_name)]
            layer_type = layer_cur.type
            if layer_type == 'Softmax' or layer_type == 'Dropout' or layer_type == 'Input':
                print '{} layer will be skipped.'.format(layer_type)
                continue
            # get the layer information
            layer_info = self.get_layer_info(layer_name)
            if layer_info == None:
                raise Exception ('Layer [%s] not found, please check the model net file.'%layer_name)
            # check the layer_name, 
            if layer_name != layer_info.name:
                raise Exception ('Layer parse error, please check the model net file.')

            if layer_type == 'Convolution' or layer_type == 'ConvolutionRistretto':
                stride = 1 if len(layer_info.convolution_param.stride)==0 else layer_info.convolution_param.stride[0]
                pad = 0  if len(layer_info.convolution_param.pad)==0 else layer_info.convolution_param.pad[0]
                params = [self.params[layer_name][0].data, self.params[layer_name][1].data] \
                        if layer_info.convolution_param.bias_term else [self.params[layer_name][0].data]
                module_inst = Convolution(layer_name, up_layer_data_shape, up_layer_data_width, up_layer_output_stride, \
                              self.blobs[layer_info.top[0]].data.shape[1:], params, stride, pad, \
                              get_layer_cpf(layer_name, optim_file), get_layer_kpf(layer_name, optim_file), \
                              layer_info.convolution_param.group)
                if layer_type == 'ConvolutionRistretto':
                    module_inst.set_quantization(layer_info.quantization_param.bw_layer_in, 
                                                 layer_info.quantization_param.fl_layer_in, 
                                                 layer_info.quantization_param.bw_params,
                                                 layer_info.quantization_param.fl_params,
                                                 layer_info.quantization_param.bw_layer_out,
                                                 layer_info.quantization_param.fl_layer_out)
            elif layer_type == 'InnerProduct' or layer_type == 'FcRistretto':
                params = [self.params[layer_name][0].data, self.params[layer_name][1].data] \
                        if layer_info.inner_product_param.bias_term else [self.params[layer_name][0].data]
                module_inst = InnerProduct(layer_name, up_layer_data_shape, up_layer_data_width, up_layer_output_stride, \
                              self.blobs[layer_info.top[0]].data.shape[1:], params, \
                              get_layer_cpf(layer_name, optim_file), get_layer_kpf(layer_name, optim_file))
                if layer_type == 'FcRistretto':
                    module_inst.set_quantization(layer_info.quantization_param.bw_layer_in,
                                                 layer_info.quantization_param.fl_layer_in,
                                                 layer_info.quantization_param.bw_params,
                                                 layer_info.quantization_param.fl_params,
                                                 layer_info.quantization_param.bw_layer_out,
                                                 layer_info.quantization_param.fl_layer_out)
            elif layer_type == 'Pooling':
                module_inst =  Pooling(layer_name, up_layer_data_shape, up_layer_data_width, up_layer_output_stride, \
                               self.blobs[layer_info.top[0]].data.shape[1:], \
                               layer_info.pooling_param.pool, \
                               layer_info.pooling_param.kernel_size, \
                               layer_info.pooling_param.stride, \
                               layer_info.pooling_param.pad,  \
                               get_layer_kpf(layer_name, optim_file))
                module_inst.set_quantization(self.modules[-1].output_dw, self.modules[-1].output_dq, 
                                             self.modules[-1].param_ww, self.modules[-1].param_wq,
                                             self.modules[-1].output_dw, self.modules[-1].output_dq)
            elif layer_type == 'BatchNorm':
                params = [self.params[layer_name][0].data / self.params[layer_name][2].data, \
                          self.params[layer_name][1].data / self.params[layer_name][2].data]
                self.modules[-1].bn = params
                print 'Layer %s(%s), is aggregated to the upper layer %s.'\
                      %(layer_name, layer_type, self.modules[-1].layer_name)
                continue
            elif layer_type == 'Scale':
                params = [self.params[layer_name][0].data, self.params[layer_name][1].data]
                self.modules[-1].bn.extend(params)
                print 'Layer %s(%s), is aggregated to the upper layer %s.'\
                      %(layer_name, layer_type, self.modules[-1].layer_name)
                continue
            elif layer_type == 'ReLU':
                # appregate this simple layer to the up layer
                self.modules[-1].hasrelu = 1
                print 'Layer %s(%s), is aggregated to the upper layer %s.'\
                      %(layer_name, layer_type, self.modules[-1].layer_name)
                continue
            else:
                raise Exception('Layer type [%s] is not supported.'%layer_type)

            if module_inst.params: 
                 module_inst.dma_delay = get_layer_dma_delay(module_inst.layer_name, optim_file)
           
            # add this module to the end of the list
            self.modules.append(module_inst)
            
            up_layer_data_shape = module_inst.output_shape
            up_layer_data_width = module_inst.kpf
            up_layer_output_stride = module_inst.get_output_stride()

        if INPUT_CHANNEL_PADDING > 0:
            old_shape = self.modules[0].input_shape
            self.modules[0].input_shape = (old_shape[0] + INPUT_CHANNEL_PADDING, old_shape[1], old_shape[2])
            if self.modules[0].params:
                old_params_shape = self.modules[0].params[0].shape
                new_params = np.zeros((old_params_shape[0], old_params_shape[1] + INPUT_CHANNEL_PADDING, \
                             old_params_shape[2], old_params_shape[3]))
                new_params[:,0:old_params_shape[1],:,:] = self.modules[0].params[0]
                self.modules[0].params[0] = new_params
                self.modules[0].kernel_num = self.modules[0].params[0].shape[0]
                self.modules[0].kernel_shape = self.modules[0].params[0].shape[1:]
                
    def parallelism_auto_optimization(self, res_file=None, ddr_data_width=DDR_DATA_WIDTH):
        ops_list = []
        data_reuse_list = []
        for moule_inst in self.modules:
            if moule_inst.layer_type == 'Convolution' or moule_inst.layer_type == 'InnerProduct' or \
               moule_inst.layer_type == 'ConvolutionRistretto' or moule_inst.layer_type == 'FcRistretto':
                ops = moule_inst.output_shape[0] * moule_inst.output_shape[1] * moule_inst.output_shape[2] * \
                      moule_inst.kernel_shape[0] * moule_inst.kernel_shape[1] * moule_inst.kernel_shape[2]
                ops_list.append(float(ops))
                # the weight data reuse equal the height of the output shape
                data_reuse_list.append(float(moule_inst.param_ww)/float(moule_inst.output_shape[1]))
        ops_list = np.array(ops_list)
        data_reuse_list = np.array(data_reuse_list)
        # normalized pfs for each layer
        pf_list = ops_list / ops_list.min()
        # bandwidth required with current normalized pfs setting, Mb/s
        normalized_bandwidth = np.dot(pf_list, data_reuse_list) * CLOCK_FREQUENCY
        # pf scale according to the real bandwidth
        pf_list = pf_list * float(get_ddr_bandwidth(res_file)) / normalized_bandwidth
        pf_list = np.ceil(pf_list).astype(np.int32)
        pf_list[np.where(pf_list == 0)] = 1

        module_index = 0
        total_pfs = 0
        while True:
            pf_index = 0
            module_index = 0
            total_pfs = 0
            for module_inst in self.modules:
                if module_inst.layer_type == 'Convolution' or module_inst.layer_type == 'InnerProduct' or \
                   moule_inst.layer_type == 'ConvolutionRistretto' or moule_inst.layer_type == 'FcRistretto':
                    pf = pf_list[pf_index]
                    module_inst.cpf, module_inst.kpf = get_conv_pfs(pf, module_inst.input_shape[0], module_inst.kernel_num)
                    pf_index += 1
                    total_pfs += module_inst.cpf * module_inst.kpf
                elif module_inst.layer_type == 'Pooling':
                    module_inst.kpf = get_pooling_pf(module_inst.input_shape[0], module_inst.input_shape[0])
                
                # for the last module, no following layers
                if module_index < (len(self.modules) - 1):
                    self.modules[module_index + 1].input_width = module_inst.kpf
                    self.modules[module_index + 1].rm_wr_stride = module_inst.get_output_stride()
                module_index += 1
    
            blks_for_wbm = 0
            blks_for_rm = 0
            for module_inst in self.modules:
                module_inst.module_params_compute(ddr_data_width)
                module_inst.profile()
                blks_for_wbm += module_inst.wm_blks + module_inst.bm_blks
                blks_for_rm += module_inst.rm_blks
            #print int(get_dsps_resource() / total_pfs), int((get_brams_resource() - blks_for_wbm) / blks_for_rm)
            controller_dsp = sum([6 if module_inst.params else 2 for module_inst in self.modules])
            self.batch_size = min(int((get_dsps_resource(res_file) * RESOURCE_THRES - controller_dsp) / total_pfs),
                                  int((get_brams_resource(res_file) * RESOURCE_THRES - blks_for_wbm) / blks_for_rm))
            if self.batch_size > 0:
                break;
            elif self.batch_size == 0 and pf_list.sum() == len(pf_list):
                raise Exception ('Don\'t have enough memory to fit the whole network.')
            else:
               pf_list = pf_list / 2
               pf_list[np.where(pf_list == 0)] = 1
              
    def module_params_compute(self, ddr_data_width=DDR_DATA_WIDTH):
        self.used_dma_channel_num = 0
        for module_inst in self.modules:
            module_inst.module_params_compute(ddr_data_width)
            if module_inst.params:
                self.used_dma_channel_num += 1
        #if self.used_dma_channel_num > DDR_DMA_ENGINE_NUM:
        #    raise Exception ('This design require %d DMA channels, while the max DMA channel number is %d.'\
        #                     %(self.used_dma_channel_num, DDR_DMA_ENGINE_NUM))
        #chech the layer input and output width
        for idx in range(1, len(self.modules)):
            if self.modules[idx-1].bn:
                # if bn is aggregated, will use the this layer's origin output_dq is as the Q 
                # of the middle data, and use the next layer's dw/dq as this layer's output quantization 
                # parameters, if the next layer is Pooling layer, will use the next next layer.
                # the bitwidth for BN is always MAX_DW bit, if input for bn is not MAX_DW, scale it to MAX_DW bits
                self.modules[idx-1].mid_dq = min(self.modules[idx-1].output_dq + (MAX_DW - self.modules[idx-1].output_dw), \
                                                 self.modules[idx-1].input_dq + self.modules[idx-1].param_wq)
                if self.modules[idx].layer_type != 'Pooling':
                    self.modules[idx-1].output_dw = self.modules[idx].input_dw
                    self.modules[idx-1].output_dq =  self.modules[idx].input_dq
                else:
                    self.modules[idx-1].output_dw = self.modules[idx+1].input_dw
                    self.modules[idx-1].output_dq =  self.modules[idx+1].input_dq
                    # Update the quantization information for the pooling layer.
                    self.modules[idx].input_dw =  self.modules[idx-1].output_dw
                    self.modules[idx].input_dq =  self.modules[idx-1].output_dq
                    self.modules[idx].output_dw =  self.modules[idx].input_dw
                    self.modules[idx].output_dq =  self.modules[idx].input_dq
      
            if self.modules[idx].input_dw != self.modules[idx-1].output_dw or \
              self.modules[idx].input_dq != self.modules[idx-1].output_dq:
                # if no bn is aggregated, the adjacent layers should have consistent 
                # quantization parameters
                raise Exception ('{} layer\'s output width or Q doesn\'t match {} layer\'s input width or Q.'\
                                 .format(self.modules[idx-1].layer_name, self.modules[idx].layer_name))
 
    def module_summary(self):
        print '\nNeural network structure overview.'
        format_str = "%-10s%-16s%-16s%-16s%-15s%-8s%-8s%-8s%-8s%-6s%-6s%-7s%-8s%-7s"
        print (format_str%('NAME', 'TYPE', 'INPUT_SHAPE', 'OUTPUT_SHAPE', 'KERNEL_SHAPE', 'KN',
               'STRIDE', 'PAD', 'GROUP', 'CPF', 'KPF', 'DIN', 'WEIGHT', 'DOUT'))
        print '-------------------------------------------------------------------------------------------' + \
              '---------------------------------------------'
        
        for module_inst in self.modules:
            if hasattr(module_inst, 'kernel_shape'):
                kernel_shape = module_inst.kernel_shape
            elif hasattr(module_inst, 'kernel_size'):
                kernel_shape = module_inst.kernel_size
            else:
                kernel_shape = 0
            if hasattr(module_inst, 'cpf'):
                cpf = module_inst.cpf
            else:
                cpf = 0
            if hasattr(module_inst, 'kernel_num'):
                kernel_num = module_inst.kernel_num
            else:
                module_inst.kernel_num = 0
            print (format_str%(module_inst.layer_name, module_inst.layer_type, str(module_inst.input_shape), 
                   str(module_inst.output_shape), str(kernel_shape), str(kernel_num), 
                   str(module_inst.stride), str(module_inst.pad),
                   str(module_inst.group) if hasattr(module_inst, 'group') else '', str(cpf),
                   str(module_inst.kpf), str(module_inst.input_dw)+'/'+str(module_inst.input_dq),
                   str(module_inst.param_ww)+'/'+str(module_inst.param_wq), 
                   str(module_inst.output_dw)+'/'+str(module_inst.output_dq)))
        print '\n'

    def memory_summary(self, res_file=None):
        print '\nFPGA on-chip memory usage (Single batch).'
        format_str = "%-13s%-15s%-15s%-13s%-13s%-13s%-13s%-13s%-13s"
        print (format_str%('NAME', 'TYPE', 'SIZE(bits)', 'BRAM18E',
               'WR_WIDTH', 'WR_DEPTH', 'RD_WIDTH', 'RD_DEPTH', 'UTILIZATION'))
        print '-----------------------------------------------------------------------------------' + \
              '-------------------------------------'
        self.rm_blk_size = 0
        self.rm_dist_size = 0
        self.rm_blks = 0
        self.wm_size = 0
        self.wm_blks = 0
        for module_inst in self.modules:
            module_inst.profile()
            if module_inst.rm_type == 'blk':
                self.rm_blk_size += module_inst.rm_size
                self.rm_blks += module_inst.rm_blks
            else:
                self.rm_dist_size += module_inst.rm_size
            if module_inst.params:
                self.wm_size += module_inst.wm_size + module_inst.bm_size
                self.wm_blks += module_inst.wm_blks + module_inst.bm_blks
            print (format_str%(module_inst.layer_name, 'reshape' if module_inst.rm_type == 'blk' else 'reshape*', 
                   str(module_inst.rm_size), str(module_inst.rm_blks), str(module_inst.rm_wr_width), str(module_inst.rm_wr_depth),
                   str(module_inst.rm_rd_width), str(module_inst.rm_rd_depth), 
                   '%.3f'%(float(module_inst.rm_size)/float(module_inst.rm_blks*18000.0) if module_inst.rm_type=='blk' else 0)))
            if module_inst.params:
                print (format_str%(' ', 'weights{}'.format('(+)' if module_inst.wm_hier_enable is False else ''), 
                       str(module_inst.wm_size), str(module_inst.wm_blks),
                       str(module_inst.wm_wr_width), str(module_inst.wm_wr_depth), str(module_inst.wm_rd_width), 
                       str(module_inst.wm_rd_depth),  '%.3f'%(float(module_inst.wm_size)/float(module_inst.wm_blks*18000.0))))
                print (format_str%(' ', 'bias', str(module_inst.bm_size), str(module_inst.bm_blks), ' ', ' ', str(module_inst.bm_rd_width), 
                       str(module_inst.bm_rd_depth), '%.3f'%(float(module_inst.bm_size)/float(module_inst.bm_blks*18000.0))))

        total_blks = self.rm_blks * self.batch_size + self.wm_blks
        print '\nWeight memory is %.3fMb(%d BRAM18Es).'%(self.wm_size/1000000.0, self.wm_blks)
        print 'Reshape memory of each channel, BRAM memory is %.3fMb(%d BRAM18Es), distributed memory is %.3fMb.'\
              %(self.rm_blk_size/1000000.0, self.rm_blks, self.rm_dist_size/1000000.0)
        print 'Total memory used is %.3fMb, where BRAM is %.3fMb(%d BRAM18Es, %.1f%%), distributed memory is %.3fMb.'\
              %((self.rm_blk_size * self.batch_size + self.rm_dist_size * self.batch_size+ self.wm_size)/1000000.0,
               (self.rm_blk_size * self.batch_size + self.wm_size) / 1000000.0, total_blks, 
               float(total_blks)/float(get_brams_resource(res_file))*100.0, self.rm_dist_size * self.batch_size)
        print 'The averaged utilization of BRAM is %.3f.'%(float(self.rm_blk_size * self.batch_size + self.wm_size) \
              /float(total_blks)/18000.0)

        if total_blks > get_brams_resource(res_file):
            raise Exception ('The BRAM18E used is %d, exceeds the total available %d BRAM16Es.'\
                             %(total_blks, get_brams_resource(res_file)))
        if total_blks > get_brams_resource(res_file) * RESOURCE_WARNING_THRES:
            print 'WARNING: The BRAM18E used is %d, excees %.1f%% of the total available %d BRAM16Es'\
                  %(total_blks, RESOURCE_WARNING_THRES*100, get_brams_resource(res_file))
        self.total_blks = total_blks

    def profile(self, res_file=None):
        for module_inst in self.modules:
            module_inst.profile(self.batch_size)

        max_clocks = max([module_inst.clocks for module_inst in self.modules])
        max_delay = max_clocks / CLOCK_FREQUENCY
        total_macs = sum([module_inst.macs for module_inst in self.modules])
        controller_dsp = sum([6 if module_inst.params else 2 for module_inst in self.modules])
        total_compute_dsps = sum([module_inst.dsps for module_inst in self.modules])
        total_multiplier = sum([module_inst.multiplier for module_inst in self.modules])
        total_dsps = controller_dsp + total_compute_dsps
        total_clocks = sum([module_inst.clocks for module_inst in self.modules])
        total_weights_num = sum([module_inst.weights_num for module_inst in self.modules])
         
        if total_dsps > get_dsps_resource(res_file):
            raise Exception ('The DSPs used is %d, exceeds the total available %d DSPs.'\
                             %(total_dsps, get_dsps_resource(res_file)))
        if total_dsps > get_dsps_resource(res_file) * RESOURCE_WARNING_THRES:
            print '\nWARNING: The DSPs used is %d, exceeds %.1f%% of the total available %d DSPs'\
                  %(total_dsps, RESOURCE_WARNING_THRES*100, get_dsps_resource(res_file))
     
        print '\nFPGA implementation summary (projected in %dMHz clock, batch_size=%d).'%(CLOCK_FREQUENCY, self.batch_size)
        format_str = "%-12s%-15s%-8s%-8s%-16s%-16s%-12s%-13s%-15s%-20s"
        print (format_str%('NAME', 'TYPE', 'CPF',
               'KPF', 'MACS', 'DSPs', 'WEIGHTS', 'CLOCKS', 'DELAY(us)', 'DDR_BW(Mb/s)'))
        print '-----------------------------------------------------------------------------------------' + \
              '--------------------------------------'

        total_ddr_bandwidth = 0
        layer_profile = []
        optim_info = []
        for module_inst in self.modules:
            print (format_str%(module_inst.layer_name, module_inst.layer_type, 
                   str(module_inst.cpf) if hasattr(module_inst, 'cpf') else '', str(module_inst.kpf), 
                   str(module_inst.macs), str(module_inst.dsps), str(module_inst.weights_num), str(module_inst.clocks),
                   '%.3f'%(module_inst.clocks/CLOCK_FREQUENCY),
                   '%.2f'%(module_inst.ddr_bandwidth * CLOCK_FREQUENCY * module_inst.clocks/max_clocks)))
            if WEBSERVICE is True:
                layer_profile.append(pack_layer_profile(module_inst.layer_name, module_inst.layer_type, 
                                     module_inst.cpf if hasattr(module_inst, 'cpf') else None, module_inst.kpf, 
                                     str(module_inst.macs), module_inst.dsps, module_inst.weights_num, 
                                     module_inst.clocks/CLOCK_FREQUENCY,
                                     module_inst.ddr_bandwidth * CLOCK_FREQUENCY * module_inst.clocks/max_clocks,
                                     module_inst.rm_blks + module_inst.wm_blks + module_inst.bm_blks))
                optim_info.append(pack_optim_info(module_inst.layer_name, 
                                    module_inst.cpf if hasattr(module_inst, 'cpf') else None, module_inst.kpf))
            total_ddr_bandwidth += module_inst.ddr_bandwidth * CLOCK_FREQUENCY * module_inst.clocks / max_clocks
  
        print '----------------------'
        print (format_str%('total', ' ', ' ', ' ', str(total_macs), 
               str(total_dsps) + '(%.1f%%)'%(float(total_dsps)/get_dsps_resource(res_file)*100.0), 
               str(total_weights_num), str(total_clocks), 
               '%.3f'%(total_clocks/CLOCK_FREQUENCY), '%.2f'%(total_ddr_bandwidth)))
        print '\nTotal %d DMA channels used, %d left.'%(self.used_dma_channel_num, \
               DDR_DMA_ENGINE_NUM-self.used_dma_channel_num)
        print 'The projected throughput is %.1fimages/s, utilization is about %.4f.'\
              %(1e6/max_delay * self.batch_size, float(total_macs)/(total_multiplier*CLOCK_FREQUENCY*max_delay))

        if WEBSERVICE is True:
            model_profile = pack_model_profile(layer_profile, self.batch_size, total_macs, total_dsps, \
                           total_weights_num, self.total_blks, total_ddr_bandwidth, 1e6/max_delay * self.batch_size, 
                           float(total_macs)/(total_multiplier*CLOCK_FREQUENCY*max_delay))
            return model_profile, {'paral_info':optim_info, 'batch_size':self.batch_size}

    def ipcores_gen(self, fpga_type):
        tcl_str = ''
        # To generate the ips cores, we should creat a project first
        tcl_str += 'set project_name ' + IP_PROJECT_NAME + '\n'
        tcl_str += 'set project_path ' + IP_PROJECT_PATH + '\n'
        tcl_str += 'set src_path ' + IP_PROJECT_PATH + '/' + IP_PROJECT_NAME + '.srcs\n'
        tcl_str += 'set sim_path ' + IP_PROJECT_PATH + '/' + IP_PROJECT_NAME + '.ip_user_files/sim_scripts\n'
        if fpga_type:
            tcl_str += 'create_project $project_name $project_path -part ' + fpga_type + '\n'
        else:
            tcl_str += 'create_project $project_name $project_path -part ' + XILINX_FPGA_TYPE + '\n'

        # Generate ips for each layer
        self.ips = []
        for module_inst in self.modules:
            self.ips.extend(module_inst.ips_generate())
        # Generate the ips core tcl file
        tcl_str += ipcore_tcl_gen(self.ips)

        file_path_name = TCL_FILE_PATH + '/' + 'ips.tcl'
        fd = open(file_path_name, 'w')
        fd.write(tcl_str)
        fd.close()

    def file_list_gen(self):
        self.lib_source_file_set = set([])
        self.lib_ip_file_set = set([])
        self.source_file_set = set([])
        self.ip_file_set = set([])
     
        #generate file set for lib or souce/ip files 
        for module_inst in self.modules:
            lib_source_file_list, lib_ip_file_list, source_file_list, ip_file_list = module_inst.get_file_list()
            self.lib_source_file_set.update(lib_source_file_list)
            self.lib_ip_file_set.update(lib_ip_file_list)
            self.source_file_set.update(source_file_list)
            self.ip_file_set.update(ip_file_list)
        
        #self.lib_source_file_set.update(utility.get_file_dependence('controller', 'source_dependence'))
        #self.lib_ip_file_set.update(utility.get_file_dependence('controller', 'ip_dependence'))
        #self.lib_source_file_set.update(['controller.v'])

        #add the top layer, always named model.v
        self.source_file_set.update(['model.v'])

        #input/output bus adapter
        self.lib_source_file_set.update(['busm2n.v'])
        #ddr read delay for better timing
        self.lib_source_file_set.update(['ddr_read_delay.v'])
       
        #collect all the files for Vivado project
        file_path_list = []
        sim_file_list = []
        imp_file_list = []
        file_list_str = ''
        #collect lib souce file
        for file_inst in self.lib_source_file_set:
            file_path = LIB_SOURCE_FILE_PATH + '/' + file_inst
            file_path_list.append(file_path)
            sim_file_list.append(file_path)
            imp_file_list.append(file_path)
            file_list_str += 'verilog work' + " \"acc/" + file_inst + "\"\n"
        #collect lib ip file
        for file_inst in self.lib_ip_file_set:
            file_path = LIB_IP_FILE_PATH + '/' + file_inst + '/' + file_inst + '.xci'
            sim_file = LIB_IP_FILE_PATH + '/' + file_inst + '/' + file_inst + '_funcsim.v'
            file_path_list.append(file_path)
            sim_file_list.append(sim_file)
            file_list_str += 'verilog work' + " \"cores/" + file_inst + '/' + file_inst + '.xci' + "\"\n"
        #collect source file
        for file_inst in self.source_file_set:
            file_path = VERILOG_FILE_PATH + '/' + file_inst
            file_path_list.append(file_path)
            sim_file_list.append(file_path)
            imp_file_list.append(file_path)
            file_list_str += 'verilog work' + " \"acc/" + file_inst + "\"\n"
        #collect ip file
        for file_inst in self.ip_file_set:
            file_path = IP_FILE_PATH + '/' + file_inst + '/' + file_inst + '.xci'
            sim_file = IP_FILE_PATH + '/' + file_inst + '/sim/' + file_inst + '.v'
            file_path_list.append(file_path)
            sim_file_list.append(sim_file)
            file_list_str += 'verilog work' + " \"cores/" + file_inst + '/' + file_inst + '.xci' + "\"\n"

        # Print 'The following file will be add to the vivado project.'
        # file_list_str = '' 
        # for file_path_name in file_path_list:
        #    file_list_str += 'verilog work' + " \"" + file_path_name + "\"\n"
        
        sim_file_str = ''
        for file_path_name in sim_file_list:
            sim_file_str += file_path_name + "\n"

        imp_file_str = ''
        for file_path_name in imp_file_list:
            imp_file_str += file_path_name + "\n"

        #output to a file list text  file
        file_path_name = FILE_LIST_PATH + '/' + 'file_list.txt'
        fd = open(file_path_name, 'w')
        fd.write(file_list_str)
        fd.close()

        if SIMULATION_ONLY is True:
            file_path_name = SIM_FILE_LIST_PATH + '/' + 'sim_file.f'
            fd = open(file_path_name, 'w')
            fd.write(sim_file_str)
            fd.close()
   
        file_path_name = FILE_LIST_PATH + '/' + 'imp_file.f'
        fd = open(file_path_name, 'w')
        fd.write(imp_file_str)
        fd.close()


    
    def memory_coe_file_gen(self, ddr_data_width=DDR_DATA_WIDTH):
        mif_file_list = []
        weights_array = np.array([])
        ddr_start_addr = 0
        ddr_dma_index = 0
        for module_inst in self.modules:
            weights, mif_file = module_inst.memory_coe_gen(ddr_data_width)
            mif_file_list.extend(mif_file)
            if len(weights) != 0:
                # write weights to bit stream, will used to load to DDR
                weights_array = np.append(weights_array, weights)
                module_inst.ddr_start_addr = ddr_start_addr
                ddr_start_addr += len(weights) / (ddr_data_width / 16)
                module_inst.ddr_dma_id = ddr_dma_index
                ddr_dma_index += 1

        self.used_dma_channel_num = ddr_dma_index 

        file_path_name = MEM_COE_FILE_PATH + '/' + 'weights.bin'
        fd = open(file_path_name, 'wb')
        fd.write(struct.pack('H'*len(weights_array), *weights_array))
        fd.close()

        weights_array = weights_array.reshape(-1, ddr_data_width / 16)
        file_path_name = MEM_COE_FILE_PATH + '/' + 'weights_sim.dat'
        uint16_dump_hex_aligned(file_path_name, weights_array)

        mif_file_str = ''
        for mif_file in mif_file_list:
            mif_file_str += mif_file + '\n'
       
        if SIMULATION_ONLY is True:
            file_path_name = SIM_FILE_LIST_PATH + '/' + 'mif_file.f'
            fd = open(file_path_name, 'w')
            fd.write(mif_file_str)
            fd.close()

    def ios_generate(self, ddr_data_width = DDR_DATA_WIDTH):
        self.ios = {}
        # data blob ios
        self.ios['blob_din'] = tuple([CAPI_DATA_BUS_WIDTH, 'input'])
        self.ios['blob_din_rdy'] = tuple([1, 'output'])
        self.ios['blob_din_en'] = tuple([1, 'input'])
        self.ios['blob_din_eop'] = tuple([1, 'input'])

        self.ios['blob_dout'] =  tuple([CAPI_DATA_BUS_WIDTH, 'output'])
        self.ios['blob_dout_en'] = tuple([1, 'output'])
        self.ios['blob_dout_rdy'] = tuple([1, 'input'])
        self.ios['blob_dout_eop'] = tuple([1, 'output'])

        for i in range(DDR_DMA_ENGINE_NUM):
            self.ios['ddr_read_req_' + str(i)] = tuple([1, 'output'])
            self.ios['ddr_read_start_addr_' + str(i)] = tuple([27, 'output'])
            self.ios['ddr_read_length_' + str(i)] = tuple([27, 'output'])
            self.ios['ddr_read_ack_' + str(i)] = tuple([1, 'input'])
            
        self.ios['ddr_dout'] = tuple([ddr_data_width, 'input'])
        self.ios['ddr_dout_en'] = tuple([16, 'input'])
        self.ios['ddr_dout_eop'] = tuple([1, 'input'])
        
    def code_gen(self, ddr_data_width=DDR_DATA_WIDTH):
        #generate the code for each layer
        for module_inst in self.modules:
            module_inst.code_gen(self.batch_size, ddr_data_width)
        #generate the code for the top module
        self.code_top_module_gen(ddr_data_width)

    def code_top_module_gen(self, ddr_data_width=DDR_DATA_WIDTH):
        code_str = ''
        # Generate the code of the module header
        self.ios_generate(ddr_data_width)
        code_str += code_module_header_gen('model', self.ios)

        # generate the dma delay instance, -1 for disable this channel.
        dma_delays = -1 * np.ones(DDR_DMA_ENGINE_NUM, dtype=np.int32)
        for module_inst in self.modules:
            if module_inst.ddr_dma_id >= 0:
                dma_delays[module_inst.ddr_dma_id] = module_inst.dma_delay

        code_str += code_dma_delay_gen(dma_delays, ddr_data_width)

        # input data width adjust
        blob_dout_name = 'input_blob_din'
        blob_dout_rdy_name = 'input_blob_din_rdy'
        blob_dout_en_name = 'input_blob_din_en'
        blob_dout_eop_name = 'input_blob_din_eop'

        inter_signals = {}
        inter_signals[blob_dout_name] = tuple([self.modules[0].input_width * self.modules[0].input_dw * self.batch_size, 'wire'])
        inter_signals[blob_dout_rdy_name] = tuple([1, 'wire'])
        inter_signals[blob_dout_en_name] = tuple([1, 'wire'])
        inter_signals[blob_dout_eop_name] = tuple([1, 'wire'])
        code_str += code_signals_gen(inter_signals)

        bus_width_lcm = lcm(self.modules[0].input_width * self.modules[0].input_dw * self.batch_size, CAPI_DATA_BUS_WIDTH)
        param_list = [tuple(['IN_WIDTH', str(CAPI_DATA_BUS_WIDTH)]), \
            tuple(['OUT_WIDTH', str(self.modules[0].input_width * self.modules[0].input_dw * self.batch_size)]), \
            tuple(['COM_MUL', str(bus_width_lcm)]), \
            tuple(['N', str(self.modules[0].input_shape[0] * self.modules[0].input_shape[1] \
                * self.modules[0].input_shape[2] / self.modules[0].input_width)])]           
        code_str += code_instance_gen('busm2n', 'blob_din', 'blob_din_en', 'blob_din_rdy', 'blob_din_eop', \
                        blob_dout_name, blob_dout_en_name, blob_dout_rdy_name, blob_dout_eop_name, param_list, 0)

        blob_din_name = blob_dout_name
        blob_din_rdy_name = blob_dout_rdy_name
        blob_din_en_name = blob_dout_en_name
        blob_din_eop_name = blob_dout_eop_name
        
        for module_inst in self.modules:
            # Define the output signal name and width
            blob_dout_name = module_inst.layer_name + '_blob_dout'
            blob_dout_width = module_inst.output_width * module_inst.output_dw * self.batch_size
            blob_dout_rdy_name = module_inst.layer_name + '_blob_dout_rdy'
            blob_dout_en_name = module_inst.layer_name + '_blob_dout_en'
            blob_dout_eop_name = module_inst.layer_name + '_blob_dout_eop'
            # Generate the outpt signals
            inter_signals = {}
            inter_signals[blob_dout_name] = tuple([blob_dout_width, 'wire'])
            inter_signals[blob_dout_rdy_name] = tuple([1, 'wire'])
            inter_signals[blob_dout_en_name] = tuple([1, 'wire'])
            inter_signals[blob_dout_eop_name] = tuple([1, 'wire'])
            code_str += code_signals_gen(inter_signals)

            if module_inst.ddr_dma_id >= 0:
                # DDR DMA channle has been assigned.
                code_str += code_instance_ddr_gen(module_inst.layer_name + '_layer', \
                            blob_din_name, blob_din_en_name, blob_din_rdy_name, blob_din_eop_name, \
                            blob_dout_name, blob_dout_en_name, blob_dout_rdy_name, blob_dout_eop_name, \
                            'layer_ddr_read_req_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_read_ack_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_read_addr_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_read_length_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_dout_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_dout_en_'+str(module_inst.ddr_dma_id), \
                            'layer_ddr_dout_eop_'+str(module_inst.ddr_dma_id))
                
            else:
                code_str += code_instance_gen(module_inst.layer_name + '_layer',
                        blob_din_name, blob_din_en_name, blob_din_rdy_name, blob_din_eop_name,
                        blob_dout_name, blob_dout_en_name, blob_dout_rdy_name, blob_dout_eop_name)
            # The output of this layer will be the input of next layer
            blob_din_name = blob_dout_name
            blob_din_rdy_name = blob_dout_rdy_name
            blob_din_en_name = blob_dout_en_name
            blob_din_eop_name = blob_dout_eop_name

        bus_width_lcm = lcm(self.modules[-1].output_width*self.modules[-1].output_dw * self.batch_size ,CAPI_DATA_BUS_WIDTH)
        total_bits = np.prod(self.modules[-1].output_shape) * self.modules[-1].output_dw * self.batch_size
        if (total_bits %CAPI_DATA_BUS_WIDTH) == 0:
            output_num = total_bits / CAPI_DATA_BUS_WIDTH
        else:
            output_num = total_bits / CAPI_DATA_BUS_WIDTH + 1
        param_list = [tuple(['IN_WIDTH', str(self.modules[-1].output_width*self.modules[-1].output_dw * self.batch_size)]), \
            tuple(['OUT_WIDTH', str(CAPI_DATA_BUS_WIDTH)]), \
            tuple(['COM_MUL', str(bus_width_lcm)]), \
            tuple(['N', str(output_num)])]
        code_str += code_instance_gen('busm2n', blob_din_name, blob_din_en_name, blob_din_rdy_name, blob_din_eop_name, \
                                      'blob_dout', 'blob_dout_en', 'blob_dout_rdy', 'blob_dout_eop', param_list, 1)
       
        # process the unused channels
        unused_channels = range(DDR_DMA_ENGINE_NUM)[self.used_dma_channel_num:]
        for channel_index in unused_channels:
            code_str += 'assign layer_ddr_read_req_' + str(channel_index) + ' = 1\'b0;\n' + \
                        'assign layer_ddr_read_length_' + str(channel_index) + ' = 27\'b0;\n' + \
                        'assign layer_ddr_read_addr_' + str(channel_index) + ' = 27\'b0;\n'

        code_str += 'endmodule\n'
        file_path_name = VERILOG_FILE_PATH + '/' + 'model.v'
        fd = open(file_path_name, 'w')
        fd.write(code_str)
        fd.close()

    def timing_constraints_gen(self):
        code_str = ''
        for module_inst in self.modules:
            if module_inst.ddr_dma_id >= 0:
                code_str += 'set_multicycle_path -from [get_nets {a0/afu0/acc_module/u_module' + \
                            '/u0_ddr_read_delay/engine_ddr_read_addr_%d_o[*]}] -setup %d\n'\
                            %(module_inst.ddr_dma_id, 2+module_inst.dma_delay)
                code_str += 'set_multicycle_path -from [get_nets {a0/afu0/acc_module/u_module' + \
                            '/u0_ddr_read_delay/engine_ddr_read_addr_%d_o[*]}] -hold 1\n'%(module_inst.ddr_dma_id) 
       
        file_path_name = TIMING_FILE_PATH + '/' + 'dma_timing.xdc'
        fd = open(file_path_name, 'w')
        fd.write(code_str)
        fd.close()

    def register_map_gen(self):
        code_str = ''
        code_str += '`define USER_CONFIG0    64\'h' + '%04X'%(self.batch_size) + '%04x'%(self.modules[0].input_shape[2]) + \
                    '%04X'%(self.modules[0].input_shape[1]) + '%04X'%(self.modules[0].input_shape[0]) + '\n'
        code_str += '`define USER_CONFIG1    64\'h' + '%04X'%(self.batch_size) + '%04x'%(self.modules[-1].output_shape[2]) + \
                    '%04X'%(self.modules[-1].output_shape[1]) + '%04X'%(self.modules[-1].output_shape[0]) + '\n'
        input_scale = self.modules[0].input_dq if self.modules[0].input_dq >= 0 else self.modules[0].input_dq + 256
        output_scale = self.modules[-1].output_dq if  self.modules[-1].output_dq > 0 else  self.modules[-1].output_dq  + 256 
        code_str += '`define USER_CONFIG2    64\'h' + '00000000' + '%02X'%(output_scale) + '%02X'%(input_scale) + \
                    '%02X'%(self.modules[-1].output_dw) + '%02X'%(self.modules[0].input_dw) + '\n'
        code_str += '`define USER_CONFIG3    64\'h' + '000000000000' + '%04X'%(INPUT_CHANNEL_PADDING) + '\n'
        code_str += '`define USER_CONFIG4    64\'h' + '000000000000' + '%02X'%(self.modules[-1].kpf) + '%02X'%(1) + '\n'
        code_str += '`define USER_CONFIG5    64\'h' + '0000000000000000' + '\n'
        code_str += '`define USER_CONFIG6    64\'h' + '0000000000000000' + '\n'
        code_str += '`define USER_CONFIG7    64\'h' + '0000000000000000'

        file_path_name = OUTPUT_PATH + '/' + 'parameters.v'
        fd = open(file_path_name, 'w')
        fd.write(code_str)
        fd.close()
        

if __name__ == '__main__':
    pass
