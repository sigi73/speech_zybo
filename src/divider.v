`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 02:15:08 PM
// Design Name: 
// Module Name: divider
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


module divider(
    input clk_in,
    input reset,
    output clk_out
    );
    
    BUFR #(
        .BUFR_DIVIDE("2"),
        .SIM_DEVICE("7SERIES")
    ) BUFR_inst (
        .O(clk_out),
        .CE(1),
        .CLR(reset),
        .I(clk_in)
    );
    
    /*
    reg state = 1'b0;
    reg drop = 0'b0;
    
    always @(posedge clk_in, posedge reset)
    begin
        if (reset)
        begin
            state <= 1'b0;
            clk_out <= 1'b0;
            drop <= 0'b0;
        end
        else
        begin
            state <= !state;
            if (state)
            begin
                clk_out <= ~clk_out;
            end
            else
            begin
                clk_out = clk_out;
            end
        end
    end
    
    always @(negedge clk_in)
    begin
    end
    */
    
endmodule
