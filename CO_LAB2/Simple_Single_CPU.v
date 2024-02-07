//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
//PC
wire [32-1:0] pc_out;
//Adder
wire [32-1:0] sum_adder1;
wire [32-1:0] sum_adder2;
//Instruction memory
wire [32-1:0] instr;
//Decoder
wire RegDst, RegWrite, branch, ALUSrc;
wire [3-1:0] ALUOp;
//MUX 
wire [5-1:0] mux_write_reg;
wire [32-1:0] mux_alusrc;
wire [32-1:0] mux_pc_source;
//Register File
wire signed [32-1:0] read_data_1;
wire signed [32-1:0] read_data_2;
//sign extend
wire signed [32-1:0] constant;
//shift left 2
wire signed [32-1:0] pc_shift_left_2;
//ALU control
wire [4-1:0] ALUCtrl;
//ALU
wire [32-1:0] ALU_result;
wire ALU_zero;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc_source) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out),     
	    .sum_o(sum_adder1)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]), //rt
        .data1_i(instr[15:11]), //rd
        .select_i(RegDst),
        .data_o(mux_write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(mux_write_reg) ,  
        .RDdata_i(ALU_result)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data_1) ,  
        .RTdata_o(read_data_2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(constant)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data_2),
        .data1_i(constant),
        .select_i(ALUSrc),
        .data_o(mux_alusrc)
        );	
		
ALU ALU(
        .src1_i(read_data_1),
	    .src2_i(mux_alusrc),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALU_result),
		.zero_o(ALU_zero)
	    );


Adder Adder2(
        .src1_i(sum_adder1),     
	    .src2_i(pc_shift_left_2),     
	    .sum_o(sum_adder2)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(constant),
        .data_o(pc_shift_left_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_adder1),
        .data1_i(sum_adder2),
        .select_i(ALU_zero & branch),
        .data_o(mux_pc_source)
        );	

endmodule
		  


