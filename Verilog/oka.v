module oka #(
parameter wI = 32,
parameter wO = 2 * wI
)
(
input   [wI-1:0]    iX,
input   [wI-1:0]    iY,
output  [wO-1:0]    oO
);

localparam wI_pt = wI / 2;

reg   [wI_pt-1:0] X_even, X_odd;
reg   [wI_pt-1:0] Y_even, Y_odd;
wire  [wI-1:0] X_o, X_e, Y_o, Y_e;
reg   [wI-1:0] Xreg_e, Xreg_o, Yreg_e, Yreg_o;

integer i;
integer j;
always @* begin
	for(i = 0; i < wI_pt; i = i+1) begin
		X_even[i] <= iX[2*i];
		X_odd[i] <= iX[2*i + 1];
		Y_even[i] <= iY[2*i];
		Y_odd[i] <= iY[2*i + 1];	
	end
end

always @* begin
	for(j = 0; j < wI_pt; j = j+1) begin
		Xreg_e <= Xreg_e + (X_even[j] << 2*j);
		Xreg_o <= Xreg_o + (X_odd[j] << 2*j+1);
		Yreg_e <= Yreg_e + (Y_even[j] << 2*j);
		Yreg_o <= Yreg_o + (Y_odd[j] << 2*j+1);
	end
end

assign X_e = Xreg_e;
assign X_o = Xreg_o;
assign Y_e = Yreg_e;
assign Y_o = Yreg_o;

wire [31 : 0] ac,bc,ad,bd;
wire [63 : 0] t1,t2;
wire [48 : 0] psum;

	oka_16x16 i1(.a(X_o),.b(Y_o),.out(ac));
	oka_16x16 i2(.a(X_e),.b(Y_o),.out(bc));
	oka_16x16 i3(.a(X_o),.b(Y_e),.out(ad));
	oka_16x16 i4(.a(X_e),.b(Y_e),.out(bd));

assign t2 = bd;
assign psum = {bc+ad,16'b0};
assign t1 = {ac,32'b0};

assign oO = t1 + psum + t2;



endmodule

module oka_16x16(
    input [15:0] a,
    input [15:0] b,
    output [31:0] out
    );
    
    wire [15:0] ac,bc,ad,bd;
    wire [31:0] t1,t2;
    wire [24:0] psum;

reg   [7:0] X_even, X_odd, Y_even, Y_odd;
wire  [7:0] X_o, X_e, Y_o, Y_e;
reg   [7:0] Xreg_e, Xreg_o, Yreg_e, Yreg_o;

integer i;
integer j;
always @* begin
	for(i = 0; i < 8; i = i+1) begin
		X_even[i] <= a[2*i];
		X_odd[i] <= a[2*i + 1];
		Y_even[i] <= b[2*i];
		Y_odd[i] <= b[2*i + 1];	
	end
end

always @* begin
	for(j = 0; j < 8; j = j+1) begin
		Xreg_e <= Xreg_e + (X_even[j] << 2*j);
		Xreg_o <= Xreg_o + (X_odd[j] << 2*j+1);
		Yreg_e <= Yreg_e + (Y_even[j] << 2*j);
		Yreg_o <= Yreg_o + (Y_odd[j] << 2*j+1);
	end
end
	
assign X_e = Xreg_e;
assign X_o = Xreg_o;
assign Y_e = Yreg_e;
assign Y_o = Yreg_o;
    
	oka_8x8 i1(.a(X_o),.b(Y_o),.out(ac));
	oka_8x8 i2(.a(X_e),.b(Y_o),.out(bc));
	oka_8x8 i3(.a(X_o),.b(Y_e),.out(ad));
	oka_8x8 i4(.a(X_e),.b(Y_e),.out(bd));
	
  assign t2= bd;
  assign psum = {bc+ad,8'b00000000};
  assign t1={ac,16'b0000000000000000};
  assign out= t1+t2+psum;
endmodule

module oka_8x8(
    input [7:0] a,
    input [7:0] b,
    output [15:0] out
    );
    
    wire [7:0] ac,bc,ad,bd;
    wire [15:0] t1,t2;
    wire [12:0] psum;

reg   [3:0] X_even, X_odd, Y_even, Y_odd;
wire  [3:0] X_o, X_e, Y_o, Y_e;
reg   [3:0] Xreg_e, Xreg_o, Yreg_e, Yreg_o;

integer i;
integer j;
always @* begin
	for(i = 0; i < 4; i = i+1) begin
		X_even[i] <= a[2*i];
		X_odd[i] <= a[2*i + 1];
		Y_even[i] <= b[2*i];
		Y_odd[i] <= b[2*i + 1];	
	end
end

always @* begin
	for(j = 0; j < 4; j = j+1) begin
		Xreg_e <= Xreg_e + (X_even[j] << 2*j);
		Xreg_o <= Xreg_o + (X_odd[j] << 2*j+1);
		Yreg_e <= Yreg_e + (Y_even[j] << 2*j);
		Yreg_o <= Yreg_o + (Y_odd[j] << 2*j+1);
	end
end
	
assign X_e = Xreg_e;
assign X_o = Xreg_o;
assign Y_e = Yreg_e;
assign Y_o = Yreg_o;
	
	oka_4x4 m1(.a(X_o),.b(Y_o),.out(ac));
	oka_4x4 m2(.a(X_e),.b(Y_o),.out(bc));
	oka_4x4 m3(.a(X_o),.b(Y_e),.out(ad));
	oka_4x4 m4(.a(X_e),.b(Y_e),.out(bd));
	
  assign t2= bd;
  assign psum = {bc+ad,4'b0000};
  assign t1={ac,8'b0000};
  assign out= t1+t2+psum;
endmodule

module oka_4x4(
    input [3:0] a,
    input [3:0] b,
    output [7:0] out
    );
wire [3:0] ac,bc,ad,bd;
wire [7:0] t1,t2;
wire [6:0] psum;

reg   [1:0] X_even, X_odd, Y_even, Y_odd;
wire  [1:0] X_o, X_e, Y_o, Y_e;
reg   [1:0] Xreg_e, Xreg_o, Yreg_e, Yreg_o;

integer i;
integer j;
always @* begin
	for(i = 0; i < 2; i = i+1) begin
		X_even[i] <= a[2*i];
		X_odd[i] <= a[2*i + 1];
		Y_even[i] <= b[2*i];
		Y_odd[i] <= b[2*i + 1];	
	end
end

always @* begin
	for(j = 0; j < 2; j = j+1) begin
		Xreg_e <= Xreg_e + (X_even[j] << 2*j);
		Xreg_o <= Xreg_o + (X_odd[j] << 2*j+1);
		Yreg_e <= Yreg_e + (Y_even[j] << 2*j);
		Yreg_o <= Yreg_o + (Y_odd[j] << 2*j+1);
	end
end
	
assign X_e = Xreg_e;
assign X_o = Xreg_o;
assign Y_e = Yreg_e;
assign Y_o = Yreg_o;

    
ka_2x2 m1(.a(X_o),.b(Y_o),.out(ac));
ka_2x2 m2(.a(X_e),.b(Y_o),.out(bc));
ka_2x2 m3(.a(X_o),.b(Y_e),.out(ad));
ka_2x2 m4(.a(X_e),.b(Y_e),.out(bd));
	
  assign t2= bd;
  assign psum = {bc+ad,2'b00};
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
