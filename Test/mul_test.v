`timescale 1ns / 1ps

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
