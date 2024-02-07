`timescale 1ns/1ps
//109550184
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;

wire r0, r1, r2;
wire src1_temp, src2_temp;
assign src1_temp = (A_invert)? ~src1:src1;
assign src2_temp = (B_invert)? ~src2:src2;
assign {cout, r2} = src1_temp + src2_temp + cin;
and g0(r0, src1_temp, src2_temp);
or g1(r1, src1_temp, src2_temp);

always@(*)
begin
    case (operation[2-1:0])
        //AND NOR
        2'd0: result = r0;
        // OR
        2'd1: result = r1;
        //ADD  SUB
        2'd2: result = r2;
        //SLT
        2'd3: result = less;
    endcase  
end

endmodule
