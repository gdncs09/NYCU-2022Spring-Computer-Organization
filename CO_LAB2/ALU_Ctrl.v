//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
      
//Select exact operation
always@(*) begin
    case (ALUOp_i)
        3'd0: case (funct_i) //R_type
            6'd32: ALUCtrl_o <= 4'd2; //add
            6'd34: ALUCtrl_o <= 4'd6; //sub
            6'd36: ALUCtrl_o <= 4'd0; //and
            6'd37: ALUCtrl_o <= 4'd1; //or
            6'd42: ALUCtrl_o <= 4'd7; //slt
        endcase
        3'd1: ALUCtrl_o <= 4'd6; //beq
        3'd2: ALUCtrl_o = 4'd2; //addi
        3'd3: ALUCtrl_o <= 4'd7; //slti
    endcase
end
endmodule    
  





                    
                    