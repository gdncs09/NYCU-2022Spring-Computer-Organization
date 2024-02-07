//109550184
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2022 08:37:16 PM
// Design Name: 
// Module Name: HD_Unit
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


module HD_Unit(
    IFID_RS,
    IFID_RT,
    IDEX_RT,
    IDEX_MemRead,
    PCWrite,
    IFID_Write,
    ID_Flush
    );
    
input [5-1:0] IFID_RS;
input [5-1:0] IFID_RT;
input [5-1:0] IDEX_RT;
input IDEX_MemRead;
output reg PCWrite;
output reg IFID_Write;
output reg ID_Flush;

always@(*) begin
    if (IDEX_MemRead && ((IDEX_RT==IFID_RS) || (IDEX_RT==IFID_RT))) begin
        PCWrite = 0;
        IFID_Write = 0;
        ID_Flush = 1;        
    end
    else begin
        PCWrite = 1;
        IFID_Write = 1;
        ID_Flush = 0;
    end   
end
endmodule
