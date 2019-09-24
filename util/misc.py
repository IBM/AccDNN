#!/usr/bin/env python

import os
from settings import *
import ConfigParser

def get_operator_name(operator_type, channel_parall_factor):
    if operator_type == 'vector_muladd':
        operator_name = operator_type + str(channel_parall_factor)
    else:
        operator_name = operator_type
    return operator_name

def get_controller_name(layer_type, operator_type):
    if layer_type == 'Convolution' or layer_type == 'InnerProduct':
        return 'controller'
    elif layer_type == 'Pooling':
        if operator_type == 'vector_max':
            return 'controller_a'
        elif operator_type == 'vector_ave':
            return 'controller_b'
        else:
            return 'controller_a'
    else:
        return 'controller_a'

def get_file_dependence(operator_name, dependence_type):
    cf = ConfigParser.ConfigParser()
    operator_file = os.path.join(os.environ.get('ACCDNN_ROOT'), OPERATOR_CONF_FILE_PATH) if WEBSERVICE \
                    else OPERATOR_CONF_FILE_PATH
    cf.read(operator_file)
    dependence = cf.get(operator_name, dependence_type)
    if dependence == "":
        file_list = []
    else:
        #add the dependence file
        file_list = dependence.split(',')
    return file_list

def get_operator_delay(operator_name, cpf=1, bn=None):
    real_operator_name = operator_name + str(cpf) if operator_name == 'vector_muladd' else operator_name
    cf = ConfigParser.ConfigParser()
    operator_file = os.path.join(os.environ.get('ACCDNN_ROOT'), OPERATOR_CONF_FILE_PATH) if WEBSERVICE \
                    else OPERATOR_CONF_FILE_PATH
    cf.read(operator_file)
    if bn:
        return int(cf.get(real_operator_name, 'delay')) + 1
    else:
        return int(cf.get(real_operator_name, 'delay'))

def is_fpga_hardware(hardware_type):
    cf = ConfigParser.ConfigParser()
    hardware_file = os.path.join(os.environ.get('ACCDNN_ROOT'), HARDWARE_CONF_FILE_PATH) if WEBSERVICE \
                    else HARDWARE_CONF_FILE_PATH
    cf.read(hardware_file)
    return cf.has_section(hardware_type)

def get_hardware_info(hardware_type):
    cf = ConfigParser.ConfigParser()
    hardware_file = os.path.join(os.environ.get('ACCDNN_ROOT'), HARDWARE_CONF_FILE_PATH) if WEBSERVICE \
                    else HARDWARE_CONF_FILE_PATH
    cf.read(hardware_file)
    return int(cf.get(hardware_type, 'DSP_NUM')), int(cf.get(hardware_type, 'RAM18E_NUM')), \
           float(cf.get(hardware_type, 'DDR_BANDWIDTH')),int(cf.get(hardware_type, 'DDR_DATA_WIDTH')), \
           cf.get(hardware_type, 'FPGA_TYPE')

def get_layer_cpf(layer_name, optim_file=None):
    if optim_file is None:
        return 1
    cf = ConfigParser.ConfigParser()
    cf.read(optim_file)
    try:
        cpf = int(cf.get(layer_name, 'CPF'))
    except:
        print 'Layer %s:CPF is not provide in optimation configure file, will use default value 1 instead.'%layer_name
        cpf = 1
    return cpf

def get_layer_kpf(layer_name, optim_file=None):
    if optim_file is None:
        return 1
    cf = ConfigParser.ConfigParser()
    cf.read(optim_file)
    try:
        kpf = int(cf.get(layer_name, 'KPF'))
    except:
        print 'Layer %s:KPF is not provide in optimation configure file, will use default value 1 instead.'%layer_name
        kpf = 1
    return kpf

def get_layer_dma_delay(layer_name, optim_file=None):
    if optim_file is None:
        return DEFAULT_DDR_DMA_DELAY
    cf = ConfigParser.ConfigParser()
    cf.read(optim_file)
    try:
        dma_delay = int(cf.get(layer_name, 'DMA_DELAY'))
        if dma_delay > MAX_DDR_DMA_DELAY:
            raise Exception ('Layer %s:DMA_DELAY is too large, can not excced %d.'%(layer_name, MAX_DDR_DMA_DELAY))
    except:
        print 'Layer %s:DMA_DELAY is not provide in optimation configure file, will use default value 0 instead.'%layer_name
        dma_delay = 0
    return dma_delay

