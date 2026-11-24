module BCD_up #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4,
    parameter BCD_MIN = BCD_BIT'(0)
)(
    input logic clk,
    input logic rst_n,
    input logic add_one,
    input logic load_inital,
    input logic [BCD_BIT-1:0] initial_value,

    output logic carry,
    output logic [3:0] BCD_out
);

logic [BCD_BIT-1:0] BCD_out_n;

logic hit_boundary = BCD_out == BCD_BIT'(BOUNDARY);

always_comb begin : counter
    BCD_out_n = BCD_out;
    carry = '0;
    if (load_inital) begin
        BCD_out_n = initial_value;
    end
    else if (add_one) begin
        BCD_out_n = (hit_boundary) ? BCD_MIN : BCD_out+1;
        carry = hit_boundary;
    end
end

always_ff @(posedge clk) begin : FF
    if (~rst_n) begin
        BCD_out <= initial_value;
    end
    else begin
        BCD_out <= BCD_out_n;
    end
end
    
endmodule