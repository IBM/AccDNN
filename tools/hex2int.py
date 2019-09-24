#!/usr/bin/env python

import sys
import argparse
import numpy as np

def compare(hex_file, int_file):
    # Parse the hex file
    data_list = []
    fp = open(hex_file, 'r')
    line_list = []
    for line in fp:
        line_list.append(line.strip())
    for s in line_list:    
        data_line = []     
        for i in xrange(0, len(s), 4):
            data_line.append(int(s[i:i+4], 16))
        data_line.reverse()
        data_list.extend(data_line)
    int_array = np.array(data_list, dtype='float32')
    int_array[np.where(int_array >= 32768)] = int_array[np.where(int_array >= 32768)] - 65536
 
    data_str = ''
    for data in int_array:
        data_str += '%d\n'%(data)

    fd = open(int_file, 'w')
    fd.write(data_str)
    fd.close()      
   
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "hex_file",
        help="simulated results file."
    )
    parser.add_argument(
        "int_file",
        help="real results file."
    )
    # Optional arguments.
    args = parser.parse_args()

    compare(args.hex_file, args.int_file)

