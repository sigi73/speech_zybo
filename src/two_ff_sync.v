`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2020 05:15:47 PM
// Design Name: 
// Module Name: 2ff_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module two_ff_sync #(parameter WIDTH = 1) (
    input clk,
    input [WIDTH-1:0] data_in,
    (* ASYNC_REG = "TRUE" *) output reg [WIDTH-1:0] data_out
    );
    
    (* ASYNC_REG = "TRUE" *) reg [WIDTH-1:0] metastable;
    
    always @(posedge clk)
    begin
        metastable <= data_in;
        data_out <= metastable;
    end
endmodule
