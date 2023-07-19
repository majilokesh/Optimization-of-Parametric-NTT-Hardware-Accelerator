`include "defines.v"

module ka_ModRed_sub #(parameter CURR_DATA = 0, NEXT_DATA = 0)
                  (input                                     clk,reset,
				   input     [`DATA_SIZE_ARB-1:0]  qH,
				   input     [CURR_DATA-1:0]                 T1,
				   output reg[NEXT_DATA-1:0]                 C);

// connections
reg [(`W_SIZE)-1:0]             T2L;
reg [(`DATA_SIZE_ARB)-1:0]             T2;

reg [(CURR_DATA - `W_SIZE)-1:0] T2H;
reg                             CARRY;

(* use_dsp = "yes" *) reg [(`DATA_SIZE_ARB * 2) - 1:0]      MULT;
wire [(`DATA_SIZE_ARB * 2) - 1:0] result;

ka #(.wI(`DATA_SIZE_ARB), .wO(2 * `DATA_SIZE_ARB)) qH_mul_T2 (
		.iX(qH),
		.iY(T2),
		.oO(result));

// --------------------------------------------------------------- multiplication of qH and T2 (and registers)
always @(*) begin
	T2L = T1[(`W_SIZE)-1:0];
    T2  = (-T2L);
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        T2H   <= 0;
        CARRY <= 0;
        MULT  <= 0;
    end
    else begin
        T2H   <= (T1 >> (`W_SIZE));
        CARRY <= (T2L[`W_SIZE-1] | T2[`W_SIZE-1]);
        MULT  <= result;
    end
end

// --------------------------------------------------------------- final addition operation
always @(posedge clk or posedge reset) begin
    if(reset) begin
        C <= 0;
    end
    else begin
        C <= (MULT+T2H)+CARRY;
    end
end

endmodule
