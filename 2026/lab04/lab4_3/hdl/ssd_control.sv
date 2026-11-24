`include "head.sv"

module ssd_control #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)(
    input logic clk_1kHz,
    input logic rst_n,
    input ssd_codeword SSD_position_0,
    input ssd_codeword SSD_position_1,
    input ssd_codeword SSD_position_2,
    input ssd_codeword SSD_position_3,

    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);


logic [SSD_CNT_BIT-1:0] ssd_cnt, ssd_cnt_n;
logic [SSD_NUM-1:0] SSD_order_buf;
ssd_codeword SSD_buf;

always_comb begin : ssd_counter // For continuous show
    ssd_cnt_n = ssd_cnt + 1;
end

always_comb begin : SSD_decoder
    SSD_buf = SSD_FAULT;
    case (ssd_cnt)
        2'd0: begin SSD_buf = SSD_position_0; SSD_order_buf = 4'b1110; end
        2'd1: begin SSD_buf = SSD_position_1; SSD_order_buf = 4'b1101; end
        2'd2: begin SSD_buf = SSD_position_2; SSD_order_buf = 4'b1011; end
        2'd3: begin SSD_buf = SSD_position_3; SSD_order_buf = 4'b0111; end
    endcase
end

always_ff @(posedge clk_1kHz) begin
    if (~rst_n) begin
        ssd_cnt <= '0;
    end
    else begin
        ssd_cnt <= ssd_cnt_n;
    end
end

always_ff @(posedge clk_1kHz) begin : output_buffer
    if (~rst_n) begin
        SSD <= SSD_FAULT;
        SSD_order <= 4'b0000;
    end
    else begin
        SSD <= SSD_buf;
        SSD_order <= SSD_order_buf;
    end
end

endmodule