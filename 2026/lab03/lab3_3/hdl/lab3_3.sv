module lab3_3#(
    parameter DIVIDER = 30,
    parameter CNT_BIT = 4
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic [CNT_BIT-1:0] q
);

freq_divider u_freq_divider
(
    .f_crystal(f_crystal),
    .rst_n(rst_n),

    .f_out(f_1Hz)
);

logic [CNT_BIT-1:0] q_next;

always_comb begin
    q_next = q + 1;
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