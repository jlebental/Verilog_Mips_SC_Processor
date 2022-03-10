`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 04:41:40 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(input wire [5:0] opcode, funct,
                    output wire Jump, MtoRFSel, DMWE, Branch, RFWE, ALUInSel, RFDSel,  
                    output wire [3:0] ALUSel);
//effectively this will
//1 - Decode opcode, 2 pass to alludecoder, 3 etermine aluop from alu decoder, 4 output all signals.

    //outputs as wire
    wire [1:0] ALUOp;

    //module calls
    Opcode_Decoder Opcode_Decode_call(opcode, Jump, MtoRFSel, DMWE, Branch, RFWE, ALUInSel, RFDSel, ALUOp);
    ALU_Decoder ALU_Decode_call(ALUOp, funct, ALUSel);
endmodule
