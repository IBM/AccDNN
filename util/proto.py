#!/usr/bin/env python

from settings import *
from caffe.proto import caffe_pb2
from google.protobuf import text_format

def readProtoFile(filepath, parser_object):
    fd = open(filepath, "r")
    if not fd:
        raise Exception("ERROR (" + filepath + ")!")
    text_format.Merge(str(fd.read()), parser_object)
    fd.close()
    return parser_object
