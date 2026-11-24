`include "head.sv"

module lab3_5#(
    parameter DIVIDER = 30,
    parameter CNT_BIT = 7,
    parameter INITIAL_VALUE = 7'b1101110
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic [CNT_BIT-1:0] ring_counter
);


freq_divider u_freq_divider
(
    .f_crystal(f_crystal),
    .rst_n(rst_n),

    .f_out(f_1Hz)
);

always_ff @(posedge f_1Hz) begin
    if (~rst_n) begin
        ring_counter <= INITIAL_VALUE;
    end
    else begin
        ring_counter <= {ring_counter[CNT_BIT-2:0], ring_counter[CNT_BIT-1]};
    end
end


endmodule