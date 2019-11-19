`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2019 11:01:48 AM
// Design Name: 
// Module Name: shift_mux
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


module shift_mux(
        input wire sel,
        input wire [31:0] a,
        input wire [4:0] b,
        output wire [31:0] y
    );
    wire [31:0] c;
    assign c = {27'b0000_0000_0000_0000_0000_0000_000,b};
    assign y = (sel) ? c : a;
endmodule
