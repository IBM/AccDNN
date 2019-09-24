import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
import argparse
import glob
from settings import *

import model
import caffe


def main(argv):
    pycaffe_dir = os.path.dirname(__file__)

    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "model_file",
        help="Model definiftion file."
    )
    parser.add_argument(
        "pretrained_model",
        help="Trained model weights file."
    )
    # Optional arguments.
    parser.add_argument(
        "--optim_file",
        default=None,
        help="Manual optimization file, will use automatic optimization by default."
    )
    parser.add_argument(
        "--fpga_type",
        default=None,
        help="FPGA type, if not provide, will use the default type in settings.py file."
    )
    parser.add_argument(
        "--batch_size",
        type=int,
        default=BATCH_SIZE,
        help="Batch size."
    )
    parser.add_argument(
        "--profile",
        action='store_true',
        help="Only profile the network."
    )
    # Optional arguments.
    args = parser.parse_args()

    if not os.path.exists(args.model_file):
        raise Exception ('Can not find the model file: {}'.format(args.model_file))
    if not os.path.exists(args.pretrained_model):
        raise Exception ('Can not find the pretrained model file: {}'.format(args.pretrained_model))
    if (args.optim_file is not None) and (not os.path.exists(args.optim_file)):
        raise Exception ('Can not find the optimization file: {}'.format(args.optim_file))


    if os.path.exists(OUTPUT_PATH):
        os.system('rm -rf ' + OUTPUT_PATH)
    os.system('mkdir -p ' + OUTPUT_PATH)
    os.system('mkdir -p ' + VERILOG_FILE_PATH)
    os.system('mkdir -p ' + MEM_COE_FILE_PATH)
    os.system('mkdir -p ' + TIMING_FILE_PATH)

    caffe.set_mode_cpu()
    if not args.profile:
        model_inst = model.Model(args.model_file, args.pretrained_model, args.batch_size)
    else:
        model_inst = model.Model(args.model_file, None, args.batch_size)
    model_inst.parser(args.optim_file)
    if args.optim_file is None:
        model_inst.parallelism_auto_optimization()
    model_inst.module_params_compute()
    model_inst.module_summary()
    if not args.profile:
        model_inst.memory_coe_file_gen()
    model_inst.ipcores_gen(args.fpga_type)
    model_inst.code_gen()
    model_inst.memory_summary()
    model_inst.profile()
    model_inst.file_list_gen()
    model_inst.timing_constraints_gen()
    model_inst.register_map_gen()

if __name__ == '__main__':
    main(sys.argv)
