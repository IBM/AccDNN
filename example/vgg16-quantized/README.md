## The affect of quantization of activations and weights, and the accuracy of retrained model.

| Model Name    | caffemodel(retrain)                   | caffemodel_url                                         | Quantized   | Retrained   |
| :-----------  | :------------------------------------ | :----------------------------------------------------  | :---------: | :---------: |
| VGG16-Float   | VGG_ILSVRC_16_layers.caffemodel       | http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_16_layers.caffemodel | 0.683/0.884 |     --      |
| VGG16-A16C8F4 | vgg16_A16C8F4_iter_2000.caffemodel    | https://ibm.box.com/s/oz7kqwsq68sxued5ub1hj46s89d6j3ta | 0.670/0.877 | 0.693/0.893 |

#### Remark

VGG16-Float means the float32 model, not been quantized.

VGG16-A16C8F4 means the activations are quantized to 16bits, the weights of the convolutional layer are quantized to 8bits, the weights of the fully connected layer are quantized to 4bits.

0.670/0.877 means the accuracy of top1 and top5 is 67.0% and 0.877%, respectively.

All the quantized models are trained by [ristretto Caffe](https://github.com/pmgysel/caffe).
