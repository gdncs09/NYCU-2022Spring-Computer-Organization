//109550184
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
wire RegWrite, Branch, ALUSrc, MemRead, MemWrite;
wire [2-1:0] RegDst;
wire [2-1:0] Jump;
wire [2-1:0] MemToReg;
wire [3-1:0] ALUOp;
//MUX 
wire [5-1:0] mux_write_reg;
wire [32-1:0] mux_alusrc;
wire [32-1:0] mux_pc_source;
wire [32-1:0] mux_pc;
wire [32-1:0] mux_dm;
//Register File
wire [32-1:0] read_data_1;
wire [32-1:0] read_data_2;
//sign extend
wire signed [32-1:0] se;
//shift left 2
wire signed [32-1:0] se_shift_left_2;
//ALU control
wire [4-1:0] ALUCtrl;
//ALU
wire [32-1:0] ALU_result;
wire ALU_zero;
//DM
wire [32-1:0] read_data;
//JUMP
wire [28-1:0] jump_shift_left_2;
wire [32-1:0] jump_address;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(mux_pc) ,   
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

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(mux_write_reg)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(mux_write_reg) ,  
        .RDdata_i(mux_dm)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data_1) ,  
        .RTdata_o(read_data_2)   
        );
        
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
        .funct_i(instr[5:0]),
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch),   
            .Jump_o(Jump),
            .MemRead_o(MemRead),
            .MemWrite_o(MemWrite),
            .MemToReg_o(MemToReg)
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(se)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data_2),
        .data1_i(se),
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
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALU_result),
	.data_i(read_data_2),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(read_data)
	);

MUX_3to1 #(.size(32)) Mux_DM(
        .data0_i(ALU_result),
        .data1_i(read_data),
        .data2_i(sum_adder1),
        .select_i(MemToReg),
        .data_o(mux_dm)
        );	
        	
Adder Adder2(
        .src1_i(sum_adder1),     
	    .src2_i(se_shift_left_2),     
	    .sum_o(sum_adder2)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(se),
        .data_o(se_shift_left_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_adder1),
        .data1_i(sum_adder2),
        .select_i(ALU_zero & Branch),
        .data_o(mux_pc_source)
        );	
        
Shift_Left_Two_32 Shifter_Jump(
        .data_i(instr[25:0]),
        .data_o(jump_shift_left_2)
        ); 	
assign jump_address = {sum_adder1[31:28], jump_shift_left_2[27:0]}; 	          

MUX_3to1 #(.size(32)) Mux_PC(
        .data0_i(jump_address),
        .data1_i(mux_pc_source),
        .data2_i(read_data_1),
        .select_i(Jump),
        .data_o(mux_pc)
        );	
        
endmodule
		  


