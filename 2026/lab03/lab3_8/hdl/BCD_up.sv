module BCD_up #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4
)(
    input logic clk,
    input logic rst_n,
    input logic add_one,

    output logic carry,
    output logic [3:0] BCD_out
);

logic [BCD_BIT-1:0] BCD_out_n;


always_comb begin : counter
    BCD_out_n = BCD_out;
    carry = '0;
    if (add_one) begin
        BCD_out_n = (BCD_out == BCD_BIT'(BOUNDARY)) ? '0 : BCD_out+1;
        carry = (BCD_out == BCD_BIT'(BOUNDARY));
    end
end

always_ff @(posedge clk) begin : FF
    if (~rst_n) begin
        BCD_out <= '0;
    end
    else begin
        BCD_out <= BCD_out_n;
    end
end
    
endmodule