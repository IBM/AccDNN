#!/usr/bin/env python

from settings import *

def pack_layer_profile(layer_name, layer_type, cpf, kpf, macs, dsps, weights_num, delay, bandwidth, blks):
    return {'name':layer_name, 'type':layer_type, 'cpf':cpf, 'kpf':kpf, 'macs':macs, \
            'dsps':dsps, 'weights':weights_num, 'delay':delay, 'bandwidth':bandwidth, 'blks':blks}

def pack_model_profile(layer_info, batch_size, total_macs, total_dsps, \
                       total_weights_num, total_blks, total_ddr_bandwidth, throughput, utilization):
    return {'layer_info':layer_info, 'batch_size':batch_size, 'total_macs':total_macs, \
            'total_dsps': total_dsps, 'total_weights_num':total_weights_num, 'total_blks':total_blks,
            'total_ddr_bandwidth':total_ddr_bandwidth, 'throughput':throughput, 'utilization':utilization}

def pack_optim_info(layer_name, cpf, kpf):
    return {'name':layer_name, 'cpf':cpf, 'kpf':kpf}
