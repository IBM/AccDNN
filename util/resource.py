#!/usr/bin/env python

import math
from settings import *
import chip_define
import ConfigParser

width_list = [1, 2, 4, 9, 18, 36]
depth_list = [16392, 8192, 4096, 2048, 1024, 512]

def get_brams(wr_width, wr_depth, rd_width, rd_depth, total=False):
    width = max(wr_width, rd_width)
    depth = min(wr_depth, rd_depth)
 
    row36 = 0
    col36 = 0
    #assign 36K first
    if width >= 72:
        row36 = width / 72
        col36 = int(math.ceil(float(depth)/512.0))
        width = width - row36 * 72
    blk36_num = row36 * col36

    row18 = 0
    col18 = 0
    #assign 18K first
    if width >= 36:
        row18 = 1
        col18 = int(math.ceil(float(depth)/512.0))
        width = width - row18 * 36
    blk18_num = row18 * col18
    
    for idx in range(len(width_list)):
        if width > width_list[idx]:
            continue
        else: 
           col = int(math.ceil(float(depth)/float(depth_list[idx])))
           break
    blk18_num = blk18_num + 1 * col
    
    if total is False:
        return blk18_num, blk36_num
    else:
        return blk18_num + 2 * blk36_num

def get_dsps_resource(res_file=None):
    if res_file is None:
        return chip_define.DSP_NUM
    cf = ConfigParser.ConfigParser()
    cf.read(res_file)
    try:
        return int(cf.get('RESOURCE', 'DSP_NUM'))
    except:
        return chip_define.DSP_NUM
 
def get_brams_resource(res_file=None):
    if res_file is None:
        return chip_define.RAM18E_NUM
    cf = ConfigParser.ConfigParser()
    cf.read(res_file)
    try:
        return int(cf.get('RESOURCE', 'RAM18E_NUM'))
    except:
        return chip_define.RAM18E_NUM

def get_ddr_bandwidth(res_file=None):
    if res_file is None:
        return chip_define.DDR_BANDWIDTH
    cf = ConfigParser.ConfigParser()
    cf.read(res_file)
    try:
        return int(cf.get('RESOURCE', 'DDR_BANDWIDTH'))
    except:
        return chip_define.DDR_BANDWIDTH

if __name__ == '__main__':
    
    print '16, 8064, 64, 2016 :', get_brams(16, 8064, 64, 2016)
    print '512, 49, 512, 49 :', get_brams(512, 49, 512, 49)
    print '256, 3312, 256, 3312 :', get_brams(256, 3312, 256, 3312)
    print '256, 2310, 128,  4620:', get_brams(256, 2310, 128, 4620)
    print '512, 600, 1024, 300 :', get_brams(512, 600, 1024, 300)
