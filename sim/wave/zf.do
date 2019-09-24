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

########################################################################################################################################
add wave -noupdate -format Logic /model_tb/u0_module/clk
add wave -noupdate -format Logic /model_tb/u0_module/rst

add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_0
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_0
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_1
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_1
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_2
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_2
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_3
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_3
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_4
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_4
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_5
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_5
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_6
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_6
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_req_7
add wave -noupdate -format Logic /model_tb/u0_module/ddr_read_ack_7

add wave -noupdate -format Logic /model_tb/u0_module/layer_ddr_read_req_3
add wave -noupdate -format Logic /model_tb/u0_module/layer_ddr_read_ack_3
add wave -noupdate -format Literal /model_tb/u0_module/layer_ddr_read_addr_3
add wave -noupdate -format Literal /model_tb/u0_module/layer_ddr_read_length_3
add wave -noupdate -format Literal /model_tb/u0_module/layer_ddr_dout_3
add wave -noupdate -format Logic /model_tb/u0_module/layer_ddr_dout_en_3
add wave -noupdate -format Logic /model_tb/u0_module/layer_ddr_dout_eop_3

#######################################################################################################################################
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/clk
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/rst

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_din_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_din_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/blob_din
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_din_eop

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/blob_din_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/data_blob_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/weight_blob_rdy
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_log_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_phy_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_cnt
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_full
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_addr_offset
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_addr_base_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_addr_base
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_wr_addr

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/module_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/module_c

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_rd_log_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_rd_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_rd_phy_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_rd_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/rm_rd_addr

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/c_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/h_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/h_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/w_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/h_c
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/h_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/w_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/pos_h
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/pos_w

add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/module_en_cnt
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_change_signal
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/dma_engineer_req
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/dma_engineer_req_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/dma_engineer_start_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/dma_engineer_length
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/dma_engineer_ack
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_wr_addr_sel
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_rdy_sel
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_wr_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_wr_addr
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/ping_buf_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/pong_buf_rdy

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_rd_sel
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_rd_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/u_controller/double_buf_rd_addr

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/u_controller/rm_addr_val
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/op_din_en
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/op_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/op_weight
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/op_data_0

add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_conv4_layer/blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/u0_conv4_layer/blob_dout_eop

#####################################################################################################################################
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/clk
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/rst

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_din_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_din_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/blob_din
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_din_eop

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/blob_din_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/data_blob_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/weight_blob_rdy
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_log_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_phy_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_cnt
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_full
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_addr_offset
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_addr_base_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_addr_base
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_wr_addr

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/module_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/module_c

add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_rd_log_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_rd_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_rd_phy_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_rd_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/rm_rd_addr

add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/c_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/h_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/h_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/w_w_count
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/h_c
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/h_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/w_add
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/pos_h
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/pos_w

add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/module_en_cnt
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_change_signal
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/dma_engineer_req
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/dma_engineer_req_cnt
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/dma_engineer_start_addr
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/dma_engineer_length
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/dma_engineer_ack
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_wr_addr_sel
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_rdy_sel
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_wr_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_wr_addr
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/ping_buf_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/pong_buf_rdy

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_rd_sel
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_rd_addr_tmp
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/u_controller/double_buf_rd_addr

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/u_controller/rm_addr_val
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/op_din_en
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/op_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/op_weight
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/op_data_0

add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/u0_fc6_layer/blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/u0_fc6_layer/blob_dout_eop

#######################################################################################################################################
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

add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv4_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv4_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv5_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv5_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool5_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool5_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/fc6_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/fc6_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/fc6_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/fc6_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/fc7_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/fc7_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/fc7_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/fc7_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/fc8_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_eop

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
