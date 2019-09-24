## The affect of quantization of activations and weights, and the accuracy of retrained model.

| Model Name   | caffemodel(retrain)                   | caffemodel_url                                         | Quantized   | Retrained   |
| :----------- | :------------------------------------ | :----------------------------------------------------  | :---------: | :---------: |
| ZF-Float     | caffe_ZF_train_iter_360000.caffemodel | https://ibm.box.com/s/1c8pr7yv5ns9h5b69u7f3dgkeivo9pc7 | 0.580/0.808 |     --      |
| ZF-A16C16F16 | ZF_A16C16F16_iter_1000.caffemodel     | https://ibm.box.com/s/cr656hw2dx1445lef27vrr61zm6k5n71 | 0.566/0.797 | 0.578/0.808 |
| ZF-A16C16F8  | ZF_A16C16F8_iter_1000.caffemodel      | https://ibm.box.com/s/mh3gtxa5fvf76wvftc95a13tdbmhiif2 | 0.566/0.797 | 0.575/0.808 |
| ZF-A16C8F8   | ZF_A16C8F8_iter_1000.caffemodel       | https://ibm.box.com/s/i3nlh39m1nnndvg20ajl1cjn0reigpuy | 0.563/0.796 | 0.576/0.805 |
| ZF-A16C8F4   | ZF_A16C8F4_iter_2000.caffemodel       | https://ibm.box.com/s/51fm2zhb1zl049e507g8137gi79kai8n | 0.548/0.787 | 0.563/0.799 |

#### Remark

ZF-Float means the float32 model, not been quantized.

ZF-A16C16F16 means the activations are quantized to 16bits, the weights of the convolutional layer are quantized to 16bits, the weights of the fully connected layer are quantized to 16bits.

0.566/0.797 means the accuracy of top1 and top5 is 56.6% and 79.7%, respectively.

All the quantized models are trained by [ristretto Caffe](https://github.com/pmgysel/caffe).
