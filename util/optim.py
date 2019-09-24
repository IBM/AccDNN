#!/usr/bin/env python

import math
from settings import *

total_avaliable_pfs = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]

def get_conv_pfs(target_pf, channel_num, kernel_num):
    # set to the closest avaliable pfs
    actual_pf = min(MAX_CPF * MAX_KPF, 2 ** int(round(math.log(float(target_pf)) / math.log(2.0))))
    # get avaliable cpf and kpf
    avaliable_cpfs = get_avaliable_pfs(channel_num, min(actual_pf, MAX_CPF))
    avaliable_kpfs = get_avaliable_pfs(kernel_num, min(actual_pf, MAX_KPF))
    # max the cpf first
    cpf = get_actual_pf(actual_pf, avaliable_cpfs)
    target_kpf = actual_pf / cpf
    kpf = get_actual_pf(target_kpf, avaliable_kpfs)
    return optim_cpf_kpf(cpf, kpf, avaliable_kpfs[-1])

def get_pooling_pf(target_pf, kernel_num):
    target_pf = min(target_pf, MAX_KPF/2)
    avaliable_kpfs = get_avaliable_pfs(kernel_num, MAX_KPF/2)
    return get_actual_pf(target_pf, avaliable_kpfs)
    
def get_actual_pf(target_pf, avaliable_pfs):
    reversed_avaliable_pfs = list(avaliable_pfs)
    reversed_avaliable_pfs.reverse()
    for pf_candidate in reversed_avaliable_pfs:
        if pf_candidate <= target_pf:
            return pf_candidate

def get_avaliable_pfs(num, max_pf):
    avaliable_pfs = []
    for pf_candidate in total_avaliable_pfs:
        if (pf_candidate <= min(max_pf, num)) and (num % pf_candidate == 0):
            avaliable_pfs.append(pf_candidate)
    return avaliable_pfs

def optim_cpf_kpf(cpf, kpf, max_kpf):
    if cpf/kpf <= 2 or kpf == max_kpf:
        return cpf, kpf
    else:
       return optim_cpf_kpf(cpf/2, kpf*2, max_kpf)

if __name__ == '__main__':

    print optim_cpf_kpf(16, 2, 16)

