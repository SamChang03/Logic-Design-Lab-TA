`include "head.v"

module lab2_2
(
    input [3:0] i,

    output [3:0] d,
    output reg [7:0] SSD
);

assign d = i;

always @(*) begin
    SSD = `SSD_FAULT;
    case (i)
        4'd0: SSD = `SSD_ZERO;
        4'd1: SSD = `SSD_ONE;
        4'd2: SSD = `SSD_TWO;
        4'd3: SSD = `SSD_THREE;

        4'd4: SSD = `SSD_FOUR;
        4'd5: SSD = `SSD_FIVE;
        4'd6: SSD = `SSD_SIX;
        4'd7: SSD = `SSD_SEVEN;

        4'd8: SSD = `SSD_EIGHT;
        4'd9: SSD = `SSD_NINE;
        4'd10: SSD = `SSD_A;
        4'd11: SSD = `SSD_B;

        4'd12: SSD = `SSD_C;
        4'd13: SSD = `SSD_D;
        4'd14: SSD = `SSD_E;
        4'd15: SSD = `SSD_F;
    endcase
end


endmodule