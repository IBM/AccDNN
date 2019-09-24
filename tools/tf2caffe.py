#!/usr/bin/env python

import caffe
import tensorflow as tf
from util.proto import readProtoFile
import numpy as np
import sys
import argparse
import copy

def find_weight(name, shape, key, var_dic):
    for k, v in var_dic.items():
        if k.startswith(name) and v.shape == shape and (key in k):
            return v
    return None

def get_layer_info(layer_list, layer_name):
    for object_ in layer_list:
        if object_.name == layer_name:
            return object_
    return None

def tf2caffe(meta, ckp, net_file, output_model):
    saver = tf.train.import_meta_graph(meta)
    with tf.Session() as sess:
        saver.restore(sess, ckp)
        train_vars = tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES)
        train_vars.extend(tf.get_collection(tf.GraphKeys.MODEL_VARIABLES))
        train_vars.extend(tf.global_variables())
        var_dic = {}
        for v in train_vars:
            var_dic[v.name] = v.eval()
            #print v.name, var_dic[v.name].shape

    net_config = caffe.proto.caffe_pb2.NetParameter()
    layer_list = readProtoFile(net_file, net_config).layer
         
    net = caffe.Net(net_file, caffe.TEST)
    for k, v in net.params.items():
        layer_info = get_layer_info(layer_list, k)
        assert layer_info.name == k
        if layer_info.type == 'Convolution':
            kernel_shape = v[0].data.shape
            tf_kernel_shape = (kernel_shape[2], kernel_shape[3], kernel_shape[1], kernel_shape[0])
            # use layer name, weights shape to find the corresponding weight from tensor vars
            weights = find_weight(k, tf_kernel_shape, 'kernel:0', var_dic)
            if weights is None:
                raise Exception('Layer [%s]: weights not found.'%layer_info.name)
            # transpose from H*W*C*K to K*C*H*W
            v[0].data[...] = weights.transpose(3, 2, 0, 1)
            if layer_info.convolution_param.bias_term:
                bias = find_weight(k, v[1].data.shape, 'bias:0', var_dic)
                if bias is None:
                    raise Exception('Layer [%s]: bias not found.'%layer_info.name)
                v[1].data[...] = bias
        elif layer_info.type == 'InnerProduct':
            kernel_shape = v[0].data.shape
            tf_kernel_shape = (kernel_shape[1], kernel_shape[0])
            weights = find_weight(k, tf_kernel_shape, 'kernel:0', var_dic)
            if weights is None:
                raise Exception('Layer [%s]: weights not found.'%layer_info.name)
            # check if need shape
            if len(net.blobs[layer_info.bottom[0]].data.shape) > 2:
                input_shape = net.blobs[layer_info.bottom[0]].data.shape[1:]
                weight_shape = weights.shape
                v[0].data[...] = weights.reshape(input_shape[1], input_shape[2], input_shape[0], weight_shape[1])\
                                        .transpose(2,0,1,3).reshape(-1, weight_shape[1]).transpose(1,0)
            else:
                v[0].data[...] = weights.transpose(1, 0)
            if layer_info.inner_product_param.bias_term:
                bias = find_weight(k, v[1].data.shape, 'bias:0', var_dic)
                if bias is None:
                    raise Exception('Layer [%s]: bias not found.'%layer_info.name)
                v[1].data[...] = bias
        elif layer_info.type == 'BatchNorm':
            prefix = layer_info.name.split('_')[0]
            moving_mean = find_weight(prefix, v[0].data.shape, 'moving_mean:0', var_dic)
            if moving_mean is None:
                raise Exception('Layer [%s]: moving_mean data not found.'%layer_info.name)
            moving_variance = find_weight(prefix, v[1].data.shape, 'moving_variance:0', var_dic)
            if moving_variance is None:
                raise Exception('Layer [%s]: moving_variance data not found.'%layer_info.name)
            v[0].data[...] = moving_mean
            v[1].data[...] = moving_variance
            v[2].data[...] = 1.0
        elif layer_info.type == 'Scale':
            prefix = layer_info.name.split('_')[0]
            gamma = find_weight(prefix, v[0].data.shape, 'gamma:0', var_dic)
            if gamma is None:
                raise Exception('Layer [%s]: gamma data not found.'%layer_info.name)
            beta = find_weight(prefix, v[1].data.shape, 'beta:0', var_dic)
            if beta is None:
                raise Exception('Layer [%s]: beta data not found.'%layer_info.name)
            if len(v) < 2:
                raise Exception('Layer [%s]: please set bias to true in Scale layer for batch normlization.'%layer_info.name)
            v[0].data[...] = gamma
            v[1].data[...] = beta
        else:
            raise Exception('Layer type [%s] is not supported.'%layer_info.type)
                   
    net.save(output_model)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    # Required arguments: input and output files.
    parser.add_argument(
        "--meta",
        default=None,
        help="tensorflow graph meta data."
    )
    parser.add_argument(
        "--ckp",
        default=None,
        help="tensorflow checkpoint file."
    )
    parser.add_argument(
        "--prototxt",
        default=None,
        help="Caffe prototxt file."
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Caffe model file."
    )

    # Optional arguments.
    args = parser.parse_args()

    tf2caffe(args.meta, args.ckp, args.prototxt, args.output)

