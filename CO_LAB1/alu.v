`timescale 1ns/1ps
//109550184
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg   [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
//-------------------------------------------//
wire    [2-1:0] operation;
wire            A_invert, B_invert;
wire            less;
wire   [32-1:0] res;
wire   [32-1:0] carry;
wire            first;

always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) 
	begin        
	end
	else 
	begin
        result = res;
        zero = (result == 0)? 1: 0;
        cout = (operation == 2)? carry[31] : 0; 
        overflow = ((src1[31]&(src2[31]^B_invert))^result[31])&(B_invert^A_invert)&~(src1[31]^src2[31]);        
	end	
end

assign A_invert = ALU_control[3];
assign B_invert = ALU_control[2];
assign operation = ALU_control[1:0];
assign first = (ALU_control == 4'b0110)? 1: (ALU_control == 4'b0111)? 1: 0;

genvar i;
generate	  
	   for (i = 0; i < 32; i = i+1)
	   begin
	       alu_top alu(
	           .src1(src1[i]),
	           .src2(src2[i]),
	           .less((i==0)? less: 1'b0),
	           .A_invert(A_invert),
	           .B_invert(B_invert),
	           .cin((i==0)? first : carry[i-1]),
	           .operation(operation),
	           .result(res[i]),
	           .cout(carry[i])
	       );
	   end
endgenerate 

assign less = (src1[31]^(~src2[31])^carry[30]);
endmodule
