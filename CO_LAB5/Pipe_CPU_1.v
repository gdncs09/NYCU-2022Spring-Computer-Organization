//109550184
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire [155-1:0] IDEX_i;
wire [155-1:0] IDEX_o;
wire [109-1:0] EXMem_i;
wire [109-1:0] EXMem_o;
wire [71-1:0] MemWB_i;
wire [71-1:0] MemWB_o;

/**** IF stage ****/
wire [32-1:0] PC_out;
wire [32-1:0] PC_add4;
wire [32-1:0] PC_in;
wire PCSrc;
wire [32-1:0] IM_out;
/**** ID stage ****/
wire [32-1:0] instr;
wire [32-1:0] SE;
wire [32-1:0] RTdata_o;
wire [32-1:0] RSdata_o;
wire [32-1:0] ID_PC_out;
wire [32-1:0] ID_PC_add4;
wire [12-1:0] Decoder_o;
wire [12-1:0] MUX_Decoder_o;
wire [32-1:0] PC_add_im;
//control signal
assign IDEX_i[5-1:0] = instr[15:11]; //Rd
assign IDEX_i[10-1:5] = instr[20:16]; //Rt
assign IDEX_i[15-1:10] = instr[25:21]; //Rs
assign IDEX_i[47-1:15] = SE;
assign IDEX_i[79-1:47] = RTdata_o;
assign IDEX_i[111-1:79] = RSdata_o;
assign IDEX_i[143-1:111] = ID_PC_add4;
assign IDEX_i[155-1:143] = MUX_Decoder_o[12-1:0];
/**** EX stage ****/ 
wire [5-1:0] EX_RDaddr;
wire [5-1:0] EX_RTaddr;
wire [5-1:0] EX_RSaddr;
wire [32-1:0] EX_SE;
wire [32-1:0] EX_RTdata;
wire [32-1:0] EX_RSdata;
wire [12-1:0] EX_Decoder;
wire EX_ALUSrc, EX_RegDst, EX_Branch,EX_MemRead;
wire [3-1:0] EX_ALUOp;
wire [2-1:0] EX_BranchType;

wire [5-1:0] write_reg;
wire [32-1:0] MUX_A;
wire [32-1:0] MUX_B;
wire [32-1:0] MUX_ALUSrc_o;
wire [4-1:0] ALUCtrl;
wire [32-1:0] ALU_result;
wire ALU_zero, Zero;
//control signal
assign EX_RDaddr = IDEX_o[5-1:0];
assign EX_RTaddr = IDEX_o[10-1:5];
assign EX_RSaddr = IDEX_o[15-1:10];
assign EX_SE = IDEX_o[47-1:15];
assign EX_RTdata = IDEX_o[79-1:47];
assign EX_RSdata = IDEX_o[111-1:79];
assign EX_PC_add4 = IDEX_o[143-1:111];
assign EX_Decoder = IDEX_o[155-1:143];
assign EX_ALUSrc = EX_Decoder[11];
assign EX_ALUOp = EX_Decoder[10:8];
assign EX_RegDst = EX_Decoder[7];
//assign EX_BranchType = EX_Decoder[6:5];
//assign EX_Branch = EX_Decoder[4];
assign EX_MemRead = EX_Decoder[2]; //Hazard   
 
assign EXMem_i[5-1:0] = write_reg;
assign EXMem_i[37-1:5] = MUX_B;
assign EXMem_i[69-1:37] = ALU_result;
assign EXMem_i[69] = ALU_zero;
assign EXMem_i[102-1:70] = PC_add_im;
assign EXMem_i[109-1:102] = EX_Decoder[6:0];
/**** MEM stage ****/
wire [5-1:0] Mem_RDaddr;
wire [5-1:0] Mem_RTdata;
wire [32-1:0] Mem_ALU_result;
wire Mem_ALU_zero;
wire [7-1:0] Mem_Decoder;
wire [2-1:0] Mem_BranchType;
wire Mem_Branch, Mem_MemWrite, Mem_MemRead, Mem_RegWrite;
wire [32-1:0] DM_o;
//control signal
assign Mem_RDaddr = EXMem_o[5-1:0];
assign Mem_RTdata = EXMem_o[37-1:5];
assign Mem_ALU_result = EXMem_o[69-1:37];
assign Mem_ALU_zero = EXMem_o[69];
assign Mem_PC_add_im = EXMem_o[102-1:70];
assign Mem_Decoder = EXMem_o[109-1:102];
assign Mem_BranchType = Mem_Decoder[6:5];
assign Mem_Branch = Mem_Decoder[4];
assign Mem_MemWrite = Mem_Decoder[3];
assign Mem_MemRead = Mem_Decoder[2];
assign Mem_RegWrite = Mem_Decoder[0]; //Forward

assign MemWB_i[5-1:0] = Mem_RDaddr;
assign MemWB_i[37-1:5] = Mem_ALU_result;
assign MemWB_i[69-1:37] = DM_o;
assign MemWB_i[70:69] = Mem_Decoder[1:0];
/**** WB stage ****/
wire [5-1:0] WB_RDaddr;
wire [32-1:0] WB_DM;
wire [32-1:0] WB_ALU_result;
wire [2-1:0] WB_Decoder;
wire WB_MemToReg, WB_RegWrite;
wire [32-1:0] MUX_RDdata;
//control signal
assign WB_RDaddr = MemWB_o[5-1:0];
assign WB_ALU_result = MemWB_o[37-1:5];
assign WB_DM = MemWB_o[69-1:37];

assign WB_Decoder = MemWB_o[70:69];
assign WB_MemToReg = WB_Decoder[1];
assign WB_RegWrite = WB_Decoder[0];

wire PCWrite, IFID_Write, ID_Flush;
wire [2-1:0] ForwardA;
wire [2-1:0] ForwardB;
assign PCSrc = Mem_Branch && Zero;
/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
    .data0_i(PC_add4),
    .data1_i(Mem_PC_add_im),
    .select_i(PCSrc),
    .data_o(PC_in)    
);

ProgramCounter PC(
    .clk_i(clk_i),      
	.rst_i (rst_i),
	.PCWrite(PCWrite),     
	.pc_in_i(PC_in) ,   
	.pc_out_o(PC_out) 
);

Instruction_Memory IM(
    .addr_i(PC_out),  
	.instr_o(IM_out)   
);
			
Adder Add_pc(
    .src1_i(PC_out),     
	.src2_i(32'd4),     
	.sum_o(PC_add4)    
);
	
IFID_Reg IF_ID(       
    .clk_i(clk_i),
    .rst_i(rst_i),
    .IF_Flush(PCSrc),
    .IFID_Write(IFID_Write),
    .addr_i(PC_out),
    .PC_add4_i(PC_add4),
    .instr_i(IM_out), 
    .addr_o(ID_PC_out), 
    .PC_add4_o(ID_PC_add4), //32
    .instr_o(instr) //32
);

//Instantiate the components in ID stage
HD_Unit HDU( //Hazard
    .IFID_RS(instr[25:21]),
    .IFID_RT(instr[20:16]),
    .IDEX_RT(EX_RTaddr),
    .IDEX_MemRead(EX_MemRead),
    .PCWrite(PCWrite),
    .IFID_Write(IFID_Write),
    .ID_Flush(ID_Flush)
);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
Reg_File RF(
    .clk_i(clk_i),      
	.rst_i(rst_i),     
    .RSaddr_i(instr[25:21]) ,  
    .RTaddr_i(instr[20:16]) ,  
    .RDaddr_i(WB_RDaddr) ,  
    .RDdata_i(MUX_RDdata)  , 
    .RegWrite_i (WB_RegWrite),
    .RSdata_o(RSdata_o) ,  
    .RTdata_o(RTdata_o)   
);

Decoder Control(
    .instr_op_i(instr[31:26]), 
	.RegWrite_o(Decoder_o[0]), //WB 1 RegWrite
	.ALU_op_o(Decoder_o[10:8]),      //EX 3 ALUOp
	.ALUSrc_o(Decoder_o[11]),     //EX 1 ALUSrc
	.RegDst_o(Decoder_o[7]),     //EX 1 RegDst
	.Branch_o(Decoder_o[4]),     //M 1 Branch
	.BranchType_o(Decoder_o[6:5]), //M 2 BranchType
    .MemRead_o(Decoder_o[2]),   //M 1 MemRead
    .MemWrite_o(Decoder_o[3]), //M 1 MemWrite
    .MemToReg_o(Decoder_o[1])  //WB 1 MemToReg
);

MUX_2to1 #(.size(12)) MUX_Control(
    .data0_i(Decoder_o),
    .data1_i(12'b0),
    .select_i(ID_Flush),
    .data_o(MUX_Decoder_o)
);

Sign_Extend Sign_Extend(
    .data_i(instr[15:0]),
    .data_o(SE)
);	

Pipe_Reg #(.size(155)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(IDEX_i),
    .data_o(IDEX_o)
);

//Instantiate the components in EX stage	   
FW_Unit FWU( //Forward
    .IDEX_RS(EX_RSaddr),
    .IDEX_RT(EX_RTaddr),
    .EXMem_RD(Mem_RDaddr),
    .MemWB_RD(WB_RDaddr),
    .EXMem_RegWrite(Mem_RegWrite),
    .MemWB_RegWrite(WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

MUX_3to1 #(.size(32)) MuxA(
    .data0_i(EX_RSdata),
    .data1_i(MUX_RDdata),
    .data2_i(Mem_ALU_result),
    .select_i(ForwardA),
    .data_o(MUX_A) 
);

MUX_3to1 #(.size(32)) MuxB(
    .data0_i(EX_RTdata),
    .data1_i(MUX_RDdata),
    .data2_i(Mem_ALU_result),
    .select_i(ForwardB),
    .data_o(MUX_B) 
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(MUX_B),
    .data1_i(EX_SE),
    .select_i(EX_ALUSrc),
    .data_o(MUX_ALUSrc_o) 
);

ALU ALU(
    .src1_i(MUX_A),
	.src2_i(MUX_ALUSrc_o),
	.ctrl_i(ALUCtrl),
	.result_o(ALU_result),
	.zero_o(ALU_zero)
);
ALU_Ctrl ALU_Control(
    .funct_i(EX_SE[5:0]),   
    .ALUOp_i(EX_ALUOp),   
    .ALUCtrl_o(ALUCtrl) 
);

Shift_Left_Two_32 Shifter(
    .data_i(EX_SE),
    .data_o(SE_shift)
);

Adder Add_pc_branch(
    .src1_i(EX_PC_add4),     
	.src2_i(SE_shift),     
	.sum_o(PC_add_im)    
);
	
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(EX_RTaddr),
    .data1_i(EX_RDaddr),
    .select_i(EX_RegDst),
    .data_o(write_reg) 
);

Pipe_Reg #(.size(109)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(EXMem_i),
    .data_o(EXMem_o)
);

MUX_4to1 #(.size(1)) MuxBranch(
    .data0_i(Mem_ALU_zero),
    .data1_i(~(Mem_ALU_result[31]||Mem_ALU_zero)),
    .data2_i(~Mem_ALU_result[31]),
    .data3_i(~Mem_ALU_zero),
    .select_i(Mem_BranchType),
    .data_o(Zero) 
);
//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
	.addr_i(Mem_ALU_result),
	.data_i(Mem_RTdata),
	.MemRead_i(Mem_MemRead),
	.MemWrite_i(Mem_MemWrite),
	.data_o(DM_o)
);

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(MemWB_i),
    .data_o(MemWB_o)
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(WB_ALU_result),
    .data1_i(WB_DM),
    .select_i(WB_MemToReg),
    .data_o(MUX_RDdata) 
);

/****************************************
signal assignment
****************************************/

endmodule

