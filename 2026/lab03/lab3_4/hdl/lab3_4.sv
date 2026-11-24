`include "head.sv"

module lab3_4#(
    parameter DIVIDER = 30,
    parameter CNT_BIT = 4
)
(
    input logic f_crystal,
    input logic rst_n,

    output ssd_codeword SSD
);


freq_divider u_freq_divider
(
    .f_crystal(f_crystal),
    .rst_n(rst_n),

    .f_out(f_1Hz)
);

logic [CNT_BIT-1:0] q, q_next;

always_comb begin: binary_up_counter
    q_next = q + 1;
end

always_comb begin : SSD_decoder
    SSD = SSD_FAULT;
    unique case (q)
        4'h0 : SSD = SSD_ZERO;
        4'h1 : SSD = SSD_ONE;
        4'h2 : SSD = SSD_TWO;
        4'h3 : SSD = SSD_THREE;
        4'h4 : SSD = SSD_FOUR;
        4'h5 : SSD = SSD_FIVE;
        4'h6 : SSD = SSD_SIX;
        4'h7 : SSD = SSD_SEVEN;
        4'h8 : SSD = SSD_EIGHT;
        4'h9 : SSD = SSD_NINE;
        4'hA : SSD = SSD_A;
        4'hB : SSD = SSD_B;
        4'hC : SSD = SSD_C;
        4'hD : SSD = SSD_D;
        4'hE : SSD = SSD_E;
        4'hF : SSD = SSD_F;
    endcase
end

always_ff@(posedge f_1Hz) begin
    if (~rst_n) begin
        q <= '0;
    end
    else begin
        q <= q_next;
    end
end

endmodule