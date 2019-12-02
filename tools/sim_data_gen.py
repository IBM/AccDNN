import sys
import os
#sys.path.append(os.path.abspath(os.path.join('..')))
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import caffe
import numpy as np
import argparse
from settings import *
from util.data import mat_dump_int, mat_dump_float, mat2uint16, uint16_dump_hex_aligned
import model

def sim_data_gen(model_file, pretrained_model, imagepath, batch_size, iteration):
    caffe.set_mode_cpu()
    net = caffe.Net(model_file, pretrained_model, caffe.TEST)

    # mu = np.load('/home/uchen/caffe/python/caffe/imagenet/ilsvrc_2012_mean.npy').mean(1).mean(1)
    # mu = np.array([104.00698793, 116.66876762, 122.67891434])
    mu = np.array([128.0, 128.0, 128.0])
    # create transformer for the input called 'data'
    transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
    transformer.set_transpose('data', (2,0,1))  # move image channels to outermost dimension
    transformer.set_mean('data', mu)            # subtract the dataset-mean value in each channel
    transformer.set_raw_scale('data', 255)      # rescale from [0, 1] to [0, 255]
    transformer.set_channel_swap('data', (2,1,0))

    image = caffe.io.load_image(imagepath)
    transformed_image = transformer.preprocess('data', image)

    # copy the image data into the memory allocated for the net
    net.blobs['data'].data[0] = transformed_image
    
    # perform classification
    output = net.forward()

    model_inst = model.Model(model_file, pretrained_model)
    model_inst.parser()
    model_inst.module_params_compute()
    
    # extract the data from the blobs
    for k, v in net.blobs.items():
        blob_data = v.data[0]
        if k == 'data':  #input data, will used in testbench
            if INPUT_CHANNEL_PADDING > 0:
                blob_data_new = np.zeros((blob_data.shape[0]+INPUT_CHANNEL_PADDING, blob_data.shape[1], blob_data.shape[2]))
                blob_data_new[0:blob_data.shape[0],:,:] = blob_data
                blob_data = blob_data_new
            blob_data_shaped = np.zeros((batch_size,  blob_data.shape[0]*blob_data.shape[1]*blob_data.shape[2]))
            for batch_idx in range(batch_size):
                blob_data_shaped[batch_idx] = blob_data.transpose(2, 1, 0).reshape(-1)
            blob_data_shaped = blob_data_shaped.transpose(1, 0).reshape(-1)
            data_align = CAPI_DATA_BUS_WIDTH / model_inst.modules[0].input_dw
            if len(blob_data_shaped) % data_align:
                blob_data_shaped = np.append(blob_data_shaped, \
                    np.zeros(data_align - len(blob_data_shaped) % data_align, dtype=float))

            blob_data_shaped_uint16 = mat2uint16(blob_data_shaped, model_inst.modules[0].input_dw,  model_inst.modules[0].input_dq)
            blob_data_shaped_uint16_iteration = np.array([])
            for iter_index in range(iteration):
                blob_data_shaped_uint16_iteration = np.append(blob_data_shaped_uint16_iteration, blob_data_shaped_uint16)
            blob_data_shaped_uint16_iteration = blob_data_shaped_uint16_iteration.reshape(-1, data_align)
            
            file_path_name = DUMP_BLOB_DATA_PATH + '/input_sim.dat'
            uint16_dump_hex_aligned(file_path_name, blob_data_shaped_uint16_iteration)

            file_path_name = DUMP_BLOB_DATA_PATH + '/input.jpg'
            mat_dump_int(file_path_name, blob_data_shaped, model_inst.modules[0].input_dw,  model_inst.modules[0].input_dq)
            continue

        if blob_data.ndim == 3:
            blob_data = blob_data.transpose(2, 1, 0).reshape(-1)
        elif blob_data.ndim == 1:
            blob_data = blob_data.reshape(-1)
        else:
            raise Exception ("Blob data dimension is not know.")
        module_inst = model_inst.get_inst_by_layer_name(k)
        if module_inst is None:
            print '{} layer is not found.'.format(k)
            # file_path_name = DUMP_BLOB_DATA_PATH + '/' + k + '.dat'
            # mat_dump_float(file_path_name, blob_data, 8,  1)
            continue
        file_path_name = DUMP_BLOB_DATA_PATH + '/' + k + '.dat'
        mat_dump_float(file_path_name, blob_data, module_inst.output_dw,  module_inst.output_dq)

if __name__ == '__main__':
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
    parser.add_argument(
        "imagepath",
        help="Test image path."
    )
    parser.add_argument(
        "--batch_size",
        type=int,
        default=BATCH_SIZE,
        help="Batch size."
    )

    parser.add_argument(
        "--iter",
        type=int,
        default=1,
        help="iterations."
    )
    
    # Optional arguments.
    args = parser.parse_args()

    #if os.path.exists(DUMP_BLOB_DATA_PATH):
    #    os.system('rm -rf ' + DUMP_BLOB_DATA_PATH)
    #os.system('mkdir -p ' + DUMP_BLOB_DATA_PATH)

    sim_data_gen(args.model_file, args.pretrained_model, args.imagepath, args.batch_size, args.iter)


