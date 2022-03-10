`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 04:52:06 PM
// Design Name: 
// Module Name: Prog_Counter_Register
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


 module Prog_Counter_Register #(parameter WL = 32)
                            (input wire CLK, RST, EN,
                             input wire [WL - 1:0] PC_in,
                             output reg [WL - 1:0] PC_out);

//now what exactly is this meant to do?
//idk, just build something
    always @(posedge CLK or posedge RST)
    begin
        if(RST) PC_out <= 0;
        else
        begin
            if(EN) PC_out <= PC_in;
        end
    end

endmodule
