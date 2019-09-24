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

#######################################################################################################################################
add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_eop
add wave -noupdate -format Literal /model_tb/u0_module/input_blob_din
add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_en
add wave -noupdate -format Logic /model_tb/u0_module/input_blob_din_rdy

add wave -noupdate -format Logic /model_tb/u0_module/conv1_1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv1_1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv1_1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv1_1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv1_2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv1_2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv1_2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv1_2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv2_1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv2_1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv2_1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv2_1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv2_2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv2_2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv2_2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv2_2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv3_1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv3_1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv3_1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv3_1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv3_2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv3_2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv3_2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv3_2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv3_3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv3_3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv3_3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv3_3_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool3_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv4_1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv4_1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv4_1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv4_1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv4_2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv4_2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv4_2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv4_2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv4_3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv4_3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv4_3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv4_3_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/pool4_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/pool4_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv5_1_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv5_1_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv5_1_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv5_1_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv5_2_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv5_2_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv5_2_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv5_2_blob_dout_eop

add wave -noupdate -format Logic /model_tb/u0_module/conv5_3_blob_dout_rdy
add wave -noupdate -format Logic /model_tb/u0_module/conv5_3_blob_dout_en
add wave -noupdate -format Literal /model_tb/u0_module/conv5_3_blob_dout
add wave -noupdate -format Logic /model_tb/u0_module/conv5_3_blob_dout_eop

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

#add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_rdy
#add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_en
#add wave -noupdate -format Literal /model_tb/u0_module/fc8_blob_dout
#add wave -noupdate -format Logic /model_tb/u0_module/fc8_blob_dout_eop

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
