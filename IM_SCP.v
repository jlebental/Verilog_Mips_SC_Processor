`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 06:21:59 PM
// Design Name: 
// Module Name: IM_SCP
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


module IM_SCP #(parameter WL = 32, PROGRAM = "Program_A_Obj_Code.mem")
                  (input wire [5:0] IMA,
                   output reg signed [WL-1:0] IMRD);
    //create memory locations
    reg [WL-1:0] IM_Locations [2**6 - 1:0];  //I'm making 64 locations (2^6)
    
    //read from the mem file
    initial
    begin
        $readmemb(PROGRAM, IM_Locations);    //FIXME: I need to make it so I can pass a file from a testbench
    end
    
    always @*
    begin
        IMRD <= IM_Locations[IMA];
    end
endmodule
