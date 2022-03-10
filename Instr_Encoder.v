`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2022 03:20:52 PM
// Design Name: 
// Module Name: Instr_Encoder
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


module Instr_Encoder#(parameter WL = 32)
                     (input wire [WL - 1:0] in1, in2,
                      output reg [WL - 1:0] out);
    always @*
    begin
        out = {in2[WL - 1: WL - 6], in1[WL - 7:0]}; //all this module is doing is putting the last 6 bits of in2 onto in1
    end
endmodule
