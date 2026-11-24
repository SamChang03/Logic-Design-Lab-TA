module clock_gen_1Hz#(
    parameter DIVIDER = 28
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic f_out
);

localparam MILLION = 1_000_000;
localparam TERMINAL_COUNT = 50 * MILLION - 1;

logic [DIVIDER-1:0] cnt, cnt_n;
logic f_out_next;

always_comb begin : conb
    cnt_n = (cnt == TERMINAL_COUNT) ? '0 : cnt + 1'b1;
    f_out_next = (cnt == TERMINAL_COUNT) ? ~f_out : f_out;
end

always_ff @(posedge f_crystal ) begin : FF
    if (~rst_n) begin
        cnt <= '0;
        f_out <= '0;
    end
    else begin
        cnt <= cnt_n;
        f_out <= f_out_next;
    end
end

endmodule