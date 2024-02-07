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
wire [32-1:0] PC_out;
wire [32-1:0] PC_add4;
wire [32-1:0] PC_in;
wire PCSrc;
wire [32-1:0] IM_out;
wire [64-1:0] IFID_i;
wire [64-1:0] IFID_o;

wire [32-1:0] instr;
wire [32-1:0] ID_PC_add4;
wire [32-1:0] RSdata_o;
wire [32-1:0] RTdata_o;
wire RegWrite, MemToReg, Branch, MemRead, MemWrite, RegDst, ALUSrc;
wire [3-1:0] ALUOp;
wire [32-1:0] SE;
wire [148-1:0] IDEX_i;
wire [148-1:0] IDEX_o;

wire EX_RegDst, EX_ALUSrc;
wire [3-1:0] EX_ALUOp;
wire [32-1:0] EX_PC_add4;
wire [32-1:0] SE_shift;
wire [32-1:0] PC_add_im;
wire [32-1:0] EX_RSdata;
wire [32-1:0] EX_RTdata; 
wire [32-1:0] EX_SE;
wire [32-1:0] MUX_ALUSrc_o;  
wire [5-1:0] EX_RTaddr;
wire [5-1:0] EX_RDaddr;
wire [5-1:0] write_reg;
wire [4-1:0] ALUCtrl; 
wire ALU_zero;
wire [32-1:0] ALU_result;
wire [107-1:0] EXMem_i;
wire [107-1:0] EXMem_o;

wire Mem_MemWrite, Mem_MemRead, Mem_Branch, Mem_ALU_zero;
wire [5-1:0] Mem_write_reg;
wire [32-1:0] Mem_PC_add_im;
wire [32-1:0] Mem_RTdata;
wire [32-1:0] Mem_ALU_result;
wire [32-1:0] DM_o;
wire [71-1:0] MemWB_i;
wire [71-1:0] MemWB_o;

wire WB_MemToReg, WB_RegWrite;
wire [5-1:0] WB_write_reg;
wire [32-1:0] WB_ALU_result;
wire [32-1:0] WB_DM;
wire [32-1:0] RDdata_i;

/**** IF stage ****/
assign IFID_i[32-1:0] = IM_out;
assign IFID_i[64-1:32] = PC_add4;

/**** ID stage ****/

//control signal
assign instr = IFID_o[31:0];
assign ID_PC_add4 = IFID_o[64-1:32];

assign IDEX_i[5-1:0] = instr[15:11];
assign IDEX_i[10-1:5] = instr[20:16];
assign IDEX_i[42-1:10] = SE;
assign IDEX_i[74-1:42] = RTdata_o;
assign IDEX_i[106-1:74] = RSdata_o;
assign IDEX_i[138-1:106] = ID_PC_add4;
assign IDEX_i[138] = ALUSrc;  //EX
assign IDEX_i[142-1:139] = ALUOp; //EX
assign IDEX_i[142] = RegDst; //EX
assign IDEX_i[143] = MemWrite; //M
assign IDEX_i[144] = MemRead; //M
assign IDEX_i[145] = Branch; //M
assign IDEX_i[146] = MemToReg; //WB
assign IDEX_i[147] =  RegWrite; //WB

/**** EX stage ****/ 

//control signal
assign EX_RDaddr = IDEX_o[5-1:0];
assign EX_RTaddr = IDEX_o[10-1:5];
assign EX_SE = IDEX_o[42-1:10];
assign EX_RTdata = IDEX_o[74-1:42];
assign EX_RSdata = IDEX_o[106-1:74];
assign EX_PC_add4 = IDEX_o[138-1:106];
assign EX_ALUSrc = IDEX_o[138];
assign EX_ALUOp = IDEX_o[142-1:139];
assign EX_RegDst = IDEX_o[142];

assign EXMem_i[5-1:0] = write_reg;
assign EXMem_i[37-1:5] = EX_RTdata;
assign EXMem_i[69-1:37] = ALU_result;
assign EXMem_i[69] = ALU_zero;
assign EXMem_i[102-1:70] = PC_add_im;
assign EXMem_i[106:102] = IDEX_o[147:143];

/**** MEM stage ****/

//control signal
assign Mem_write_reg = EXMem_o[5-1:0];
assign Mem_RTdata = EXMem_o[37-1:5];
assign Mem_ALU_result = EXMem_o[69-1:37];
assign Mem_ALU_zero = EXMem_o[69];
assign Mem_PC_add_im = EXMem_o[102-1:70];
assign Mem_MemWrite = EXMem_o[102];
assign Mem_MemRead = EXMem_o[103];
assign Mem_Branch = EXMem_o[104];

assign MemWB_i[5-1:0] = Mem_write_reg;
assign MemWB_i[37-1:5] = Mem_ALU_result;
assign MemWB_i[69-1:37] = DM_o;
assign MemWB_i[70:69] = EXMem_o[106:105];

assign PCSrc = Mem_Branch & Mem_ALU_zero;
/**** WB stage ****/

//control signal
assign WB_write_reg = MemWB_o[5-1:0];
assign WB_ALU_result = MemWB_o[37-1:5];
assign WB_DM = MemWB_o[69-1:37];
assign WB_MemToReg = MemWB_o[69];
assign WB_RegWrite = MemWB_o[70];

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
	
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(IFID_i), 
    .data_o(IFID_o)
);

//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
	.rst_i(rst_i),     
    .RSaddr_i(instr[25:21]) ,  
    .RTaddr_i(instr[20:16]) ,  
    .RDaddr_i(WB_write_reg) ,  
    .RDdata_i(RDdata_i)  , 
    .RegWrite_i (WB_RegWrite),
    .RSdata_o(RSdata_o) ,  
    .RTdata_o(RTdata_o)   
);

Decoder Control(
    .instr_op_i(instr[31:26]), 
	.RegWrite_o(RegWrite), //WB 1
	.ALU_op_o(ALUOp),      //EX 3
	.ALUSrc_o(ALUSrc),     //EX 1
	.RegDst_o(RegDst),     //EX 1
	.Branch_o(Branch),     //M 1
    .MemRead_o(MemRead),   //M 1
    .MemWrite_o(MemWrite), //M 1
    .MemToReg_o(MemToReg)  //WB 1
);

Sign_Extend Sign_Extend(
    .data_i(instr[15:0]),
    .data_o(SE)
);	

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(IDEX_i),
    .data_o(IDEX_o)
);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(EX_SE),
    .data_o(SE_shift)
);

ALU ALU(
    .src1_i(EX_RSdata),
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

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(EX_RTdata),
    .data1_i(EX_SE),
    .select_i(EX_ALUSrc),
    .data_o(MUX_ALUSrc_o) 
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(EX_RTaddr),
    .data1_i(EX_RDaddr),
    .select_i(EX_RegDst),
    .data_o(write_reg) 
);

Adder Add_pc_branch(
    .src1_i(EX_PC_add4),     
	.src2_i(SE_shift),     
	.sum_o(PC_add_im)    
);

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i(EXMem_i),
    .data_o(EXMem_o)
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
    .data_o(RDdata_i) 
);

/****************************************
signal assignment
****************************************/

endmodule

