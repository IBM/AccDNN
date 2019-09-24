add wave -noupdate -format Logic /model_tb/clk
add wave -noupdate -format Logic /model_tb/ddr_rst
add wave -noupdate -format Logic /model_tb/rst
add wave -noupdate -format Logic /model_tb/init_calib_complete
add wave -noupdate -format Logic /model_tb/input_rdy
add wave -noupdate -format Literal /model_tb/input_count

add wave -noupdate -format Logic /model_tb/write_req
add wave -noupdate -format Literal /model_tb/write_start_addr
add wave -noupdate -format Literal /model_tb/write_length
add wave -noupdate -format Literal /model_tb/weight_count
add wave -noupdate -format Logic /model_tb/ddr_din_en
add wave -noupdate -format Literal /model_tb/ddr_din
add wave -noupdate -format Logic /model_tb/ddr_din_rdy
add wave -noupdate -format Logic /model_tb/ddr_din_eop
add wave -noupdate -format Logic /model_tb/write_done

add wave -noupdate -format Logic /model_tb/blob_din_en
add wave -noupdate -format Literal /model_tb/blob_din
add wave -noupdate -format Logic /model_tb/blob_din_rdy
add wave -noupdate -format Logic /model_tb/blob_din_eop
#####################################################################################################################################
add wave -noupdate -format Logic /model_tb/clk

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/rm_rd_log_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/rm_rd_cnt

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/c_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/h_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/h_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/w_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/h_c
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/h_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/w_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/pos_h
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_controller/pos_w

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/op_din_en
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/op_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/op_weight
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/op_data_0

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_din_en
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_din
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_weight
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_bias
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_bias_d1
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_din_en_d1
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/op_din_eop_d2

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/a2_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/bias_tmp

#add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/gen_adder_8b/a2_tmp_0
#add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/gen_adder_8b/a2_tmp_1
#add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/gen_adder_8b/a2_tmp_reg
#add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/gen_adder_8b/a2_tmp_sel
#add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/bias_tmp

add wave -noupdate -format Logic /model_tb/clk
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/acc_in
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/gen_block_with_bn/acc_mid
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/gen_block_with_bn/bn_scale
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/gen_block_with_bn/acc_scaled
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/gen_block_with_bn/bn_bias_d1
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/gen_block_with_bn/batch_out 
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/op_dout_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_1/u_bn_bias_relu/op_dout

#add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/blob_dout_en_fifo
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/blob_dout_en
#add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/blob_dout_fifo
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/blob_dout

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_0/op_dout_tmp
#add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_0/gen_out_8bits/op_dout_reg
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/u_vector_muladd_0_0/op_dout

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv1_layer/blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/blob_dout_eop


######################################################################################################################################
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/clk
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv1_layer/rst

add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/input_blob_din
add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_en
add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_rdy

add wave -noupdate -format Logic /model_tb/u0_module/conv1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv3_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv4_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool4_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv5_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool5_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv6_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv6_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv6_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv6_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv7_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv7_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv7_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv7_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv8_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv8_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv8_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv8_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv9_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv9_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv9_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv9_blob_dout_eop


add wave -noupdate -format Logic /model_tb/u0_module/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/blob_dout_eop


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1768 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 170
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {6960 ns}
