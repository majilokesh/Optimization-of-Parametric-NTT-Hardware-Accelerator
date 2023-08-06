module rad4 #(parameter wI = 32,
parameter wO = 2 * wI)(
    input signed [wI - 1 : 0] iX, iY,
    output reg [wO - 1 : 0] oO);
    
    wire [wI-1:0] M, minus_M, two_M, minus_two_M;
    
    assign M = iX;
    assign minus_M = ~iX + 1'b1;
    assign two_M = M << 1;
    assign two_minus_M = minus_M << 1;
    
    reg [wI:0] Q;
    
    integer i;
    always @* begin
        oO = 64'b0;
        Q = {iY, 1'b0};
        for(i = 0; i < wI/2; i = i+1) begin
            case(Q[2:0])
                3'b000: begin
                            oO = oO + ({{(wO-wI){1'b0}},32'b0} << 2*i);
                            Q = Q >> 2;
                        end
                3'b001: begin
                            oO = oO + ({{(wO-wI){M[wI-1]}},M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b010: begin
                            oO = oO + ({{(wO-wI){M[wI-1]}},M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b011: begin
                            oO = oO + ({{(wO-wI){two_M[wI-1]}},two_M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b100: begin
                            oO = oO + ({{(wO-wI){minus_two_M[wI-1]}},minus_two_M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b101: begin
                            oO = oO + ({{(wO-wI){minus_M[wI-1]}},minus_M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b110: begin
                            oO = oO + ({{(wO-wI){minus_M[wI-1]}},minus_M} << 2*i);
                            Q = Q >> 2;
                        end
                3'b111: begin
                            oO = oO + ({{(wO-wI){1'b0}},32'b0} << 2*i);
                            Q = Q >> 2;
                        end
            endcase
        end
    end
endmodule
