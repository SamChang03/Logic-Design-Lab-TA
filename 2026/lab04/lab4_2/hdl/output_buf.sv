module output_buf #(
    parameter BCD_NUM = 4,
    parameter BCD_BIT = 4
)(
    input logic clk,
    input logic load_enable,
    input logic [BCD_BIT-1:0] BCD_SECOND_ONES,
    input logic [BCD_BIT-1:0] BCD_SECOND_TENS,
    input logic [BCD_BIT-1:0] BCD_MINUTE_ONES,
    input logic [BCD_BIT-1:0] BCD_MINUTE_TENS,

    output logic [BCD_BIT-1:0] BCD_SECOND_ONES_buf,
    output logic [BCD_BIT-1:0] BCD_SECOND_TENS_buf,
    output logic [BCD_BIT-1:0] BCD_MINUTE_ONES_buf,
    output logic [BCD_BIT-1:0] BCD_MINUTE_TENS_buf
);

reg [BCD_BIT-1:0] memory [0:BCD_NUM-1];
reg [BCD_BIT-1:0] memory_n [0:BCD_NUM-1];

assign BCD_SECOND_ONES_buf = memory[0];
assign BCD_SECOND_TENS_buf = memory[1];
assign BCD_MINUTE_ONES_buf = memory[2];
assign BCD_MINUTE_TENS_buf = memory[3];


always_comb begin
    for (int i = 0; i< BCD_NUM; i++) begin
        memory_n[i] = memory[i];
    end
    if (load_enable) begin
        memory_n[0] = BCD_SECOND_ONES;
        memory_n[1] = BCD_SECOND_TENS;
        memory_n[2] = BCD_MINUTE_ONES;
        memory_n[3] = BCD_MINUTE_TENS;
    end
end

always_ff @(posedge clk) begin : blockName
    for (int i = 0; i< BCD_NUM; i++) begin
        memory[i] <= memory_n[i];
    end
end
endmodule