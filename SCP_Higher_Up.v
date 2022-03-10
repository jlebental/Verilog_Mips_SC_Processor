`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 04:39:54 PM
// Design Name: 
// Module Name: SCP_Higher_Up
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


module SCP_Higher_Up #(parameter WL = 32, AL = 5, 
                       PROGRAM = "Program_A_Obj_Code.mem", 
                       DMINIT = "COMPE475_Ass0_DM_values.mem")
                      (input wire CLK, RST);
    //Program Counter Signals
    wire [WL - 1:0] PC_in, PC_out, PC_intermediate, JTA;   //PC_intermediate is for the signal between jump and branch MUX
    wire PCSel;
    //Instruction memory signals
    wire [WL - 1:0] IMRD;               
    //instr decomposition
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] Imm;
    wire [25:0] jumpt;              //you know... I haven't used this one yet. As of LW instr at least
    //Control Unit Signals
    wire Jump, MtoRFSel, DMWE, Branch, RFWE, ALUInSel, RFDSel;    //FIXME: add Jump control signal
    wire [3:0] ALUSel;
    //Sign Extension Unit Signal
    wire [WL - 1:0] Simm;
    //Register File signals
    wire [AL - 1:0] RFWA;
    wire [WL - 1:0] RFWD, RFRD1, RFRD2;
    //ALU signals
    wire [WL - 1:0] ALUIn2, ALUOut;
    wire zero, OVF_F_ALU;
    //Data Memory signals
    wire [WL - 1:0] DMRD;
    //Adder Signals
    wire OVF_F_ADDER_PCp1, OVF_F_ADDER_PCBranch;
    wire [WL - 1:0] PCp1, PCBranch;
 
 
    
    //module calls 
    
    //PC state transition and Instruction fetch/deconstruction
    Prog_Counter_Register #(.WL(WL)) PC_call(CLK, RST, 1, PC_in, PC_out);   //NOTE: we write 1 into the port of EN. EN is for another assignment.
    IM_SCP #(.WL(WL), .PROGRAM(PROGRAM)) IM_call(PC_out, IMRD);    
    Instr_Decoder #(.WL(WL)) ID_call(IMRD, opcode, funct, rs, rt, rd, shamt, Imm, jumpt);   
    
    //we've decoded the instr, now we send the pieces to wherever they go
    //lets do Control Unit
    Control_Unit CU_call(opcode, funct, Jump, MtoRFSel, DMWE, Branch, RFWE, ALUInSel, RFDSel, ALUSel);
    Sign_Extension_Unit #(.WL(WL)) SE_call(Imm, Simm);
    
    MUX2 #(.WL(AL)) MUX_for_RFWA_call(RFDSel, rt, rd, RFWA);
    MUX2 #(.WL(WL)) MUX_for_RFWD_call(MtoRFSel, ALUOut, DMRD, RFWD);
    RF_SCP #(.WL(WL), .AL(AL)) RF_call(CLK, RFWE, rs, rt, RFWA, RFWD, RFRD1, RFRD2);
    
    MUX2 #(.WL(WL)) MUX_for_ALUIN2_call(ALUInSel, RFRD2, Simm, ALUIn2);
    ALU_SCP #(.WL(WL)) ALU_call(ALUSel, shamt, RFRD1, ALUIn2, zero, OVF_F_ALU, ALUOut);
    
    DM_SCP #(.WL(WL), .AL(AL), .DMINIT(DMINIT)) DM_call(CLK, DMWE, ALUOut, RFRD2, DMRD);
    
    //PC next state logic
    Adder #(.WL(WL)) Adder_PCp1_call(PC_out, 1, PCp1, OVF_ADDER_PCp1);                      //creates PCp1 signal
    Adder #(.WL(WL)) Adder_PCBranch_call(Simm, PCp1, PCBranch, OVF_F_ADDER_PCBranch);       //creates PCBranch signal
    AND_Gate AND_Gate_call(Branch, zero, PCSel);                                            //creates PCSel control signal
    Instr_Encoder #(.WL(WL)) JTA_encoder_call(jumpt, PCp1, JTA);                            //creates JTA
    MUX2 #(.WL(WL)) MUX_for_PC_intermediate_call(PCSel, PCp1, PCBranch, PC_intermediate);   //Branch or PCp1 MUX for PC_intermediate
    MUX2 #(.WL(WL)) MUX_for_PC_in_call(Jump, PC_intermediate, JTA, PC_in);                  //JTA or PC_intermediate for PC_in
    
endmodule
