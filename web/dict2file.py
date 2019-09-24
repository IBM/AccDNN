#!/usr/bin/env python


def optim_info_to_file(paral_info, file_path):
    optim_str = ''
    for layer in paral_info:
        optim_str += '[' + layer.get('name') + ']\n'
        if layer.get('cpf') is not None:
            optim_str += 'CPF=' + str(layer.get('cpf')) + '\n'
        optim_str += 'KPF=' + str(layer.get('kpf')) + '\n'

    fd = open(file_path, 'w')
    fd.write(optim_str)
    fd.close()


def resource_info_to_file(resource_info, file_path):
    resource_str = ''
    resource_str += '[RESOURCE]\n'
    resource_str += 'DSP_NUM=' + str(resource_info.get('dsp_num')) + '\n'
    resource_str += 'RAM18E_NUM=' + str(resource_info.get('ram18e_num')) + '\n'
    resource_str += 'DDR_BANDWIDTH=' + str(resource_info.get('ddr_bandwidth')) + '\n'

    fd = open(file_path, 'w')
    fd.write(resource_str)
    fd.close()
