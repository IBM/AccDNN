#***************************************************************
# Global settings
#***************************************************************
# AccDNN Function Mode
# Set to True when only needs to simulation.
# Keep it False, if you need to generated FPGA bit/bin file.
SIMULATION_ONLY = False

# Default Batch Size
# Could be changed throguh the command line.
# When using auto optimization, this setting will be ignored.
BATCH_SIZE = 1

#****************************************************************
# Define the FPGA related imformation
#****************************************************************
# Default Xilinx FPGA type
# Only Xilinx FPGA is supported.
# Could be changed through the command line.
XILINX_FPGA_TYPE = 'xc7vx690tffg1157-2'

# Target Clock Frequency (MHz)
# This frequency is only used for performance profile.
# The real frequency depends on the clock provided framework.
# AccDNN provides a sync logic implementation, the user should 
# provide the clock input.
CLOCK_FREQUENCY = 200.0

# Distributed Memory settings
# Set True to enable distributed memory.
# Only for the reshape memory of the pooling layer.
# Could be enabled when there are not enough BRAMs.
DIST_MEM_ENABLE = False
# If the required memory satisfies the following rules,
# distributed memory will be used instead of BRAM.
DIST_MEM_MAX_WIDTH = 1024
DIST_MEM_MIN_DEPTH = 16
DIST_MEN_MAX_DEPTH = 512

# The threshold of using memory hierarchy technology for weight memory. 
# If the total weight momory is less than this threshold, all the weights
# will be stored in FPGA on-chip memory, otherwise the weights will be stored
# off-chip DDR, we it can use memory hierarchy technology to exchange between 
# the FPGA on-chip memory and the off-chip DDR. (unit:KBytes)
# 32KB could be a reasonable value, set to 0 if appy memory hierarchy to all
# weights.
WM_HIERARCHY_THRES = 0

# Resource usage for auto optimization
# For manual optimization, this parameter will be ignored.
# You could decrease the threshold if you have serious timing issue,
# or increase the threshold if you want to use as much resource as 
# possible. For manual optimization, this threshold will be ignored.
RESOURCE_THRES = 0.9
# Resource Warning Threshold
# Only for BRAM16E/DSP resource.
# High resource utilization may cause serious timming issue.
# If the Resource percentage is larger than this threshold, 
# a warning will be generated.
RESOURCE_WARNING_THRES = 0.9

#*****************************************************************
# Wights/Activations quantization settings
#*****************************************************************
# If the weights/activations' width and Q are provided in the model
# file, the following settings will be ignored.
# Maximal weights/activations width
MAX_DW = 16
# Default weights/activations width
# Ignored if the model file provides the quantization information.
DW = 16
# Default Q of the weights, Q13
# Ignored if the model file provides the quantization information.
WQ = 13
# Default Q of the activations, Q6
# Ignored if the model file provides the quantization information.
DQ = 6

# ****************************************************************
# Define the locations of the generated file
# ****************************************************************
# AccDNN Project root
DNN2FPGA_ROOT = '.'
# Build output path
OUTPUT_PATH = DNN2FPGA_ROOT + '/build'
# Path of the operator conf file
OPERATOR_CONF_FILE_PATH = DNN2FPGA_ROOT + '/conf/operator.conf'
# Path of the hardware conf file
HARDWARE_CONF_FILE_PATH = DNN2FPGA_ROOT + '/conf/hardware.conf'
# Path of the lib source files
LIB_SOURCE_FILE_PATH = DNN2FPGA_ROOT + '/lib/verilog'
# Path of the lib IP files
LIB_IP_FILE_PATH = DNN2FPGA_ROOT + '/lib/ip'
# Path of the generated source code
VERILOG_FILE_PATH = OUTPUT_PATH + '/src'
# Path of the generated TCL file
TCL_FILE_PATH = OUTPUT_PATH
# Path of the generated COE files
MEM_COE_FILE_PATH = OUTPUT_PATH + '/coe'
# Path of the generated timing constraint file
TIMING_FILE_PATH = OUTPUT_PATH + '/timing'
# Path of source/ip list files for implemetation or simulation
# Would add to vivado peroject
FILE_LIST_PATH = OUTPUT_PATH

# Path for the simulation
# Path of the list files for simulation
SIM_FILE_LIST_PATH = DNN2FPGA_ROOT + '/sim/'
# Path of the data files for simulation
DUMP_BLOB_DATA_PATH = DNN2FPGA_ROOT + '/sim/data'

# Settings for the IP cores generation
# project name for generate IP cores
IP_PROJECT_NAME = 'ips_prj'
# Path of ips project
IP_PROJECT_PATH =  OUTPUT_PATH + '/' + IP_PROJECT_NAME
# Path of set ips cores
IP_FILE_PATH = IP_PROJECT_PATH + '/' + IP_PROJECT_NAME + '.srcs' + '/sources_1/ip'

# ****************************************************************
# AccDNN I/O settings
# ****************************************************************
# Data bus width of input and output
CAPI_DATA_BUS_WIDTH = 512

# DDR/DMA data bus width
DDR_DATA_WIDTH = 512
# Number of DDR DMA channels
DDR_DMA_ENGINE_NUM = 15
# Max DDR DMA delay
MAX_DDR_DMA_DELAY = 2
# Default DDR DMA delay
DEFAULT_DDR_DMA_DELAY = 0
# Parameter when packaging the weights for DDR
WEIGHTS_ALIGN = DDR_DATA_WIDTH / 16

# ***************************************************************
# Interal parallelism setting for AccDNN
# ***************************************************************
# Max interal memory bus width
MAX_BUS_WIDTH = 4096

# MAX parallelism for channels and kernels
MAX_CPF = 64
MAX_KPF = 64

# Padding additional channels for the input blob, 
# To make the channel equal 2^N will benifit parallelism.
# For example, to padding the RGB to RGBX.
INPUT_CHANNEL_PADDING = 1

# Webserivce settings
# if enbaled, the profile will return the json formated string
WEBSERVICE = True

