//altpll bandwidth_type="AUTO" CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" clk0_divide_by=1 clk0_duty_cycle=50 clk0_multiply_by=1 clk0_phase_shift="0" clk1_divide_by=5 clk1_duty_cycle=50 clk1_multiply_by=1 clk1_phase_shift="0" clk2_divide_by=1 clk2_duty_cycle=50 clk2_multiply_by=1 clk2_phase_shift="2500" clk3_divide_by=1 clk3_duty_cycle=50 clk3_multiply_by=1 clk3_phase_shift="2500" clk4_divide_by=5 clk4_duty_cycle=50 clk4_multiply_by=1 clk4_phase_shift="15000" clk5_divide_by=5 clk5_duty_cycle=50 clk5_multiply_by=4 clk5_phase_shift="3" compensate_clock="CLK0" device_family="Arria II GX" inclk0_input_frequency=8000 intended_device_family="Arria II GX" lpm_hint="CBX_MODULE_PREFIX=pll_0" operation_mode="normal" pll_type="LEFT_RIGHT" port_clk0="PORT_USED" port_clk1="PORT_USED" port_clk2="PORT_USED" port_clk3="PORT_USED" port_clk4="PORT_USED" port_clk5="PORT_USED" port_clk6="PORT_UNUSED" port_clk7="PORT_UNUSED" port_clk8="PORT_UNUSED" port_clk9="PORT_UNUSED" port_inclk1="PORT_UNUSED" port_phasecounterselect="PORT_UNUSED" port_phasedone="PORT_UNUSED" port_scandata="PORT_UNUSED" port_scandataout="PORT_UNUSED" self_reset_on_loss_lock="OFF" using_fbmimicbidir_port="OFF" width_clock=7 clk inclk locked CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48
//VERSION_BEGIN 16.0 cbx_altclkbuf 2016:07:21:01:48:15:SJ cbx_altiobuf_bidir 2016:07:21:01:48:16:SJ cbx_altiobuf_in 2016:07:21:01:48:16:SJ cbx_altiobuf_out 2016:07:21:01:48:16:SJ cbx_altpll 2016:07:21:01:48:16:SJ cbx_cycloneii 2016:07:21:01:48:16:SJ cbx_lpm_add_sub 2016:07:21:01:48:16:SJ cbx_lpm_compare 2016:07:21:01:48:16:SJ cbx_lpm_counter 2016:07:21:01:48:16:SJ cbx_lpm_decode 2016:07:21:01:48:16:SJ cbx_lpm_mux 2016:07:21:01:48:16:SJ cbx_mgl 2016:07:21:01:49:21:SJ cbx_nadder 2016:07:21:01:48:16:SJ cbx_stratix 2016:07:21:01:48:16:SJ cbx_stratixii 2016:07:21:01:48:16:SJ cbx_stratixiii 2016:07:21:01:48:16:SJ cbx_stratixv 2016:07:21:01:48:16:SJ cbx_util_mgl 2016:07:21:01:48:16:SJ  VERSION_END
//CBXI_INSTANCE_NAME="netFPGAmini_pll_clk_pll_clk_pll_0_pll_0_altpll_altpll_component"
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus Prime License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = arriaii_pll 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  pll_0_altpll
	( 
	clk,
	inclk,
	locked) /* synthesis synthesis_clearbox=1 */;
	output   [6:0]  clk;
	input   [1:0]  inclk;
	output   locked;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [1:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  [6:0]   wire_pll1_clk;
	wire  wire_pll1_fbout;
	wire  wire_pll1_locked;

	arriaii_pll   pll1
	( 
	.activeclock(),
	.clk(wire_pll1_clk),
	.clkbad(),
	.fbin(wire_pll1_fbout),
	.fbout(wire_pll1_fbout),
	.inclk(inclk),
	.locked(wire_pll1_locked),
	.phasedone(),
	.scandataout(),
	.scandone(),
	.vcooverrange(),
	.vcounderrange()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.areset(1'b0),
	.clkswitch(1'b0),
	.configupdate(1'b0),
	.pfdena(1'b1),
	.phasecounterselect({4{1'b0}}),
	.phasestep(1'b0),
	.phaseupdown(1'b0),
	.scanclk(1'b0),
	.scanclkena(1'b1),
	.scandata(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		pll1.bandwidth_type = "auto",
		pll1.clk0_divide_by = 1,
		pll1.clk0_duty_cycle = 50,
		pll1.clk0_multiply_by = 1,
		pll1.clk0_phase_shift = "0",
		pll1.clk1_divide_by = 5,
		pll1.clk1_duty_cycle = 50,
		pll1.clk1_multiply_by = 1,
		pll1.clk1_phase_shift = "0",
		pll1.clk2_divide_by = 1,
		pll1.clk2_duty_cycle = 50,
		pll1.clk2_multiply_by = 1,
		pll1.clk2_phase_shift = "2500",
		pll1.clk3_divide_by = 1,
		pll1.clk3_duty_cycle = 50,
		pll1.clk3_multiply_by = 1,
		pll1.clk3_phase_shift = "2500",
		pll1.clk4_divide_by = 5,
		pll1.clk4_duty_cycle = 50,
		pll1.clk4_multiply_by = 1,
		pll1.clk4_phase_shift = "15000",
		pll1.clk5_divide_by = 5,
		pll1.clk5_duty_cycle = 50,
		pll1.clk5_multiply_by = 4,
		pll1.clk5_phase_shift = "3",
		pll1.compensate_clock = "clk0",
		pll1.inclk0_input_frequency = 8000,
		pll1.operation_mode = "normal",
		pll1.self_reset_on_loss_lock = "off",
		pll1.lpm_type = "arriaii_pll";
	assign
		clk = {wire_pll1_clk[6:0]},
		locked = wire_pll1_locked;
endmodule //pll_0_altpll
//VALID FILE
