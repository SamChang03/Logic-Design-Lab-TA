`include "head.v"

module lab2_2(
    input [3:0] s1, s0, // Secret number digits (BCD)
    input [3:0] g1, g0, // Guess number digits (BCD)
    output reg [2:0] bulls, // 0, 1, or 2
    output reg [2:0] cows   // 0, 1, or 2
);

wire [1:0] bulls_num, cows_num;

assign bulls_num = (g1 == s1) + (g0 == s0);
assign cows_num  = (g1 == s0) + (g0 == s1);

always @(*) begin
    bulls = 3'b111;
    case (bulls_num)
        3'd0: bulls = 3'b001;
        3'd1: bulls = 3'b010;
        3'd2: bulls = 3'b100;
    endcase
end

always @(*) begin
    cows = 3'b111;
    case (cows_num)
        3'd0: cows = 3'b001;
        3'd1: cows = 3'b010;
        3'd2: cows = 3'b100;
    endcase
end
endmodule