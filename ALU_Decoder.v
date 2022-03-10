`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 08:39:34 PM
// Design Name: 
// Module Name: ALU_Decoder
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


module ALU_Decoder(input wire [1:0] ALUOp,
                   input wire [5:0] funct,
                   output reg [3:0] ALUSel);    //ALUSEL is 4 bits because ALU has a case statement that needs a 4 bit value

    //ALU Table of contents
    //ALUSel    Operation
    // 0000     Add
    // 0001     Sub
    // 0010     LSL     (Logical Left Shift)
    // 0011     LSR     (Logical Right Shift)
    // 0100     LSVL    (Logical Variable Left Shift)
    // 0101     LSVR    (Logical Variable Right Shift)
    // 0110     AVSR    (Arithmetic Variable Right shift)
    // 0111     bitwise AND     (&)
    // 1000     bitwise OR      (|)
    // 1001     bitwise XOR     (^)
    // 1010     bitwise XNOR    (~^)

    //sUse ALUOp to set ALUSel
    always @*
    begin
        case(ALUOp)
            2'b00: ALUSel = 4'b0000;    //Add case for ALU is 4'b0000. Instr is I type
            2'b01: ALUSel = 4'b0001;    //Sub case for ALU is 4'b0001. Instr is I type
            2'b11:                      //R type instruction. We must look at funct to set ALUSel
            begin
                case(funct)
                    6'b000111: ALUSel = 4'b0110;    //SRAV Shift right arithmetic variable
                    6'b000100: ALUSel = 4'b0100;    //SLLV Shift Logical Left variable
                    6'b000000: ALUSel = 4'b0010;    //Shift logical left
                    6'b100010: ALUSel = 4'b0001;    //subtraction
                    6'b100000: ALUSel = 4'b0000;    //add
                    default: ALUSel = 4'bZZZZ;
                endcase
            end
            default: ALUSel = 4'bZZZZ;
        endcase
    end
endmodule
