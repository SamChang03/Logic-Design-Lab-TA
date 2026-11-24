`include "head.sv"

module lab3_8#(
    parameter BOUNDARY = 10,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic carry;
logic [BCD_BIT-1:0] BCD_ONES, BCD_TENS;

ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

assign SSD_position_2 = SSD_ZERO;
assign SSD_position_3 = SSD_ZERO;

clock_gen_1Hz u_clock_1Hz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz)); // rst_n = 1'b1 --> countinuous clock

clock_gen_1kHz u_clock_1kHz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)); // rst_n = 1'b1 --> countinuous clock

BCD_up u_BCD_UP_COUNTER_ONES (
    .clk(f_1Hz), .rst_n(rst_n), .add_one(1'b1),
    .carry(carry), .BCD_out(BCD_ONES)
);

BCD_up u_BCD_UP_COUNTER_TENS (
    .clk(f_1Hz), .rst_n(rst_n), .add_one(carry),
    .carry(), .BCD_out(BCD_TENS)
);

BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_1 (.BCD_out(BCD_ONES),.SSD(SSD_position_0));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_2 (.BCD_out(BCD_TENS),.SSD(SSD_position_1));

// SSD controller
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

endmodule