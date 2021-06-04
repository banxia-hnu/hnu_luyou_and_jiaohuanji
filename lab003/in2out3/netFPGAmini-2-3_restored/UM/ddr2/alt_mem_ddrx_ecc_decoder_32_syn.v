// megafunction wizard: %ALTECC%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altecc_decoder 

// ============================================================
// File Name: alt_mem_ddrx_ecc_decoder_32.v
// Megafunction Name(s):
// 			altecc_decoder
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 10.0 Internal Build 257 07/26/2010 SP 1 PN Full Version
// ************************************************************


//Copyright (C) 1991-2010 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


//altecc_decoder device_family="Stratix III" lpm_pipeline=0 width_codeword=39 width_dataword=32 data err_corrected err_detected err_fatal q
//VERSION_BEGIN 10.0SP1 cbx_altecc_decoder 2010:07:26:21:21:15:PN cbx_cycloneii 2010:07:26:21:21:15:PN cbx_lpm_add_sub 2010:07:26:21:21:15:PN cbx_lpm_compare 2010:07:26:21:21:15:PN cbx_lpm_decode 2010:07:26:21:21:15:PN cbx_mgl 2010:07:26:21:25:47:PN cbx_stratix 2010:07:26:21:21:16:PN cbx_stratixii 2010:07:26:21:21:16:PN  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



//lpm_decode DEVICE_FAMILY="Stratix III" LPM_DECODES=64 LPM_WIDTH=6 data eq
//VERSION_BEGIN 10.0SP1 cbx_cycloneii 2010:07:26:21:21:15:PN cbx_lpm_add_sub 2010:07:26:21:21:15:PN cbx_lpm_compare 2010:07:26:21:21:15:PN cbx_lpm_decode 2010:07:26:21:21:15:PN cbx_mgl 2010:07:26:21:25:47:PN cbx_stratix 2010:07:26:21:21:16:PN cbx_stratixii 2010:07:26:21:21:16:PN  VERSION_END

//synthesis_resources = lut 72 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  alt_mem_ddrx_ecc_decoder_32_decode
	( 
	data,
	eq) /* synthesis synthesis_clearbox=1 */;
	input   [5:0]  data;
	output   [63:0]  eq;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [5:0]  data;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [5:0]  data_wire;
	wire  [63:0]  eq_node;
	wire  [63:0]  eq_wire;
	wire  [3:0]  w_anode1000w;
	wire  [3:0]  w_anode1010w;
	wire  [3:0]  w_anode1020w;
	wire  [3:0]  w_anode1030w;
	wire  [3:0]  w_anode1041w;
	wire  [3:0]  w_anode1053w;
	wire  [3:0]  w_anode1064w;
	wire  [3:0]  w_anode1074w;
	wire  [3:0]  w_anode1084w;
	wire  [3:0]  w_anode1094w;
	wire  [3:0]  w_anode1104w;
	wire  [3:0]  w_anode1114w;
	wire  [3:0]  w_anode1124w;
	wire  [3:0]  w_anode1135w;
	wire  [3:0]  w_anode1147w;
	wire  [3:0]  w_anode1158w;
	wire  [3:0]  w_anode1168w;
	wire  [3:0]  w_anode1178w;
	wire  [3:0]  w_anode1188w;
	wire  [3:0]  w_anode1198w;
	wire  [3:0]  w_anode1208w;
	wire  [3:0]  w_anode1218w;
	wire  [3:0]  w_anode464w;
	wire  [3:0]  w_anode482w;
	wire  [3:0]  w_anode499w;
	wire  [3:0]  w_anode509w;
	wire  [3:0]  w_anode519w;
	wire  [3:0]  w_anode529w;
	wire  [3:0]  w_anode539w;
	wire  [3:0]  w_anode549w;
	wire  [3:0]  w_anode559w;
	wire  [3:0]  w_anode571w;
	wire  [3:0]  w_anode583w;
	wire  [3:0]  w_anode594w;
	wire  [3:0]  w_anode604w;
	wire  [3:0]  w_anode614w;
	wire  [3:0]  w_anode624w;
	wire  [3:0]  w_anode634w;
	wire  [3:0]  w_anode644w;
	wire  [3:0]  w_anode654w;
	wire  [3:0]  w_anode665w;
	wire  [3:0]  w_anode677w;
	wire  [3:0]  w_anode688w;
	wire  [3:0]  w_anode698w;
	wire  [3:0]  w_anode708w;
	wire  [3:0]  w_anode718w;
	wire  [3:0]  w_anode728w;
	wire  [3:0]  w_anode738w;
	wire  [3:0]  w_anode748w;
	wire  [3:0]  w_anode759w;
	wire  [3:0]  w_anode771w;
	wire  [3:0]  w_anode782w;
	wire  [3:0]  w_anode792w;
	wire  [3:0]  w_anode802w;
	wire  [3:0]  w_anode812w;
	wire  [3:0]  w_anode822w;
	wire  [3:0]  w_anode832w;
	wire  [3:0]  w_anode842w;
	wire  [3:0]  w_anode853w;
	wire  [3:0]  w_anode865w;
	wire  [3:0]  w_anode876w;
	wire  [3:0]  w_anode886w;
	wire  [3:0]  w_anode896w;
	wire  [3:0]  w_anode906w;
	wire  [3:0]  w_anode916w;
	wire  [3:0]  w_anode926w;
	wire  [3:0]  w_anode936w;
	wire  [3:0]  w_anode947w;
	wire  [3:0]  w_anode959w;
	wire  [3:0]  w_anode970w;
	wire  [3:0]  w_anode980w;
	wire  [3:0]  w_anode990w;
	wire  [2:0]  w_data462w;

	assign
		data_wire = data,
		eq = eq_node,
		eq_node = eq_wire[63:0],
		eq_wire = {{w_anode1218w[3], w_anode1208w[3], w_anode1198w[3], w_anode1188w[3], w_anode1178w[3], w_anode1168w[3], w_anode1158w[3], w_anode1147w[3]}, {w_anode1124w[3], w_anode1114w[3], w_anode1104w[3], w_anode1094w[3], w_anode1084w[3], w_anode1074w[3], w_anode1064w[3], w_anode1053w[3]}, {w_anode1030w[3], w_anode1020w[3], w_anode1010w[3], w_anode1000w[3], w_anode990w[3], w_anode980w[3], w_anode970w[3], w_anode959w[3]}, {w_anode936w[3], w_anode926w[3], w_anode916w[3], w_anode906w[3], w_anode896w[3], w_anode886w[3], w_anode876w[3], w_anode865w[3]}, {w_anode842w[3], w_anode832w[3], w_anode822w[3], w_anode812w[3], w_anode802w[3], w_anode792w[3], w_anode782w[3], w_anode771w[3]}, {w_anode748w[3], w_anode738w[3], w_anode728w[3], w_anode718w[3], w_anode708w[3], w_anode698w[3], w_anode688w[3], w_anode677w[3]}, {w_anode654w[3], w_anode644w[3], w_anode634w[3], w_anode624w[3], w_anode614w[3], w_anode604w[3], w_anode594w[3], w_anode583w[3]}, {w_anode559w[3], w_anode549w[3], w_anode539w[3], w_anode529w[3], w_anode519w[3], w_anode509w[3], w_anode499w[3], w_anode482w[3]}},
		w_anode1000w = {(w_anode1000w[2] & w_data462w[2]), (w_anode1000w[1] & (~ w_data462w[1])), (w_anode1000w[0] & (~ w_data462w[0])), w_anode947w[3]},
		w_anode1010w = {(w_anode1010w[2] & w_data462w[2]), (w_anode1010w[1] & (~ w_data462w[1])), (w_anode1010w[0] & w_data462w[0]), w_anode947w[3]},
		w_anode1020w = {(w_anode1020w[2] & w_data462w[2]), (w_anode1020w[1] & w_data462w[1]), (w_anode1020w[0] & (~ w_data462w[0])), w_anode947w[3]},
		w_anode1030w = {(w_anode1030w[2] & w_data462w[2]), (w_anode1030w[1] & w_data462w[1]), (w_anode1030w[0] & w_data462w[0]), w_anode947w[3]},
		w_anode1041w = {(w_anode1041w[2] & data_wire[5]), (w_anode1041w[1] & data_wire[4]), (w_anode1041w[0] & (~ data_wire[3])), 1'b1},
		w_anode1053w = {(w_anode1053w[2] & (~ w_data462w[2])), (w_anode1053w[1] & (~ w_data462w[1])), (w_anode1053w[0] & (~ w_data462w[0])), w_anode1041w[3]},
		w_anode1064w = {(w_anode1064w[2] & (~ w_data462w[2])), (w_anode1064w[1] & (~ w_data462w[1])), (w_anode1064w[0] & w_data462w[0]), w_anode1041w[3]},
		w_anode1074w = {(w_anode1074w[2] & (~ w_data462w[2])), (w_anode1074w[1] & w_data462w[1]), (w_anode1074w[0] & (~ w_data462w[0])), w_anode1041w[3]},
		w_anode1084w = {(w_anode1084w[2] & (~ w_data462w[2])), (w_anode1084w[1] & w_data462w[1]), (w_anode1084w[0] & w_data462w[0]), w_anode1041w[3]},
		w_anode1094w = {(w_anode1094w[2] & w_data462w[2]), (w_anode1094w[1] & (~ w_data462w[1])), (w_anode1094w[0] & (~ w_data462w[0])), w_anode1041w[3]},
		w_anode1104w = {(w_anode1104w[2] & w_data462w[2]), (w_anode1104w[1] & (~ w_data462w[1])), (w_anode1104w[0] & w_data462w[0]), w_anode1041w[3]},
		w_anode1114w = {(w_anode1114w[2] & w_data462w[2]), (w_anode1114w[1] & w_data462w[1]), (w_anode1114w[0] & (~ w_data462w[0])), w_anode1041w[3]},
		w_anode1124w = {(w_anode1124w[2] & w_data462w[2]), (w_anode1124w[1] & w_data462w[1]), (w_anode1124w[0] & w_data462w[0]), w_anode1041w[3]},
		w_anode1135w = {(w_anode1135w[2] & data_wire[5]), (w_anode1135w[1] & data_wire[4]), (w_anode1135w[0] & data_wire[3]), 1'b1},
		w_anode1147w = {(w_anode1147w[2] & (~ w_data462w[2])), (w_anode1147w[1] & (~ w_data462w[1])), (w_anode1147w[0] & (~ w_data462w[0])), w_anode1135w[3]},
		w_anode1158w = {(w_anode1158w[2] & (~ w_data462w[2])), (w_anode1158w[1] & (~ w_data462w[1])), (w_anode1158w[0] & w_data462w[0]), w_anode1135w[3]},
		w_anode1168w = {(w_anode1168w[2] & (~ w_data462w[2])), (w_anode1168w[1] & w_data462w[1]), (w_anode1168w[0] & (~ w_data462w[0])), w_anode1135w[3]},
		w_anode1178w = {(w_anode1178w[2] & (~ w_data462w[2])), (w_anode1178w[1] & w_data462w[1]), (w_anode1178w[0] & w_data462w[0]), w_anode1135w[3]},
		w_anode1188w = {(w_anode1188w[2] & w_data462w[2]), (w_anode1188w[1] & (~ w_data462w[1])), (w_anode1188w[0] & (~ w_data462w[0])), w_anode1135w[3]},
		w_anode1198w = {(w_anode1198w[2] & w_data462w[2]), (w_anode1198w[1] & (~ w_data462w[1])), (w_anode1198w[0] & w_data462w[0]), w_anode1135w[3]},
		w_anode1208w = {(w_anode1208w[2] & w_data462w[2]), (w_anode1208w[1] & w_data462w[1]), (w_anode1208w[0] & (~ w_data462w[0])), w_anode1135w[3]},
		w_anode1218w = {(w_anode1218w[2] & w_data462w[2]), (w_anode1218w[1] & w_data462w[1]), (w_anode1218w[0] & w_data462w[0]), w_anode1135w[3]},
		w_anode464w = {(w_anode464w[2] & (~ data_wire[5])), (w_anode464w[1] & (~ data_wire[4])), (w_anode464w[0] & (~ data_wire[3])), 1'b1},
		w_anode482w = {(w_anode482w[2] & (~ w_data462w[2])), (w_anode482w[1] & (~ w_data462w[1])), (w_anode482w[0] & (~ w_data462w[0])), w_anode464w[3]},
		w_anode499w = {(w_anode499w[2] & (~ w_data462w[2])), (w_anode499w[1] & (~ w_data462w[1])), (w_anode499w[0] & w_data462w[0]), w_anode464w[3]},
		w_anode509w = {(w_anode509w[2] & (~ w_data462w[2])), (w_anode509w[1] & w_data462w[1]), (w_anode509w[0] & (~ w_data462w[0])), w_anode464w[3]},
		w_anode519w = {(w_anode519w[2] & (~ w_data462w[2])), (w_anode519w[1] & w_data462w[1]), (w_anode519w[0] & w_data462w[0]), w_anode464w[3]},
		w_anode529w = {(w_anode529w[2] & w_data462w[2]), (w_anode529w[1] & (~ w_data462w[1])), (w_anode529w[0] & (~ w_data462w[0])), w_anode464w[3]},
		w_anode539w = {(w_anode539w[2] & w_data462w[2]), (w_anode539w[1] & (~ w_data462w[1])), (w_anode539w[0] & w_data462w[0]), w_anode464w[3]},
		w_anode549w = {(w_anode549w[2] & w_data462w[2]), (w_anode549w[1] & w_data462w[1]), (w_anode549w[0] & (~ w_data462w[0])), w_anode464w[3]},
		w_anode559w = {(w_anode559w[2] & w_data462w[2]), (w_anode559w[1] & w_data462w[1]), (w_anode559w[0] & w_data462w[0]), w_anode464w[3]},
		w_anode571w = {(w_anode571w[2] & (~ data_wire[5])), (w_anode571w[1] & (~ data_wire[4])), (w_anode571w[0] & data_wire[3]), 1'b1},
		w_anode583w = {(w_anode583w[2] & (~ w_data462w[2])), (w_anode583w[1] & (~ w_data462w[1])), (w_anode583w[0] & (~ w_data462w[0])), w_anode571w[3]},
		w_anode594w = {(w_anode594w[2] & (~ w_data462w[2])), (w_anode594w[1] & (~ w_data462w[1])), (w_anode594w[0] & w_data462w[0]), w_anode571w[3]},
		w_anode604w = {(w_anode604w[2] & (~ w_data462w[2])), (w_anode604w[1] & w_data462w[1]), (w_anode604w[0] & (~ w_data462w[0])), w_anode571w[3]},
		w_anode614w = {(w_anode614w[2] & (~ w_data462w[2])), (w_anode614w[1] & w_data462w[1]), (w_anode614w[0] & w_data462w[0]), w_anode571w[3]},
		w_anode624w = {(w_anode624w[2] & w_data462w[2]), (w_anode624w[1] & (~ w_data462w[1])), (w_anode624w[0] & (~ w_data462w[0])), w_anode571w[3]},
		w_anode634w = {(w_anode634w[2] & w_data462w[2]), (w_anode634w[1] & (~ w_data462w[1])), (w_anode634w[0] & w_data462w[0]), w_anode571w[3]},
		w_anode644w = {(w_anode644w[2] & w_data462w[2]), (w_anode644w[1] & w_data462w[1]), (w_anode644w[0] & (~ w_data462w[0])), w_anode571w[3]},
		w_anode654w = {(w_anode654w[2] & w_data462w[2]), (w_anode654w[1] & w_data462w[1]), (w_anode654w[0] & w_data462w[0]), w_anode571w[3]},
		w_anode665w = {(w_anode665w[2] & (~ data_wire[5])), (w_anode665w[1] & data_wire[4]), (w_anode665w[0] & (~ data_wire[3])), 1'b1},
		w_anode677w = {(w_anode677w[2] & (~ w_data462w[2])), (w_anode677w[1] & (~ w_data462w[1])), (w_anode677w[0] & (~ w_data462w[0])), w_anode665w[3]},
		w_anode688w = {(w_anode688w[2] & (~ w_data462w[2])), (w_anode688w[1] & (~ w_data462w[1])), (w_anode688w[0] & w_data462w[0]), w_anode665w[3]},
		w_anode698w = {(w_anode698w[2] & (~ w_data462w[2])), (w_anode698w[1] & w_data462w[1]), (w_anode698w[0] & (~ w_data462w[0])), w_anode665w[3]},
		w_anode708w = {(w_anode708w[2] & (~ w_data462w[2])), (w_anode708w[1] & w_data462w[1]), (w_anode708w[0] & w_data462w[0]), w_anode665w[3]},
		w_anode718w = {(w_anode718w[2] & w_data462w[2]), (w_anode718w[1] & (~ w_data462w[1])), (w_anode718w[0] & (~ w_data462w[0])), w_anode665w[3]},
		w_anode728w = {(w_anode728w[2] & w_data462w[2]), (w_anode728w[1] & (~ w_data462w[1])), (w_anode728w[0] & w_data462w[0]), w_anode665w[3]},
		w_anode738w = {(w_anode738w[2] & w_data462w[2]), (w_anode738w[1] & w_data462w[1]), (w_anode738w[0] & (~ w_data462w[0])), w_anode665w[3]},
		w_anode748w = {(w_anode748w[2] & w_data462w[2]), (w_anode748w[1] & w_data462w[1]), (w_anode748w[0] & w_data462w[0]), w_anode665w[3]},
		w_anode759w = {(w_anode759w[2] & (~ data_wire[5])), (w_anode759w[1] & data_wire[4]), (w_anode759w[0] & data_wire[3]), 1'b1},
		w_anode771w = {(w_anode771w[2] & (~ w_data462w[2])), (w_anode771w[1] & (~ w_data462w[1])), (w_anode771w[0] & (~ w_data462w[0])), w_anode759w[3]},
		w_anode782w = {(w_anode782w[2] & (~ w_data462w[2])), (w_anode782w[1] & (~ w_data462w[1])), (w_anode782w[0] & w_data462w[0]), w_anode759w[3]},
		w_anode792w = {(w_anode792w[2] & (~ w_data462w[2])), (w_anode792w[1] & w_data462w[1]), (w_anode792w[0] & (~ w_data462w[0])), w_anode759w[3]},
		w_anode802w = {(w_anode802w[2] & (~ w_data462w[2])), (w_anode802w[1] & w_data462w[1]), (w_anode802w[0] & w_data462w[0]), w_anode759w[3]},
		w_anode812w = {(w_anode812w[2] & w_data462w[2]), (w_anode812w[1] & (~ w_data462w[1])), (w_anode812w[0] & (~ w_data462w[0])), w_anode759w[3]},
		w_anode822w = {(w_anode822w[2] & w_data462w[2]), (w_anode822w[1] & (~ w_data462w[1])), (w_anode822w[0] & w_data462w[0]), w_anode759w[3]},
		w_anode832w = {(w_anode832w[2] & w_data462w[2]), (w_anode832w[1] & w_data462w[1]), (w_anode832w[0] & (~ w_data462w[0])), w_anode759w[3]},
		w_anode842w = {(w_anode842w[2] & w_data462w[2]), (w_anode842w[1] & w_data462w[1]), (w_anode842w[0] & w_data462w[0]), w_anode759w[3]},
		w_anode853w = {(w_anode853w[2] & data_wire[5]), (w_anode853w[1] & (~ data_wire[4])), (w_anode853w[0] & (~ data_wire[3])), 1'b1},
		w_anode865w = {(w_anode865w[2] & (~ w_data462w[2])), (w_anode865w[1] & (~ w_data462w[1])), (w_anode865w[0] & (~ w_data462w[0])), w_anode853w[3]},
		w_anode876w = {(w_anode876w[2] & (~ w_data462w[2])), (w_anode876w[1] & (~ w_data462w[1])), (w_anode876w[0] & w_data462w[0]), w_anode853w[3]},
		w_anode886w = {(w_anode886w[2] & (~ w_data462w[2])), (w_anode886w[1] & w_data462w[1]), (w_anode886w[0] & (~ w_data462w[0])), w_anode853w[3]},
		w_anode896w = {(w_anode896w[2] & (~ w_data462w[2])), (w_anode896w[1] & w_data462w[1]), (w_anode896w[0] & w_data462w[0]), w_anode853w[3]},
		w_anode906w = {(w_anode906w[2] & w_data462w[2]), (w_anode906w[1] & (~ w_data462w[1])), (w_anode906w[0] & (~ w_data462w[0])), w_anode853w[3]},
		w_anode916w = {(w_anode916w[2] & w_data462w[2]), (w_anode916w[1] & (~ w_data462w[1])), (w_anode916w[0] & w_data462w[0]), w_anode853w[3]},
		w_anode926w = {(w_anode926w[2] & w_data462w[2]), (w_anode926w[1] & w_data462w[1]), (w_anode926w[0] & (~ w_data462w[0])), w_anode853w[3]},
		w_anode936w = {(w_anode936w[2] & w_data462w[2]), (w_anode936w[1] & w_data462w[1]), (w_anode936w[0] & w_data462w[0]), w_anode853w[3]},
		w_anode947w = {(w_anode947w[2] & data_wire[5]), (w_anode947w[1] & (~ data_wire[4])), (w_anode947w[0] & data_wire[3]), 1'b1},
		w_anode959w = {(w_anode959w[2] & (~ w_data462w[2])), (w_anode959w[1] & (~ w_data462w[1])), (w_anode959w[0] & (~ w_data462w[0])), w_anode947w[3]},
		w_anode970w = {(w_anode970w[2] & (~ w_data462w[2])), (w_anode970w[1] & (~ w_data462w[1])), (w_anode970w[0] & w_data462w[0]), w_anode947w[3]},
		w_anode980w = {(w_anode980w[2] & (~ w_data462w[2])), (w_anode980w[1] & w_data462w[1]), (w_anode980w[0] & (~ w_data462w[0])), w_anode947w[3]},
		w_anode990w = {(w_anode990w[2] & (~ w_data462w[2])), (w_anode990w[1] & w_data462w[1]), (w_anode990w[0] & w_data462w[0]), w_anode947w[3]},
		w_data462w = data_wire[2:0];
endmodule //alt_mem_ddrx_ecc_decoder_32_decode

//synthesis_resources = lut 72 mux21 32 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  alt_mem_ddrx_ecc_decoder_32_altecc_decoder
	( 
	data,
	err_corrected,
	err_detected,
	err_fatal,
	err_sbe,
	q) /* synthesis synthesis_clearbox=1 */;
	input   [38:0]  data;
	output   err_corrected;
	output   err_detected;
	output   err_fatal;
	output   err_sbe;
	output   [31:0]  q;

	wire  [63:0]   wire_error_bit_decoder_eq;
	wire	wire_mux21_0_dataout;
	wire	wire_mux21_1_dataout;
	wire	wire_mux21_10_dataout;
	wire	wire_mux21_11_dataout;
	wire	wire_mux21_12_dataout;
	wire	wire_mux21_13_dataout;
	wire	wire_mux21_14_dataout;
	wire	wire_mux21_15_dataout;
	wire	wire_mux21_16_dataout;
	wire	wire_mux21_17_dataout;
	wire	wire_mux21_18_dataout;
	wire	wire_mux21_19_dataout;
	wire	wire_mux21_2_dataout;
	wire	wire_mux21_20_dataout;
	wire	wire_mux21_21_dataout;
	wire	wire_mux21_22_dataout;
	wire	wire_mux21_23_dataout;
	wire	wire_mux21_24_dataout;
	wire	wire_mux21_25_dataout;
	wire	wire_mux21_26_dataout;
	wire	wire_mux21_27_dataout;
	wire	wire_mux21_28_dataout;
	wire	wire_mux21_29_dataout;
	wire	wire_mux21_3_dataout;
	wire	wire_mux21_30_dataout;
	wire	wire_mux21_31_dataout;
	wire	wire_mux21_4_dataout;
	wire	wire_mux21_5_dataout;
	wire	wire_mux21_6_dataout;
	wire	wire_mux21_7_dataout;
	wire	wire_mux21_8_dataout;
	wire	wire_mux21_9_dataout;
	wire  data_bit;
	wire  [31:0]  data_t;
	wire  [38:0]  data_wire;
	wire  [63:0]  decode_output;
	wire  err_corrected_wire;
	wire  err_detected_wire;
	wire  err_fatal_wire;
	wire  [18:0]  parity_01_wire;
	wire  [9:0]  parity_02_wire;
	wire  [4:0]  parity_03_wire;
	wire  [1:0]  parity_04_wire;
	wire  [0:0]  parity_05_wire;
	wire  [5:0]  parity_06_wire;
	wire  parity_bit;
	wire  [37:0]  parity_final_wire;
	wire  [5:0]  parity_t;
	wire  [31:0]  q_wire;
	wire  syn_bit;
	wire  syn_e;
	wire  [4:0]  syn_t;
	wire  [6:0]  syndrome;

	alt_mem_ddrx_ecc_decoder_32_decode   error_bit_decoder
	( 
	.data(syndrome[5:0]),
	.eq(wire_error_bit_decoder_eq));
	assign		wire_mux21_0_dataout = (syndrome[6] == 1'b1) ? (decode_output[3] ^ data_wire[0]) : data_wire[0];
	assign		wire_mux21_1_dataout = (syndrome[6] == 1'b1) ? (decode_output[5] ^ data_wire[1]) : data_wire[1];
	assign		wire_mux21_10_dataout = (syndrome[6] == 1'b1) ? (decode_output[15] ^ data_wire[10]) : data_wire[10];
	assign		wire_mux21_11_dataout = (syndrome[6] == 1'b1) ? (decode_output[17] ^ data_wire[11]) : data_wire[11];
	assign		wire_mux21_12_dataout = (syndrome[6] == 1'b1) ? (decode_output[18] ^ data_wire[12]) : data_wire[12];
	assign		wire_mux21_13_dataout = (syndrome[6] == 1'b1) ? (decode_output[19] ^ data_wire[13]) : data_wire[13];
	assign		wire_mux21_14_dataout = (syndrome[6] == 1'b1) ? (decode_output[20] ^ data_wire[14]) : data_wire[14];
	assign		wire_mux21_15_dataout = (syndrome[6] == 1'b1) ? (decode_output[21] ^ data_wire[15]) : data_wire[15];
	assign		wire_mux21_16_dataout = (syndrome[6] == 1'b1) ? (decode_output[22] ^ data_wire[16]) : data_wire[16];
	assign		wire_mux21_17_dataout = (syndrome[6] == 1'b1) ? (decode_output[23] ^ data_wire[17]) : data_wire[17];
	assign		wire_mux21_18_dataout = (syndrome[6] == 1'b1) ? (decode_output[24] ^ data_wire[18]) : data_wire[18];
	assign		wire_mux21_19_dataout = (syndrome[6] == 1'b1) ? (decode_output[25] ^ data_wire[19]) : data_wire[19];
	assign		wire_mux21_2_dataout = (syndrome[6] == 1'b1) ? (decode_output[6] ^ data_wire[2]) : data_wire[2];
	assign		wire_mux21_20_dataout = (syndrome[6] == 1'b1) ? (decode_output[26] ^ data_wire[20]) : data_wire[20];
	assign		wire_mux21_21_dataout = (syndrome[6] == 1'b1) ? (decode_output[27] ^ data_wire[21]) : data_wire[21];
	assign		wire_mux21_22_dataout = (syndrome[6] == 1'b1) ? (decode_output[28] ^ data_wire[22]) : data_wire[22];
	assign		wire_mux21_23_dataout = (syndrome[6] == 1'b1) ? (decode_output[29] ^ data_wire[23]) : data_wire[23];
	assign		wire_mux21_24_dataout = (syndrome[6] == 1'b1) ? (decode_output[30] ^ data_wire[24]) : data_wire[24];
	assign		wire_mux21_25_dataout = (syndrome[6] == 1'b1) ? (decode_output[31] ^ data_wire[25]) : data_wire[25];
	assign		wire_mux21_26_dataout = (syndrome[6] == 1'b1) ? (decode_output[33] ^ data_wire[26]) : data_wire[26];
	assign		wire_mux21_27_dataout = (syndrome[6] == 1'b1) ? (decode_output[34] ^ data_wire[27]) : data_wire[27];
	assign		wire_mux21_28_dataout = (syndrome[6] == 1'b1) ? (decode_output[35] ^ data_wire[28]) : data_wire[28];
	assign		wire_mux21_29_dataout = (syndrome[6] == 1'b1) ? (decode_output[36] ^ data_wire[29]) : data_wire[29];
	assign		wire_mux21_3_dataout = (syndrome[6] == 1'b1) ? (decode_output[7] ^ data_wire[3]) : data_wire[3];
	assign		wire_mux21_30_dataout = (syndrome[6] == 1'b1) ? (decode_output[37] ^ data_wire[30]) : data_wire[30];
	assign		wire_mux21_31_dataout = (syndrome[6] == 1'b1) ? (decode_output[38] ^ data_wire[31]) : data_wire[31];
	assign		wire_mux21_4_dataout = (syndrome[6] == 1'b1) ? (decode_output[9] ^ data_wire[4]) : data_wire[4];
	assign		wire_mux21_5_dataout = (syndrome[6] == 1'b1) ? (decode_output[10] ^ data_wire[5]) : data_wire[5];
	assign		wire_mux21_6_dataout = (syndrome[6] == 1'b1) ? (decode_output[11] ^ data_wire[6]) : data_wire[6];
	assign		wire_mux21_7_dataout = (syndrome[6] == 1'b1) ? (decode_output[12] ^ data_wire[7]) : data_wire[7];
	assign		wire_mux21_8_dataout = (syndrome[6] == 1'b1) ? (decode_output[13] ^ data_wire[8]) : data_wire[8];
	assign		wire_mux21_9_dataout = (syndrome[6] == 1'b1) ? (decode_output[14] ^ data_wire[9]) : data_wire[9];
	assign
		data_bit = data_t[31],
		data_t = {(data_t[30] | decode_output[38]), (data_t[29] | decode_output[37]), (data_t[28] | decode_output[36]), (data_t[27] | decode_output[35]), (data_t[26] | decode_output[34]), (data_t[25] | decode_output[33]), (data_t[24] | decode_output[31]), (data_t[23] | decode_output[30]), (data_t[22] | decode_output[29]), (data_t[21] | decode_output[28]), (data_t[20] | decode_output[27]), (data_t[19] | decode_output[26]), (data_t[18] | decode_output[25]), (data_t[17] | decode_output[24]), (data_t[16] | decode_output[23]), (data_t[15] | decode_output[22]), (data_t[14] | decode_output[21]), (data_t[13] | decode_output[20]), (data_t[12] | decode_output[19]), (data_t[11] | decode_output[18]), (data_t[10] | decode_output[17]), (data_t[9] | decode_output[15]), (data_t[8] | decode_output[14]), (data_t[7] | decode_output[13]), (data_t[6] | decode_output[12]), (data_t[5] | decode_output[11]), (data_t[4] | decode_output[10]), (data_t[3] | decode_output[9]), (data_t[2] | decode_output[7]), (data_t[1] | decode_output[6]), (data_t[0] | decode_output[5]), decode_output[3]},
		data_wire = data,
		decode_output = wire_error_bit_decoder_eq,
		err_corrected = err_corrected_wire,
		err_corrected_wire = ((syn_bit & syn_e) & data_bit),
		err_detected = err_detected_wire,
		err_detected_wire = (syn_bit & (~ (syn_e & parity_bit))),
		err_fatal = err_fatal_wire,
		err_sbe = syn_e,
		err_fatal_wire = (err_detected_wire & (~ err_corrected_wire)),
		parity_01_wire = {(data_wire[30] ^ parity_01_wire[17]), (data_wire[28] ^ parity_01_wire[16]), (data_wire[26] ^ parity_01_wire[15]), (data_wire[25] ^ parity_01_wire[14]), (data_wire[23] ^ parity_01_wire[13]), (data_wire[21] ^ parity_01_wire[12]), (data_wire[19] ^ parity_01_wire[11]), (data_wire[17] ^ parity_01_wire[10]), (data_wire[15] ^ parity_01_wire[9]), (data_wire[13] ^ parity_01_wire[8]), (data_wire[11] ^ parity_01_wire[7]), (data_wire[10] ^ parity_01_wire[6]), (data_wire[8] ^ parity_01_wire[5]), (data_wire[6] ^ parity_01_wire[4]), (data_wire[4] ^ parity_01_wire[3]), (data_wire[3] ^ parity_01_wire[2]), (data_wire[1] ^ parity_01_wire[1]), (data_wire[0] ^ parity_01_wire[0]), data_wire[32]},
		parity_02_wire = {(data_wire[31] ^ parity_02_wire[8]), ((data_wire[27] ^ data_wire[28]) ^ parity_02_wire[7]), ((data_wire[24] ^ data_wire[25]) ^ parity_02_wire[6]), ((data_wire[20] ^ data_wire[21]) ^ parity_02_wire[5]), ((data_wire[16] ^ data_wire[17]) ^ parity_02_wire[4]), ((data_wire[12] ^ data_wire[13]) ^ parity_02_wire[3]), ((data_wire[9] ^ data_wire[10]) ^ parity_02_wire[2]), ((data_wire[5] ^ data_wire[6]) ^ parity_02_wire[1]), ((data_wire[2] ^ data_wire[3]) ^ parity_02_wire[0]), (data_wire[33] ^ data_wire[0])},
		parity_03_wire = {(((data_wire[29] ^ data_wire[30]) ^ data_wire[31]) ^ parity_03_wire[3]), ((((data_wire[22] ^ data_wire[23]) ^ data_wire[24]) ^ data_wire[25]) ^ parity_03_wire[2]), ((((data_wire[14] ^ data_wire[15]) ^ data_wire[16]) ^ data_wire[17]) ^ parity_03_wire[1]), ((((data_wire[7] ^ data_wire[8]) ^ data_wire[9]) ^ data_wire[10]) ^ parity_03_wire[0]), (((data_wire[34] ^ data_wire[1]) ^ data_wire[2]) ^ data_wire[3])},
		parity_04_wire = {((((((((data_wire[18] ^ data_wire[19]) ^ data_wire[20]) ^ data_wire[21]) ^ data_wire[22]) ^ data_wire[23]) ^ data_wire[24]) ^ data_wire[25]) ^ parity_04_wire[0]), (((((((data_wire[35] ^ data_wire[4]) ^ data_wire[5]) ^ data_wire[6]) ^ data_wire[7]) ^ data_wire[8]) ^ data_wire[9]) ^ data_wire[10])},
		parity_05_wire = {(((((((((((((((data_wire[36] ^ data_wire[11]) ^ data_wire[12]) ^ data_wire[13]) ^ data_wire[14]) ^ data_wire[15]) ^ data_wire[16]) ^ data_wire[17]) ^ data_wire[18]) ^ data_wire[19]) ^ data_wire[20]) ^ data_wire[21]) ^ data_wire[22]) ^ data_wire[23]) ^ data_wire[24]) ^ data_wire[25])},
		parity_06_wire = {(data_wire[31] ^ parity_06_wire[4]), (data_wire[30] ^ parity_06_wire[3]), (data_wire[29] ^ parity_06_wire[2]), (data_wire[28] ^ parity_06_wire[1]), (data_wire[27] ^ parity_06_wire[0]), (data_wire[37] ^ data_wire[26])},
		parity_bit = parity_t[5],
		parity_final_wire = {(data_wire[37] ^ parity_final_wire[36]), (data_wire[36] ^ parity_final_wire[35]), (data_wire[35] ^ parity_final_wire[34]), (data_wire[34] ^ parity_final_wire[33]), (data_wire[33] ^ parity_final_wire[32]), (data_wire[32] ^ parity_final_wire[31]), (data_wire[31] ^ parity_final_wire[30]), (data_wire[30] ^ parity_final_wire[29]), (data_wire[29] ^ parity_final_wire[28]), (data_wire[28] ^ parity_final_wire[27]), (data_wire[27] ^ parity_final_wire[26]), (data_wire[26] ^ parity_final_wire[25]), (data_wire[25] ^ parity_final_wire[24]), (data_wire[24] ^ parity_final_wire[23]), (data_wire[23] ^ parity_final_wire[22]), (data_wire[22] ^ parity_final_wire[21]), (data_wire[21] ^ parity_final_wire[20]), (data_wire[20] ^ parity_final_wire[19]), (data_wire[19] ^ parity_final_wire[18]), (data_wire[18] ^ parity_final_wire[17]), (data_wire[17] ^ parity_final_wire[16]), (data_wire[16] ^ parity_final_wire[15]), (data_wire[15] ^ parity_final_wire[14]), (data_wire[14] ^ parity_final_wire[13]), (data_wire[13] ^ parity_final_wire[12]), (data_wire[12] ^ parity_final_wire[11]), (data_wire[11] ^ parity_final_wire[10]), (data_wire[10] ^ parity_final_wire[9]), (data_wire[9] ^ parity_final_wire[8]), (data_wire[8] ^ parity_final_wire[7]), (data_wire[7] ^ parity_final_wire[6]), (data_wire[6] ^ parity_final_wire[5]), (data_wire[5] ^ parity_final_wire[4]), (data_wire[4] ^ parity_final_wire[3]), (data_wire[3] ^ parity_final_wire[2]), (data_wire[2] ^ parity_final_wire[1]), (data_wire[1] ^ parity_final_wire[0]), (data_wire[38] ^ data_wire[0])},
		parity_t = {(parity_t[4] | decode_output[32]), (parity_t[3] | decode_output[16]), (parity_t[2] | decode_output[8]), (parity_t[1] | decode_output[4]), (parity_t[0] | decode_output[2]), decode_output[1]},
		q = q_wire,
		q_wire = {wire_mux21_31_dataout, wire_mux21_30_dataout, wire_mux21_29_dataout, wire_mux21_28_dataout, wire_mux21_27_dataout, wire_mux21_26_dataout, wire_mux21_25_dataout, wire_mux21_24_dataout, wire_mux21_23_dataout, wire_mux21_22_dataout, wire_mux21_21_dataout, wire_mux21_20_dataout, wire_mux21_19_dataout, wire_mux21_18_dataout, wire_mux21_17_dataout, wire_mux21_16_dataout, wire_mux21_15_dataout, wire_mux21_14_dataout, wire_mux21_13_dataout, wire_mux21_12_dataout, wire_mux21_11_dataout, wire_mux21_10_dataout, wire_mux21_9_dataout, wire_mux21_8_dataout, wire_mux21_7_dataout, wire_mux21_6_dataout, wire_mux21_5_dataout, wire_mux21_4_dataout, wire_mux21_3_dataout, wire_mux21_2_dataout, wire_mux21_1_dataout, wire_mux21_0_dataout},
		syn_bit = syn_t[4],
		syn_e = syndrome[6],
		syn_t = {(syn_t[3] | syndrome[5]), (syn_t[2] | syndrome[4]), (syn_t[1] | syndrome[3]), (syn_t[0] | syndrome[2]), (syndrome[0] | syndrome[1])},
		syndrome = {parity_final_wire[37], parity_06_wire[5], parity_05_wire[0], parity_04_wire[1], parity_03_wire[4], parity_02_wire[9], parity_01_wire[18]};
endmodule //alt_mem_ddrx_ecc_decoder_32_altecc_decoder
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module alt_mem_ddrx_ecc_decoder_32 (
	data,
	err_corrected,
	err_detected,
	err_fatal,
    err_sbe,
	q)/* synthesis synthesis_clearbox = 1 */;

	input	[38:0]  data;
	output	  err_corrected;
	output	  err_detected;
	output	  err_fatal;
	output	  err_sbe;
	output	[31:0]  q;

	wire  sub_wire0;
	wire  sub_wire1;
	wire  sub_wire2;
	wire  sub_wire4;
	wire [31:0] sub_wire3;
	wire  err_detected = sub_wire0;
	wire  err_fatal = sub_wire1;
	wire  err_corrected = sub_wire2;
	wire  err_sbe = sub_wire4;
	wire [31:0] q = sub_wire3[31:0];

	alt_mem_ddrx_ecc_decoder_32_altecc_decoder	alt_mem_ddrx_ecc_decoder_32_altecc_decoder_component (
				.data (data),
				.err_detected (sub_wire0),
				.err_fatal (sub_wire1),
				.err_corrected (sub_wire2),
				.err_sbe (sub_wire4),
				.q (sub_wire3));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix III"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix III"
// Retrieval info: CONSTANT: lpm_pipeline NUMERIC "0"
// Retrieval info: CONSTANT: width_codeword NUMERIC "39"
// Retrieval info: CONSTANT: width_dataword NUMERIC "32"
// Retrieval info: USED_PORT: data 0 0 39 0 INPUT NODEFVAL "data[38..0]"
// Retrieval info: USED_PORT: err_corrected 0 0 0 0 OUTPUT NODEFVAL "err_corrected"
// Retrieval info: USED_PORT: err_detected 0 0 0 0 OUTPUT NODEFVAL "err_detected"
// Retrieval info: USED_PORT: err_fatal 0 0 0 0 OUTPUT NODEFVAL "err_fatal"
// Retrieval info: USED_PORT: q 0 0 32 0 OUTPUT NODEFVAL "q[31..0]"
// Retrieval info: CONNECT: @data 0 0 39 0 data 0 0 39 0
// Retrieval info: CONNECT: err_corrected 0 0 0 0 @err_corrected 0 0 0 0
// Retrieval info: CONNECT: err_detected 0 0 0 0 @err_detected 0 0 0 0
// Retrieval info: CONNECT: err_fatal 0 0 0 0 @err_fatal 0 0 0 0
// Retrieval info: CONNECT: q 0 0 32 0 @q 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_bb.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32_bb.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL alt_mem_ddrx_ecc_decoder_32_syn.v TRUE
// Retrieval info: LIB_FILE: lpm
