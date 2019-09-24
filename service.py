import os
import sys
import glob
from settings import *
import model
import caffe
from caffe.proto import caffe_pb2
from google.protobuf.text_format import Merge
from google.protobuf.text_format import MessageToString
import json
import subprocess
from shutil import copyfile
from web.dict2file import optim_info_to_file, resource_info_to_file

supported_layers = ['Convolution', 'ConvolutionRistretto', 'InnerProduct', 'FcRistretto', 'FcRistretto', 'BatchNorm', \
                    'Pooling', 'Scale', 'Softmax', 'ReLU', 'Dropout', 'Input']

default_optim_file = '/tmp/optim_file.conf'
default_resource_file = '/tmp/resource_file.conf'
default_output_path = '/tmp/build.zip'

def check_prototxt(model_file):
    if not model_file.endswith('.prototxt'):
        return json.dumps({'status':'Error', 'detail':'File type error, please upload .prototxt file.'})
    net = caffe_pb2.NetParameter()
    try:
        Merge((open(model_file,'r').read()), net)
    except Exception as e:
        return json.dumps({'status':'Error', 'detail':'Network file parse error:' + str(e)})
    for layer in net.layer:
        if layer.type not in supported_layers:
            return json.dumps({'status':'Error', 'detail':'{} layer is not supported.'.format(layer.type)})
        if layer.type == 'Pooling':
            if layer.pooling_param.pool != 0:
                return json.dumps({'status':'Error', 'detail':'Only MAX pooling layer is supported.'})
    return json.dumps({'status':'Success', 'detail':''})

def check_weights(model_file, weight_file):
    if not weight_file.endswith('.caffemodel'):
        return json.dumps({'status':'Error', 'detail':'File type error, please upload .caffemodel file.'})
    root_dir = os.environ.get('CAFFE_ROOT')
    cmd = os.path.join(root_dir, 'build/tools/caffe') + ' test -model ' + model_file + ' -weights ' + weight_file + ' -iterations 1'
    ret = subprocess.call(cmd, shell=True)
    if ret != 0:
        return json.dumps({'status':'Error', 'detail':\
               'Can\'t not creat caffe model with provided weights file, error code is {}'.format(ret)})
    return json.dumps({'status':'Success', 'detail':''})

def accdnn_profile(model_file, acc_settings_json):
    acc_settings = json.loads(acc_settings_json)
    caffe.set_mode_cpu()
    try:
        model_inst = model.Model(model_file, None, BATCH_SIZE)
        model_inst.parser(None)
        resource_info_to_file(acc_settings.get('resource'), default_resource_file)
        model_inst.parallelism_auto_optimization(default_resource_file, acc_settings.get('ddr_data_width'))
        model_inst.module_params_compute(acc_settings.get('ddr_data_width'))
        model_inst.module_summary()
        model_inst.memory_summary(default_resource_file)
        model_profile, optim_info = model_inst.profile(default_resource_file)
    except Exception as e:
        return json.dumps({'status':'Error', 'detail':str(e), 'stats':'', 'parameter':''})
    return json.dumps({'status':'Success', 'detail':'', 'stats':model_profile, 'parameter':optim_info})

def accdnn_optimze(model_file, acc_settings_json, optim_info_json):
    acc_settings = json.loads(acc_settings_json)
    optim_info = json.loads(optim_info_json)
    batch_size = optim_info.get('batch_size')
    caffe.set_mode_cpu()
    try: 
        model_inst = model.Model(model_file, None, batch_size)
        optim_info_to_file(optim_info.get('paral_info'), default_optim_file)
        model_inst.parser(default_optim_file)
        resource_info_to_file(acc_settings.get('resource'), default_resource_file)
        model_inst.module_params_compute(acc_settings.get('ddr_data_width'))
        model_inst.module_summary()
        model_inst.memory_summary(default_resource_file)
        model_profile, optim_info = model_inst.profile(default_resource_file)
    except Exception as e:
        return json.dumps({'status':'Error', 'detail':str(e), 'stats':'', 'parameter':''})
    return json.dumps({'status':'Success', 'detail':'', 'stats':model_profile, 'parameter':optim_info})

def accdnn_codegen(model_file, weight_file, acc_settings_json, optim_info_json):
    if os.path.exists(OUTPUT_PATH):
        os.system('rm -rf ' + OUTPUT_PATH)
    os.system('mkdir -p ' + OUTPUT_PATH)
    os.system('mkdir -p ' + VERILOG_FILE_PATH)
    os.system('mkdir -p ' + MEM_COE_FILE_PATH)
    os.system('mkdir -p ' + TIMING_FILE_PATH)

    acc_settings = json.loads(acc_settings_json)
    optim_info = json.loads(optim_info_json)
    batch_size = optim_info.get('batch_size')
    caffe.set_mode_cpu()
    try:
        model_inst = model.Model(model_file, weight_file, batch_size)
        optim_info_to_file(optim_info.get('paral_info'), default_optim_file)
        model_inst.parser(default_optim_file)
        resource_info_to_file(acc_settings.get('resource'), default_resource_file)
        model_inst.module_params_compute(acc_settings.get('ddr_data_width'))
        model_inst.module_summary()
        model_inst.memory_coe_file_gen(acc_settings.get('ddr_data_width'))
        model_inst.ipcores_gen(acc_settings.get('fpga_type'))
        model_inst.code_gen(acc_settings.get('ddr_data_width'))
        model_inst.memory_summary(default_resource_file)
        model_profile, optim_info = model_inst.profile(default_resource_file)
    except Exception as e:
        return json.dumps({'status':'Error', 'detail':str(e), 'stats':'', 'codepath':''})   
    model_inst.file_list_gen()
    model_inst.timing_constraints_gen()
    model_inst.register_map_gen()

    root_dir = os.environ.get('ACCDNN_ROOT')
    for lib_file in model_inst.lib_source_file_set:
        copyfile(os.path.join(root_dir, os.path.join(LIB_SOURCE_FILE_PATH, lib_file)), \
                 os.path.join(VERILOG_FILE_PATH, lib_file))

    os.system("rm build/file_list.txt && rm build/imp_file.f")
    # add the mul ip tcl to the ips.tcl
    mul_ip_file = os.path.join(root_dir, os.path.join(LIB_IP_FILE_PATH, 'mul.tcl'))
    os.system('cat ' + mul_ip_file + ' >> build/ips.tcl')
    os.system("zip -r -q build.zip build/ && rm -rf build && mv build.zip /tmp/")
    return json.dumps({'status':'Encrypting', 'detail':'', 'stats':model_profile, 'codepath':default_output_path})

if __name__ == '__main__':
    model_file = 'example/cifar10/cifar10_quick.prototxt'
    weight_file = 'example/cifar10/cifar10_quick_iter_5000.caffemodel'
    # weight_file = '../models/alexnet-quantized/alexnet_A16C8F4_iter_2000.caffemodel'
    ret = check_prototxt(model_file)
    print ret
    ret = check_weights(model_file, weight_file)
    print ret
    acc_settings_json = json.dumps({'resource':{'dsp_num':270, 'ram18e_num':327, 'ddr_bandwidth':80000}, \
                                    'fpga_type':'xcku115-flva1517-2-e', \
                                    'ddr_data_width':256})
    ret = accdnn_profile(model_file, acc_settings_json)
    print ret
    ret = accdnn_optimze(model_file, acc_settings_json, json.dumps(json.loads(ret).get('parameter')))
    print ret
    ret = accdnn_codegen(model_file, weight_file, acc_settings_json, json.dumps(json.loads(ret).get('parameter')))
    print ret

   

