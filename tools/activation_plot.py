#!/usr/bin/env python

import numpy as np
import sys
import matplotlib.pyplot as plt
import argparse
import copy
#DQ = 6
#SCALE = 2 ** DQ

def compare(real_file):
    data_list = []
    fp = open(real_file, 'r')
    for line in fp:
        data_list.append(float(line.strip()))
    real_array = np.array(data_list)
    print real_array

    plt.figure(1)
    plot2 = plt.plot(np.arange(len(real_array)), real_array, 'b')
    plt.show()



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "real_file",
        help="real results file."
    )
    args = parser.parse_args()

    compare(args.real_file)

