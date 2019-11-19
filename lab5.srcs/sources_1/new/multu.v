`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2019 10:55:21 AM
// Design Name: 
// Module Name: multu
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

module Multu(input [31:0] a, b, output [31:0] lo, hi);
    wire [63:0] mult;
    assign mult = a * b;
    assign lo = mult [31:0];
    assign hi = mult [63:32];
endmodule