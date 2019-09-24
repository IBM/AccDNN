## The affect of quantization of activations and weights, and the accuracy of retrained model.

| Model Name       | caffemodel(retrain)                        | caffemodel_url                                         | Quantized   | Retrained   |
| :--------------  | :------------------------------------      | :----------------------------------------------------  | :---------: | :---------: |
| Alexnet-Float    | caffe_alexnet_train_iter_450000.caffemodel | https://ibm.box.com/s/tuwh6evzlci2u29cmklzi0vtksiui5ie | 0.557/0.790 |     --      |
| Alexnet-A16C8F8  | alexnet_A16C8F8_iter_2000.caffemodel       | https://ibm.box.com/s/3yornxvwwkz5r4r04izm4raxgy0a8huk | 0.533/0.773 | 0.551/0.787 |
| Alexnet-A16C8F4  | alexnet_A16C8F4_iter_2000.caffemodel       | https://ibm.box.com/s/216l6uroklp3tk0ujhim99cmceo95axv | 0.518/0.762 | 0.539/0.779 |

#### Remark

Alexnet-Float means the float32 model, not been quantized.

Alexnet-A16C8F8 means the activations are quantized to 16bits, the weights of the convolutional layer are quantized to 8bits, the weights of the fully connected layer are quantized to 8bits.

0.557/0.790 means the accuracy of top1 and top5 is 57.7% and 79.0%, respectively.

All the quantized models are trained by [ristretto Caffe](https://github.com/pmgysel/caffe).
