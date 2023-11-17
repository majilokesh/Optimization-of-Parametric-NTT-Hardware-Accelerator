//Author: Lokesh Maji
//Date: 03.07.2023
//Organisation: IIIT Bangalore

module ka #(
parameter wI = 32,
parameter wO = 2 * wI
)
(
input [wI-1:0]    iX,
input [wI-1:0]    iY,
output [wO-1:0]    oO
);

localparam wI_pt = wI / 2;

wire   [wI_pt-1:0] X_hi, X_lo;
wire   [wI_pt-1:0] Y_hi, Y_lo;

assign  {X_hi, X_lo} = iX;
assign  {Y_hi, Y_lo} = iY;

wire [31 : 0] ac,bc,ad,bd;
wire [63 : 0] t1,t2;
wire [48 : 0] psum;

ka_16x16 i1(.a(X_hi),.b(Y_hi),.out(ac));
ka_16x16 i2(.a(X_lo),.b(Y_hi),.out(bc));
ka_16x16 i3(.a(X_hi),.b(Y_lo),.out(ad));
ka_16x16 i4(.a(X_lo),.b(Y_lo),.out(bd));

assign t2 = bd;
assign psum = (bc+ad) << 16;
assign t1 = {ac,32'b0};

assign oO = t1 + psum + t2;


endmodule

module ka_16x16(
    input [15:0] a,
    input [15:0] b,
    output [31:0] out
    );
    
    wire [15:0] ac,bc,ad,bd;
    wire [31:0] t1,t2;
    wire [24:0] psum;
    
  ka_8x8 i1(.a(a[15:8]),.b(b[15:8]),.out(ac));
  ka_8x8 i2(.a(a[7:0]),.b(b[15:8]),.out(bc));
  ka_8x8 i3(.a(a[15:8]),.b(b[7:0]),.out(ad));
  ka_8x8 i4(.a(a[7:0]),.b(b[7:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 8;
  assign t1={ac,16'b0000000000000000};
  assign out= t1+t2+psum;
endmodule

module ka_8x8(
    input [7:0] a,
    input [7:0] b,
    output [15:0] out
    );
    
    wire [7:0] ac,bc,ad,bd;
    wire [15:0] t1,t2;
    wire [12:0] psum;
    
  ka_4x4 m1(.a(a[7:4]),.b(b[7:4]),.out(ac));
  ka_4x4 m2(.a(a[3:0]),.b(b[7:4]),.out(bc));
  ka_4x4 m3(.a(a[7:4]),.b(b[3:0]),.out(ad));
  ka_4x4 m4(.a(a[3:0]),.b(b[3:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 4;
  assign t1={ac,8'b0000};
  assign out= t1+t2+psum;
endmodule

module ka_4x4(
    input [3:0] a,
    input [3:0] b,
    output [7:0] out
    );
    wire [3:0] ac,bc,ad,bd;
    wire [7:0] t1,t2;
    wire [6:0] psum;
    
  ka_2x2 m1(.a(a[3:2]),.b(b[3:2]),.out(ac));
  ka_2x2 m2(.a(a[1:0]),.b(b[3:2]),.out(bc));
  ka_2x2 m3(.a(a[3:2]),.b(b[1:0]),.out(ad));
  ka_2x2 m4(.a(a[1:0]),.b(b[1:0]),.out(bd));
  assign t2= bd;
  assign psum = (bc+ad) << 2;
  assign t1={ac,4'b0000};
  assign out= t1+t2+psum;
  
endmodule

module ka_2x2(
    input [1:0] a,
    input [1:0] b,
    output [3:0] out
    );
    wire temp;
    assign out[0]= a[0]&b[0];
    assign out[1]= (a[1]&b[0])^(a[0]&b[1]);
    assign temp =  (a[1]&b[0])&(a[0]&b[1]);
    assign out[2]= temp ^(a[1]&b[1]);
    assign out[3]= temp &(a[1]&b[1]);
endmodule
