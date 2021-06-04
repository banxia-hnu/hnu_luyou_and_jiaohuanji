## Generated SDC file "netFPGAmini.out.sdc"

## Copyright (C) 1991-2010 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Full Version"

## DATE    "Mon Jul 18 11:28:04 2011"

##
## DEVICE  "EP2AGX45DF25C5"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {sysclk_125m} -period 8.000 -waveform { 0.000 4.000 } [get_ports {sysclk_125m}]
create_clock -name {sysclk_100m} -period 10.000 -waveform { 0.000 5.000 } [get_ports {sysclk_100m}]
create_clock -name {rgm0_rx_clk} -period 8.000 -waveform { 0.000 4.000 } [get_ports {rgm0_rx_clk}]
create_clock -name {rgm1_rx_clk} -period 8.000 -waveform { 0.000 4.000 } [get_ports {rgm1_rx_clk}]
create_clock -name {rgm2_rx_clk} -period 8.000 -waveform { 0.000 4.000 } [get_ports {rgm2_rx_clk}]
create_clock -name {rgm3_rx_clk} -period 8.000 -waveform { 0.000 4.000 } [get_ports {rgm3_rx_clk}]
create_clock -name {sfp_clk0} -period 8.000 -waveform { 0.000 4.000 } [get_ports {sfp_clk0}]





#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

