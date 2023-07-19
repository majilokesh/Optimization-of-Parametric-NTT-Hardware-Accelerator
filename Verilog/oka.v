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
		Xreg_e <= Xreg_e + (X_even[i] << 2*i);
		Xreg_o <= Xreg_o + (X_odd[i] << 2*i+1);
		Yreg_e <= Yreg_e + (Y_even[i] << 2*i);
		Yreg_o <= Yreg_o + (Y_odd[i] << 2*i+1);
	end
end

assign X_e = Xreg_e;
assign X_o = Xreg_o;
assign Y_e = Yreg_e;
assign Y_o = Yreg_o;

wire [wO-1:0] G0;
wire [wO-1:0] G1;
wire [wO-1:0] G2;

assign G0 = X_e & Y_e;
assign G1 = (X_e & Y_o) ^ (X_o & Y_e);
assign G2 = X_o & Y_o;

//karat_mult #(.wI(wI), .wO(wO)) mult1 (.iX(X_o + X_e), .iY(Y_o + Y_e), .oO(oO));

assign oO = G2 ^ G1 ^ G0;

endmodule
