#!/usr/bin/env python

from settings import *
import numpy as np
import struct

def _bool2int(x, dw):
    y = 0
    for i,j in enumerate(x):
       y += j<<(i * dw)
    return y

def _quantize(mat, dw, dq, is_complement=True):
    FIX_POINT_MAX = 2 ** (dw - 1) - 1
    FIX_POINT_MIN  = - 2 ** (dw - 1)
    FIX_POINT_SCALE = 2 ** dq
    UINT_MAX = 2 ** dw
    # scale 2^dq
    #mat = mat * FIX_POINT_SCALE
    mat = np.round(mat * FIX_POINT_SCALE)
    #saturate processing
    mat[np.where(mat > FIX_POINT_MAX)] = FIX_POINT_MAX
    mat[np.where(mat < FIX_POINT_MIN)] = FIX_POINT_MIN
    #float to int type
    mat = mat.astype(np.int32)
    if is_complement is not True:
        return mat
    #covert to complement format 
    mat = (mat + UINT_MAX) % UINT_MAX
    return mat

def save2coe(file_path_name, mat, dw, dq):
    if mat.ndim != 2:
        raise Exception("Memory matrix dimension is not 2.")
    mat = _quantize(mat, dw, dq)

    coe_str = 'memory_initialization_radix = 2; \nmemory_initialization_vector = \n'
    for row in mat:
        row_str = ''
        for col in row:
            row_str = ('{0:0'+ str(dw) + 'b}').format(col) + row_str
        row_str += ',\n'
        coe_str += row_str
    coe_str = coe_str[:-2] + ';\n'
    #write to coe file    
    fd = open(file_path_name, 'w')
    fd.write(coe_str)
    fd.close()

def mat2uint16(mat, dw, dq):
     mat = _quantize(mat, dw, dq)
     mat = mat.reshape(-1, 16/dw)
     mat = [_bool2int(x, dw) for x in mat]
     return np.array(mat)

def uint16_dump_hex_aligned(file_path_name, mat):
    if mat.ndim != 2:
        raise Exception("Memory matric dimension is not 2.")
    coe_str = ''
    for row in mat:
        row_str = ''
        for col in row:
            row_str = '%04X'%(col) + row_str
        row_str += '\n'
        coe_str += row_str
    #write to coe file
    fd = open(file_path_name, 'w')
    fd.write(coe_str)
    fd.close()

def mat_dump_float(file_path_name, mat, dw, dq):
    if mat.ndim != 1:
        print "Input mat dimension is not 1, will reshape to 1."
        mat = mat.reshape(-1)
    #scale the data to .DQ
    mat = mat * (2 ** dq)

    data_str = ''
    for data in mat:
        data_str += '%f\n'%(data)

    fd = open(file_path_name, 'w')
    fd.write(data_str)
    fd.close()

def mat_dump_int(file_path_name, mat, dw, dq):
    if mat.ndim != 1:
        print "Input mat dimension is not 1, will reshape to 1."
        mat = mat.reshape(-1)
    mat = _quantize(mat, dw, dq, False)
    
    data_str = ''
    for data in mat:
        data_str += '%d\n'%(data)

    fd = open(file_path_name, 'w')
    fd.write(data_str)
    fd.close()
