`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2021 16:23:35
// Design Name: 
// Module Name: tb
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


module mul_test;

  reg [31:0]a,b;
  wire [63:0]out;
    integer i;
  ka uut(a,b,out);
  //oka uut(a,b,out);
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,mul_test);
  end
    initial 
    begin
      for(i=0;i<=500;i=i+1)
        begin
        #1 a=i;
          #1 b=i;
          
        end     
        
    end
endmodule
