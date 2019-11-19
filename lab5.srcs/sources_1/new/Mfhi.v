`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2019 11:00:15 AM
// Design Name: 
// Module Name: Mfhi
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

module Mfhi(input clk, rst, whi, [31:0] b, output reg[31:0] mhi);
    always @(posedge clk, posedge rst)
    if(whi)
    begin
        if(rst) mhi <= 0;
        else mhi <= b;
    end
endmodule
