//109550184
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2022 08:37:16 PM
// Design Name: 
// Module Name: FW_Unit
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


module FW_Unit(
    IDEX_RS,
    IDEX_RT,
    EXMem_RD,
    MemWB_RD,
    EXMem_RegWrite,
    MemWB_RegWrite,
    ForwardA,
    ForwardB
    );
input [5-1:0] IDEX_RS;
input [5-1:0] IDEX_RT;
input [5-1:0] EXMem_RD;
input [5-1:0] MemWB_RD;
input EXMem_RegWrite;
input MemWB_RegWrite;
output reg [2-1:0] ForwardA;
output reg [2-1:0] ForwardB;

always@(*) begin
    if (EXMem_RegWrite && ((EXMem_RD!=5'd0) && (EXMem_RD==IDEX_RS))) begin
        ForwardA = 2'b10;
    end
    else if (MemWB_RegWrite && (MemWB_RD!=5'd0) && (MemWB_RD==IDEX_RS) && !(EXMem_RegWrite && ((EXMem_RD!=5'd0) && (EXMem_RD==IDEX_RS)))) begin
        ForwardA = 2'b01;
    end
    else begin
        ForwardA = 2'b00;
    end
    
    if (EXMem_RegWrite && ((EXMem_RD!=5'd0) && (EXMem_RD==IDEX_RT))) begin
        ForwardB = 2'b10;
    end
    else if (MemWB_RegWrite && ((MemWB_RD!=5'd0) && (MemWB_RD==IDEX_RT) && !(EXMem_RegWrite && ((EXMem_RD!=5'd0) && (EXMem_RD==IDEX_RT))))) begin
        ForwardB = 2'b01;
    end
    else begin
        ForwardB = 2'b00;
    end
    
end
endmodule
