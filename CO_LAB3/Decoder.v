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
    funct_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	   Jump_o,
	   MemRead_o,
	   MemWrite_o,
	   MemToReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] funct_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;

output [2-1:0] Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [2-1:0] MemToReg_o;

//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;
reg    [2-1:0] Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg    [2-1:0] MemToReg_o;
//Parameter


//Main function
always@(*) begin
    case (instr_op_i)
        6'd0: begin //R-type: add -- sub -- and -- or -- slt -- jr
            ALU_op_o <= 3'd0;
            RegDst_o = 2'b01;
            if (funct_i == 6'd8) begin //6'b001000
                Jump_o = 2'b10;
                RegWrite_o = 0;
            end
            else begin
                Jump_o = 2'b01;
                RegWrite_o = 1; 
            end
            ALUSrc_o = 0;
            Branch_o = 0;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 2'b00;     
        end
        6'd4: begin //beq
            ALU_op_o <= 3'd1;
            RegDst_o = 2'bxx;
            RegWrite_o = 0; 
            ALUSrc_o = 0;
            Branch_o = 1;
            Jump_o = 2'b01; 
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 2'b00;       
        end
        6'd8: begin //addi
            ALU_op_o <= 3'd2;
            RegDst_o = 2'b00;
            RegWrite_o = 1;
            ALUSrc_o = 1;
            Branch_o = 0;
            Jump_o = 2'b01; 
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 2'b00;      
        end
        6'd10: begin //slti
            ALU_op_o <= 3'd3;
            RegDst_o = 0;
            RegWrite_o = 1;
            ALUSrc_o = 1;
            Branch_o = 0;  
            Jump_o = 2'b01;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 2'b00;      
        end
        6'd35: begin //lw 100011
            ALU_op_o <= 3'd2;
            RegDst_o = 2'b00;  
            RegWrite_o = 1;  
            ALUSrc_o = 1;
            Branch_o = 0;  
            Jump_o = 2'b01;
            MemRead_o = 1; 
            MemWrite_o = 0;
            MemToReg_o = 2'b01;       
        end
        6'd43: begin //sw 101011
            ALU_op_o <= 3'd2;
            RegDst_o = 2'bxx;   
            RegWrite_o = 0;
            ALUSrc_o = 1;
            Branch_o = 0;       
            Jump_o = 2'b01;  
            MemRead_o = 0; 
            MemWrite_o = 1;
            MemToReg_o = 2'b00;   
        end
        6'd2: begin //jump 000010
            ALU_op_o <= 3'dx;
            RegDst_o = 2'bxx;
            RegWrite_o = 0;  
            ALUSrc_o = 1'bx;
            Branch_o = 1'bx;
            Jump_o = 2'b00;
            MemRead_o = 0; 
            MemWrite_o = 0;
            MemToReg_o = 2'b00;     
        end
        6'd3: begin //jal 000011
            ALU_op_o <= 3'dx;
            RegDst_o = 2'b10;
            RegWrite_o = 1;  
            ALUSrc_o = 1'bx;
            Branch_o = 1'bx;
            Jump_o = 2'b00;
            MemRead_o = 1'bx; 
            MemWrite_o = 0;
            MemToReg_o = 2'b10;
        end
        default: begin //nop
            ALU_op_o <= 3'dx;
            RegDst_o = 2'bxx;
            RegWrite_o = 1'bx;  
            ALUSrc_o = 1'bx;
            Branch_o = 1'bx;
            Jump_o = 2'bxx;
            MemRead_o = 1'bx; 
            MemWrite_o = 1'bx;
            MemToReg_o = 2'bxx;
        end
    endcase  
end
endmodule





                    
                    