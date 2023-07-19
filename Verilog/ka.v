module ka #(
parameter wI = 32,
parameter wO = 2 * wI
)
(
input   [wI-1:0]    iX,
input   [wI-1:0]    iY,
output  [wO-1:0]    oO
);

localparam wI_pt = wI / 2;

wire   [wI_pt-1:0] X_hi, X_lo;
wire   [wI_pt-1:0] Y_hi, Y_lo;

assign  {X_hi, X_lo} = iX;
assign  {Y_hi, Y_lo} = iY;

wire   [wI_pt*2-1:0]   p0;
wire   [wI_pt*2-1:0]   p1;
wire   [wI_pt*2-1:0]   p2;

assign  p2 = X_hi & Y_hi;
assign  p0 = X_lo & Y_lo;
assign  p1 = (X_hi & Y_lo) ^ (Y_hi & X_lo);

assign oO = (p2 << wI) ^ (p1 << wI_pt) ^ p0;

endmodule
