#!/usr/bin/env python

import numpy as np
import sys
import matplotlib.pyplot as plt
import argparse
import copy
#DQ = 6
#SCALE = 2 ** DQ
bits_per_element = 16
hex_num_per_element = bits_per_element / 4
NUM_MAX = 2 ** (bits_per_element)
NUM_MAX_HALF = 2 ** (bits_per_element - 1)

def compare(sim_file, real_file, bits_per_element, height, stride=1, iteration=1):
    print bits_per_element
    hex_num_per_element = bits_per_element / 4
    NUM_MAX = 2 ** (bits_per_element)
    NUM_MAX_HALF = 2 ** (bits_per_element - 1)    
    # Parse the real data file
    data_list = []
    fp = open(real_file, 'r')
    for line in fp:
        data_list.append(float(line.strip()))
    real_array = np.array(data_list)
    len_array = len(real_array)

    # Parse the simulation file
    data_list = []
    fp = open(sim_file, 'r')
    line_list = []
    for line in fp:
        line_list.append(line.strip())
    elements_per_line = len(line_list[0]) / hex_num_per_element
    if len_array % elements_per_line == 0:
        lines_per_iteration = len_array / elements_per_line
    else:
        lines_per_iteration = len_array / elements_per_line + 1
    print 'lines_per_iteration:', lines_per_iteration
    if len(line_list) < (iteration-1)*lines_per_iteration:
        raise Exception('Not enough data generated...')
    if len(line_list) < iteration*lines_per_iteration:
       line_list = line_list[(iteration-1)*lines_per_iteration:]
    else:
       line_list = line_list[(iteration-1)*lines_per_iteration : iteration*lines_per_iteration]
    line_list_arranged = copy.deepcopy(line_list)
    if stride > 1 :
        for i, line in enumerate(line_list):
            w_index = i / (stride * height)
            offset = i - w_index * (stride * height)
            stride_index = offset / height
            height_index = offset % height
            new_index = w_index * (stride * height) + height_index * stride + stride_index
            #print w_index, height_index, stride_index, new_index
            #print line
            line_list_arranged[new_index] = line
    for s in line_list_arranged:    
        data_line = []     
        for i in xrange(0, len(s), hex_num_per_element):
            #print s[i:i+hex_num_per_element]
            data_line.append(int(s[i:i+hex_num_per_element], 16))
        data_line.reverse()
        data_list.extend(data_line)
    sim_array = np.array(data_list, dtype='float32')
    sim_array[np.where(sim_array >= NUM_MAX_HALF)] = sim_array[np.where(sim_array >= NUM_MAX_HALF)] - NUM_MAX
    
    print sim_array
    print real_array

    if len(sim_array) == len(real_array):
        diff = sim_array - real_array
        error = np.sqrt((diff**2).sum() / ((real_array**2).sum()))
        print 'Quantization error is %f'%(error)

    plt.figure(1)
    #plot1 = plt.plot(np.arange(len(sim_array)), diff, 'r')
    plot1, = plt.plot(np.arange(len(sim_array)), sim_array, 'r')
    plot2, = plt.plot(np.arange(len(real_array)), real_array, 'b')
    plt.legend([plot1, plot2], ('sim_data', 'real_data'))
    plt.show()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "sim_file",
        help="simulated results file."
    )
    parser.add_argument(
        "real_file",
        help="real results file."
    )
    parser.add_argument(
        "--bw",
        type=int,
        default=16,
        help="bitwidth of the output"
    )
    parser.add_argument(
        "--height",
        type=int,
        default=32,
        help="height of the output"
    )
    parser.add_argument(
        "--stride",
        type=int,
        default=1,
        help="stride, default is 1."
    )
    parser.add_argument(
        "--iter",
        type=int,
        default=1,
        help="iteration, default is 1."
    )    
    # Optional arguments.
    args = parser.parse_args()

    compare(args.sim_file, args.real_file, args.bw, args.height, args.stride, args.iter)

