`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 06:26:29 PM
// Design Name: 
// Module Name: DM_SCP
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


module DM_SCP #(parameter WL = 32, AL = 6, DMINIT = "COMPE475_Ass0_DM_values.mem")
                (input wire CLK, DMWE,
                 input wire [(2**AL) - 1:0] DMA,
                 input wire signed [WL-1:0] DMWD,
                 output reg signed [WL-1:0] DMRD);
    //memory locations
    reg [WL-1:0] DM_Locations [2**9-1:0];
    
    //initialize Data Memory
    initial
    begin
        $readmemb(DMINIT, DM_Locations);
    end
    
    //write functionality bound by clk (synchronous)
    always @(posedge CLK)
    begin
        if(DMWE)
            DM_Locations[DMA] <= DMWD;
    end
    //read functionality not bound by clk (asynchronous)
    always @*
    begin
        DMRD = DM_Locations[DMA]; 
    end
endmodule
