`include "head.sv"

module lab3_7#(
    parameter BOUNDARY = 10,
    parameter BCD_BIT = 4
)
(
    input logic f_crystal,
    input logic rst_n,

    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic [BCD_BIT-1:0] BCD_out;


clock_gen_1Hz u_clock_1Hz(
    .f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz) // rst_n = 1'b1 --> countinuous clock
);

clock_gen_1kHz u_clock_1kHz(
.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)  // rst_n = 1'b1 --> countinuous clock
);

BCD_down u_BCD_DOWN_COUNTER (.clk(f_1Hz), .rst_n(rst_n), .BCD_out(BCD_out));

always_comb begin : BCD_2_SSD_Decoder
    SSD = SSD_FAULT;
    case (BCD_out)
        BCD_BIT'(0): SSD = SSD_ZERO;
        BCD_BIT'(1): SSD = SSD_ONE;
        BCD_BIT'(2): SSD = SSD_TWO;
        BCD_BIT'(3): SSD = SSD_THREE;
        BCD_BIT'(4): SSD = SSD_FOUR;
        BCD_BIT'(5): SSD = SSD_FIVE;
        BCD_BIT'(6): SSD = SSD_SIX;
        BCD_BIT'(7): SSD = SSD_SEVEN;
        BCD_BIT'(8): SSD = SSD_EIGHT;
        BCD_BIT'(9): SSD = SSD_NINE; 
    endcase
end

endmodule

module BCD_down #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4
)(
    input logic clk,
    input logic rst_n,

    output logic [3:0] BCD_out
);

logic [BCD_BIT-1:0] BCD_out_n;
logic ready_carry = (BCD_out == '0);

always_comb begin : counter
    BCD_out_n = (ready_carry) ? BCD_BIT'(BOUNDARY) : BCD_out-1;
end

always_ff @(posedge clk) begin : FF
    if (~rst_n) begin
        BCD_out <= BCD_BIT'(BOUNDARY);
    end
    else begin
        BCD_out <= BCD_out_n;
    end
end
    
endmodule