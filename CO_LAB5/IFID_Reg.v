//109550184
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2022 08:37:16 PM
// Design Name: 
// Module Name: IFID_Reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IFID_Reg(
    clk_i,
    rst_i,
    IF_Flush,
    IFID_Write,
    addr_i,
    PC_add4_i,
    instr_i,
    
    addr_o,
    PC_add4_o,
    instr_o
    );

input clk_i;
input rst_i;
input IF_Flush;
input IFID_Write;
input [31:0] addr_i;
input [31:0] PC_add4_i;
input [31:0] instr_i;

output reg [31:0] addr_o;
output reg [31:0] PC_add4_o;
output reg [31:0] instr_o;

always@(posedge clk_i) begin
    if (~rst_i || IF_Flush) begin
        addr_o <= 32'd0;
        PC_add4_o <= 32'd0;
        instr_o <=32'd0; 
    end
    else if (IFID_Write) begin
        addr_o <= addr_i;
        PC_add4_o <= PC_add4_i;
        instr_o <= instr_i;
    end
end
endmodule
