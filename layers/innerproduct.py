from layers.convolution import Convolution
import numpy as np

class InnerProduct(Convolution):
    def __init__(self, layer_name, input_shape, input_width, input_stride, output_shape, params, cpf=1, kpf=1):
        kernel_num = params[0].shape[0]
        kernel_shape = tuple([params[0].shape[1], 1, 1])
        #reshape the matrix from 2-dim to 4-dim
        weights_shape = tuple([kernel_num, kernel_shape[0], kernel_shape[1], kernel_shape[2]])
        print "Layer %s: Weights will be reshaped from %s to %s."%(layer_name, params[0].shape, weights_shape);
        params[0] =  params[0].reshape(weights_shape)

        if input_shape[0] != kernel_shape[0]:
            input_shape_old = input_shape
            input_shape_new = tuple([input_shape[0] * input_shape[1] * input_shape[2], 1, 1])
            print "Layer %s: Input data will be reshaped from %s to %s."%(layer_name, input_shape, input_shape_new)
            input_shape = input_shape_new
            #weights will do the permutation.
            params[0] = params[0].reshape(kernel_num, input_shape_old[0], input_shape_old[1], input_shape_old[2]) \
                             .transpose(0, 3, 2, 1) \
                             .reshape(kernel_num, input_shape_old[0]*input_shape_old[1]*input_shape_old[2], 1, 1)
        else:
            input_shape = tuple([input_shape[0], 1, 1])
        
        output_shape = tuple([output_shape[0], 1, 1])

        super(InnerProduct, self).__init__(layer_name, input_shape, input_width, input_stride, output_shape, params, 0, 0, cpf, kpf)
        self.layer_type = 'InnerProduct'
        

if __name__  == '__main__':
    pass
