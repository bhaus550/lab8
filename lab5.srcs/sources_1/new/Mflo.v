`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2019 10:57:30 AM
// Design Name: 
// Module Name: Mflo
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


module Mflo(input clk, rst, wlo, [31:0] a, output reg [31:0] mlo);
    always @ (posedge clk, posedge rst)
    if(wlo)
        begin
            if(rst) mlo <= 0;
            else mlo <= a;
        end
endmodule