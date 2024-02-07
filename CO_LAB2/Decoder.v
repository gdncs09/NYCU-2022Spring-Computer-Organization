//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function

always@(*) begin
    case (instr_op_i)
        6'd0: begin //R-type: add -- sub -- and -- or -- slt
            RegDst_o = 1;
            ALU_op_o <= 3'd0;
            ALUSrc_o = 0;
            Branch_o = 0;
            RegWrite_o = 1;        
        end
        6'd4: begin //beq
            RegDst_o = 0;
            ALU_op_o <= 3'd1;
            ALUSrc_o = 0;
            Branch_o = 1;
            RegWrite_o = 0;         
        end
        6'd8: begin //addi
            RegDst_o = 0;
            ALU_op_o <= 3'd2;
            ALUSrc_o = 1;
            Branch_o = 0;
            RegWrite_o = 1;        
        end
        6'd10: begin //slti
            RegDst_o = 0;
            ALU_op_o <= 3'd3;
            ALUSrc_o = 1;
            Branch_o = 0;
            RegWrite_o = 1;        
        end
        
    endcase  
end
endmodule            
                    