//109550184
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	BranchType_o,
	MemRead_o,
	MemWrite_o,
	MemToReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output [2-1:0] BranchType_o;
output         MemRead_o;
output         MemWrite_o;
output         MemToReg_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg    [2-1:0] BranchType_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemToReg_o;
//Parameter

//Main function
always@(*) begin
    case (instr_op_i)
        6'd0: begin //R-type: add -- sub -- and -- or -- slt -- mult
            ALU_op_o <= 3'd0;
            RegDst_o = 1;
            RegWrite_o = 1; 
            ALUSrc_o = 0;
            Branch_o = 0;
            BranchType_o = 2'dx;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 0;     
        end
        6'd1: begin //bge 000 001
            ALU_op_o <= 3'd1;
            RegDst_o = 1'bx;
            RegWrite_o = 0; 
            ALUSrc_o = 0;
            Branch_o = 1;
            BranchType_o = 2'd2;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 0;  
        end 
        6'd4: begin //beq
            ALU_op_o <= 3'd1;
            RegDst_o = 1'bx;
            RegWrite_o = 0; 
            ALUSrc_o = 0;
            Branch_o = 1;
            BranchType_o = 2'd0;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 0;        
        end
        6'd5: begin //bne
            ALU_op_o <= 3'd1;
            RegDst_o = 1'bx;
            RegWrite_o = 0; 
            ALUSrc_o = 0;
            Branch_o = 1;
            BranchType_o = 2'd3;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 1'b0;  
        end
        6'd7: begin //bgt
            ALU_op_o <= 3'd1;
            RegDst_o = 1'bx;
            RegWrite_o = 0; 
            ALUSrc_o = 0;
            Branch_o = 1;
            BranchType_o = 2'd1;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 1'b0;  
        end
        6'd8: begin //addi
            ALU_op_o <= 3'd2;
            RegDst_o = 0;
            RegWrite_o = 1;
            ALUSrc_o = 1;
            Branch_o = 0;
            BranchType_o = 2'dx;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 0;      
        end
        6'd10: begin //slti
            ALU_op_o <= 3'd3;
            RegDst_o = 0;
            RegWrite_o = 1;
            ALUSrc_o = 1;
            Branch_o = 0;  
            BranchType_o = 2'dx;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 0;       
        end
        6'd35: begin //lw 100 011
            ALU_op_o <= 3'd2;
            RegDst_o = 0;  
            RegWrite_o = 1;  
            ALUSrc_o = 1;
            Branch_o = 0; 
            BranchType_o = 2'dx; 
            MemRead_o = 1; 
            MemWrite_o = 0;
            MemToReg_o = 1;       
        end
        6'd43: begin //sw 101 011
            ALU_op_o <= 3'd2;
            RegDst_o = 0;   
            RegWrite_o = 0;
            ALUSrc_o = 1;
            Branch_o = 0;  
            BranchType_o = 2'dx;     
            MemRead_o = 0; 
            MemWrite_o = 1;
            MemToReg_o = 0;   
        end
        default: begin //nop
            ALU_op_o <= 3'dx;
            RegDst_o = 1'bx;
            RegWrite_o = 1'bx;  
            ALUSrc_o = 1'bx;
            Branch_o = 1'bx;
            BranchType_o = 2'dx;
            MemRead_o = 1'bx; 
            MemWrite_o = 1'bx;
            MemToReg_o = 1'bx;
        end
    endcase  
end
endmodule





                    
                    