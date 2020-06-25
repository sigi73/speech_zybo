`timescale 1ns / 1ps
//-----------------------------------------------------------------
// (c) Copyright 1984 - 2018 Xilinx, Inc. All rights reserved.	
//							
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.							
//-----------------------------------------------------------------							 
// DISCLAIMER							
// This disclaimer is not a license and does not grant any	 
// rights to the materials distributed herewith. Except as	 
// otherwise provided in a valid license issued to you by	
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-	 
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and	 
// (2) Xilinx shall not be liable (whether in contract or tort,	
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature 
// related to, arising under or in connection with these	 
// materials, including for any direct, or any indirect,	
// special, incidental, or consequential loss or damage		 
// (including loss of data, profits, goodwill, or any type of	
// loss or damage suffered as a result of any action brought	
// by a third party) even if such damage or loss was		 
// reasonably foreseeable or Xilinx had been advised of the	 
// possibility of the same.					 
//								 
// CRITICAL APPLICATIONS					 
// Xilinx products are not designed or intended to be fail-	 
// safe, or for use in any application requiring fail-safe	 
// performance, such as life-support or safety devices or	 
// systems, Class III medical devices, nuclear facilities,	 
// applications related to the deployment of airbags, or any	 
// other applications that could lead to death, personal	 
// injury, or severe property or environmental damage		 
// (individually and collectively, "Critical			 
// Applications"). Customer assumes the sole risk and		 
// liability of any use of Xilinx products in Critical		 
// Applications, subject only to applicable laws and		 
// regulations governing limitations on product liability.	 
//								 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS	 
// PART OF THIS FILE AT ALL TIMES. 				 
//-----------------------------------------------------------------
// ************************************************************************
//
//-----------------------------------------------------------------------------
// Filename:        AXI_GPIO_tb.sv
// Version:         v1.0
// Description:     Simulation test bench for the AXI Basics Series 3
//                  
//-----------------------------------------------------------------------------
//Step 2 - Import two required packages: axi_vip_pkg and <component_name>_pkg.
import axi_vip_pkg::*;
//import AXI_GPIO_Sim_axi_vip_0_0_pkg::*;
import speech_bd_axi_vip_0_0_pkg::*;

//////////////////////////////////////////////////////////////////////////////////
// Test Bench Signals
//////////////////////////////////////////////////////////////////////////////////
// Clock and Reset
bit aclk = 0, areset = 0;
//Simulation output
//bit led_1, switch_1;
//AXI4-Lite signals
xil_axi_resp_t 	resp;
//bit[31:0]  addr, data, base_addr = 32'h4400_0000, switch_state;
bit[31:0]  addr, data, base_addr = 32'h43c0_0000, switch_state;

module AXI_GPIO_tb( );


speech_bd_wrapper UUT
(
//    .DDR_addr (),
//    .DDR_ba (),
//    .DDR_cas_n (),
//    .DDR_ck_n (),
//    .DDR_ck_p (),
//    .DDR_cke (),
//    .DDR_cs_n (),
//    .DDR_dm (),
//    .DDR_dq (),
//    .DDR_dqs_n (),
//    .DDR_dqs_p (),
//    .DDR_odt (),
//    .DDR_ras_n (),
//    .DDR_reset_n (),
//    .DDR_we_n (),
//    .FIXED_IO_ddr_vrn (),
//    .FIXED_IO_ddr_vrp (),
//    .FIXED_IO_mio (),
//    .FIXED_IO_ps_clk (),
//    .FIXED_IO_ps_porb (),
//    .FIXED_IO_ps_srstb (),
    .reset_btn (areset),
    .sys_clock (aclk)
);

// Generate the clock : 50 MHz    
//always #10ns aclk = ~aclk;

// Generate the clock : 125 MHz    
always #4ns aclk = ~aclk;

//////////////////////////////////////////////////////////////////////////////////
// Main Process
//////////////////////////////////////////////////////////////////////////////////
//
initial begin
    //Assert the reset
    areset = 1;
    #50ns
    // Release the reset
    areset = 0;
end
//
//////////////////////////////////////////////////////////////////////////////////
// The following part controls the AXI VIP. 
//It follows the "Usefull Coding Guidelines and Examples" section from PG267
//////////////////////////////////////////////////////////////////////////////////
//
// Step 3 - Declare the agent for the master VIP
//AXI_GPIO_Sim_axi_vip_0_0_mst_t      master_agent;
speech_bd_axi_vip_0_0_mst_t master_agent;
//
initial begin    

    // Step 4 - Create a new agent
    //master_agent = new("master vip agent",UUT.AXI_GPIO_Sim_i.axi_vip_0.inst.IF);
    master_agent = new("master vip agent", UUT.speech_bd_i.axi_vip_0.inst.IF);
    
    // Step 5 - Start the agent
    master_agent.start_master();
    
    //Wait for the reset to be released
    wait (areset == 1'b1);
    
    //Send 0x1 to the AXI GPIO Data register 1
    //#2000ns
    //#12000ns
    #5000ns
    addr = 0;
    data = 1;
    master_agent.AXI4LITE_WRITE_BURST(base_addr + addr,0,data,resp);
    
    #200ns
    addr = 4;
    master_agent.AXI4LITE_READ_BURST(base_addr + addr,0,data,resp);

    
    #800ns
    master_agent.AXI4LITE_READ_BURST(base_addr + addr,0,data,resp);
    //Send 0x0 to the AXI GPIO Data register 1
    //#200ns
    //addr = 0;
    //data = 0;
    //master_agent.AXI4LITE_WRITE_BURST(base_addr + addr,0,data,resp);

	// Switch in OFF position
    //switch_1 = 0;
    // Read the AXI GPIO Data register 2
    //#200ns
    //addr = 8;
    //master_agent.AXI4LITE_READ_BURST(base_addr + addr,0,data,resp);
    //switch_state = data&1'h1;
    /*
    if(switch_state == 0)
        $display("switch 1 OFF");
    else
        $display("switch 1 ON");
    */
     
    // Switch in ON position
    //switch_1 = 1;
    // Read the AXI GPIO Data register 2
    //#200ns
    //addr = 8;
    //master_agent.AXI4LITE_READ_BURST(base_addr + addr,0,data,resp);
    //switch_state = data&1'h1;
    /*
    if(switch_state == 0)
        $display("switch 1 OFF");
    else
        $display("switch 1 ON");
    */
    //#10000ns
    //$finish;
		
end
//
//////////////////////////////////////////////////////////////////////////////////
// Simulation output processes
//////////////////////////////////////////////////////////////////////////////////
//

/*
always @(posedge led_1)
begin
     $display("led 1 ON");
end

always @(negedge led_1)
begin
     $display("led 1 OFF");
end
*/
endmodule
