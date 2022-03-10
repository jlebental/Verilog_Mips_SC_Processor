`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 08:21:24 PM
// Design Name: 
// Module Name: Opcode_Decoder
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


module Opcode_Decoder(input wire [5:0] Opcode,
                      output reg Jump, MtoRFSel, DMWE, Branch, RFWE, ALUInSel, RFDSel,    
                      output reg [1:0] ALUOp);

//Control Signal Descriptions
// Jump     --- hi: indicates a jump instruction, PC gets JTA
//          --- lo: indicates not a jump instr, PC gets either PCBranch or PCp1 depending on Branch control signal

// MtoRFSel --- hi: sends DM read data to RF at its write port
//          --- lo: sends ALUOut to RF at its write port

// DMWE     --- hi: enables changes in arch state of DM. @posedge CLK DM updates @DMWA location using DMWD value
//          --- lo: maintains arch state of DM. DM only reads.

//Branch    ---hi: enables a different change in PC arch state than reading next instr; sets the tone for a jump instr? idrk
//          -- lo: means next PC arch state will be PCp1

// RFWE     --- hi: changes arch state of RF by updating a register w the value at RF's write port
//          --- lo: prevents writing to RF at posedge clk

//ALUInSel  --- hi: sets ALUIn2 to Simm (indicates I type instr)
//          --- lo: sets ALUIn2 to RFRD2

//RFDSel    --- hi: rd is selected as register for next RF write
//          --- lo: rt is selected as register for next RF write
//          NOTE: either rd or rf is 5 bits, and holds the addr of the appropriate reg in RF to be written to

//ALUOp     --- 2'b00: indicates Addition must be performed in the ALU. Indicates an I type instruction
//          --- 2'b01: indicates Subtraction must be performed in the ALU. Indicates an I type instruction
//          --- 2'b11: indicates an R type instruction. We must look at funct to set ALUSel.

    always @(Opcode)
    begin
        case(Opcode)
            6'b100011: //lw case; opcode for lw is 35(dec), 100011(bin)
            begin
                Jump        = 1'b0;     //lw does not cause a jump
                MtoRFSel    = 1'b1;     //if we're loading a word from DM, we need DMRD to go to RF
                DMWE        = 1'b0;     //lw does not write to DM
                Branch      = 1'b0;     //lw makes PC increase by 4 bytes, like normal
                RFWE        = 1'b1;     //if we're loading from memory, then we're writing to a reg. WE goes hi
                ALUInSel    = 1'b1;     //lw is I type. we need Simm for ALUIn2
                RFDSel      = 1'b0;     //we need to write to rt for lw instr
                ALUOp       = 2'b00;    //ALU needs to add for lw. Add is ALUOp = 00
                                        //offset(Imm->Simm) + base addr (from reg selected in RF) = effective addr
                                        //makes even more sense since lw is an I type function.
                                        //I type has no funct field in it. gotta control ALUOp from here
            end
            
            6'b101011:  //sw case opcode for sw is 43(dec), 101011(bin)
            begin
                Jump        = 1'b0;     //SW does not cause a jump
                MtoRFSel    = 1'bZ;     //SW does not care what gets passed to RFWD because RFwon't be written
                DMWE        = 1'b1;     //SW does write to the DM
                Branch      = 1'b0;     //SW does not cause a branch in the PC
                RFWE        = 1'b0;     //SW does not cause a write to the RF
                ALUInSel    = 1'b1;     //SW needs Simm passed into ALU to calculate offset
                RFDSel      = 1'b0;     //rt is our destination reg
                ALUOp       = 2'b00;    //00 will tell the ALU decoder we need an add operation in the ALU
            end
            
            6'b000000:  //R type instructions case is 0(dec), 000000(bin)
            begin
                Jump        = 1'b0;     //R types do not cause jumps
                MtoRFSel    = 1'b0;     //ALUOut needs to get written
                DMWE        = 1'b0;     //R types don't write to memory
                Branch      = 1'b0;     //Rtypes dont create a branch
                RFWE        = 1'b1;     //Rtypes absolutely write to RF
                ALUInSel    = 1'b0;     //aluin2 should be a second input from the RF. sometimes shamt is the play though but thats not ruined by this
                RFDSel      = 1'b1;     //rd is always the destination reg in rtype instr's
                ALUOp       = 2'b11;    //aluop gets 11 to make alu decoder look at funct
            end
            
            6'b001000:  //AddI instructions case is 8(dec), 001000(bin)
            begin
                Jump        = 1'b0;     //AddI does not cause a jump
                MtoRFSel    = 1'b0;     //We want ALUout written to RF
                DMWE        = 1'b0;     //Theres no write to DM in thi case
                Branch      = 1'b0;     //AddI does not cause a branch for the PC
                RFWE        = 1'b1;     //We are writing to the RF
                ALUInSel    = 1'b1;     //our ALUIN2 is Simm
                RFDSel      = 1'b0;     //rt is our destination register
                ALUOp       = 2'b00;    //We need an add operation for ADDI, so 00
            end
            
            6'b000100:  //BEQ instruction case is 4(dec), 000100(bin)
            begin
                Jump        = 1'b0;     //BEQ does not cause a jump
                MtoRFSel    = 1'bZ;     //BEQ does not care what is sent to RFWD
                DMWE        = 1'b0;     //BEQ does not write to DM
                Branch      = 1'b1;     //BEQ causes a branch
                RFWE        = 1'b0;     //BEQ does not write to RF
                ALUInSel    = 1'b0;     //BEQ discovers equality by subtracting one reg from the other in the ALU; so ALUIN2 is RFRD2
                RFDSel      = 1'bZ;     //BEQ does not write to RF so who cares     
                ALUOp       = 2'b01;    //We're going to tell our ALU to do subtraction. BEQ is an I type instr.
            end
            
            6'b000010:  //J instruction case is 2(dec), 000010(bin)
            begin
                Jump        = 1'b1;     //J causes a Jump
                MtoRFSel    = 1'bZ;     //J does not care whats sent to RFWD    
                DMWE        = 1'b0;     //J does not write to DM
                Branch      = 1'b0;     //J does not cause a branch
                RFWE        = 1'b0;     //J does not write to RF
                ALUInSel    = 1'bZ;     //J does not care what ALUIn2 is
                RFDSel      = 1'bZ;     //J does not care what RFRD is
                ALUOp       = 2'bZZ;    //J does not care what the ALU does.
            end
            
            default:    //this is for garbage opcodes
            begin
                Jump        = 1'bZ;
                MtoRFSel    = 1'bZ;     
                DMWE        = 1'bZ;     
                Branch      = 1'bZ;     
                RFWE        = 1'bZ;     
                ALUInSel    = 1'bZ;     
                RFDSel      = 1'bZ;     
                ALUOp       = 2'bZZ;    
            end
        endcase
    end

endmodule
