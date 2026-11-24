module lab3_1#(
    parameter DIVIDER = 27
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic f_out
);

logic [DIVIDER-1:0] cnt, cnt_n;

assign f_out = cnt[DIVIDER-1];

always_comb begin : conb
    cnt_n = cnt + 1'b1;
end

always_ff @(posedge f_crystal ) begin : FF
    if (~rst_n) begin
        cnt <= '0;
    end
    else begin
        cnt <= cnt_n;
    end
end

endmodule