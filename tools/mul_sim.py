import os
import numpy as np

CPF = 4
KERNEL_NUM = 2  # can only be 1 or 2
VEC_LENGTH = 32
VEC_NUMBER = 4

DIN_W = 8
DIN_Q = 6 
WW = 8
WQ = 7
DOUT_W = 8
DOUT_Q = 4

HEX_OUT_DIR = './hexout'

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

def mat2hex(file_path_name, mat, dw, dq):
    mat_quanized = _quantize(mat, dw, dq)
    coe_str = ''
    for row in mat_quanized:
        row_str = ''
        for col in row:
            if dw == 16:
                row_str = '%04X'%(col) + row_str
            elif dw == 8:
                row_str = '%02X'%(col) + row_str
            else:
                raise Exception("unsupported")
        row_str += '\n'
        coe_str += row_str
    #write to coe file
    fd = open(file_path_name, 'w')
    fd.write(coe_str)
    fd.close()

din = np.round(np.random.randn(VEC_NUMBER,VEC_LENGTH) * (2 ** (DIN_W - DIN_Q - 2)) * (2 ** DIN_Q)) / (2 ** DIN_Q)
weight = np.round(np.random.randn(VEC_LENGTH, KERNEL_NUM) * (2 ** (WW - WQ - 2)) * (2 ** WQ)) / (2 ** WQ)
dout = np.round(np.dot(din, weight) * (2 ** DOUT_Q)) / (2 ** DOUT_Q)

if os.path.exists(HEX_OUT_DIR):
    os.system('rm -rf ' + HEX_OUT_DIR)
os.system('mkdir -p ' + HEX_OUT_DIR)

mat2hex(os.path.join(HEX_OUT_DIR, 'din.txt'), din.reshape(-1, CPF), DIN_W, DIN_Q)
if DIN_W == 8 and WW == 8 and KERNEL_NUM == 2:
    mat2hex(os.path.join(HEX_OUT_DIR,'weight.txt'), weight.reshape(-1, CPF*2), WW, WQ)
else:
    mat2hex(os.path.join(HEX_OUT_DIR,'weight.txt'), weight.reshape(-1, CPF), WW, WQ)
mat2hex(os.path.join(HEX_OUT_DIR,'dout.txt'), dout.reshape(-1, KERNEL_NUM), DOUT_W, DOUT_Q)




