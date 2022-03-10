`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 05:42:46 PM
// Design Name: 
// Module Name: Adder
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


module Adder #(parameter WL = 32)
              (input wire [WL - 1:0] Addin1, Addin2,
               output reg [WL - 1:0] Addout,
               output reg OVF_F);
//this just adds I think
    always @* 
    begin
        Addout = Addin1 + Addin2;
        //OVF check
        if((Addin1 && Addin2 && !Addout) || //ADD OVF case 1: pos + pos = neg
           (!Addin1 && !Addin2 && Addout))  //ADD OVF case 2: neg + neg = pos
            OVF_F = 1'b1;   
        else
            OVF_F = 1'b0;
    end
    
                
endmodule
