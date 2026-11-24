`include "head.sv"

module BCD_down_top#(
    parameter BCD_BIT = 4
)
(
    input logic clk,
    input logic rst_n,
    input logic load_inital,
    input logic minus_one,
    input logic [BCD_BIT-1:0] BCD_SECOND_ONES_inital,
    input logic [BCD_BIT-1:0] BCD_SECOND_TENS_inital,
    input logic [BCD_BIT-1:0] BCD_MINUTE_ONES_inital,
    input logic [BCD_BIT-1:0] BCD_MINUTE_TENS_inital,

    output logic [BCD_BIT-1:0] BCD_SECOND_ONES,
    output logic [BCD_BIT-1:0] BCD_SECOND_TENS,
    output logic [BCD_BIT-1:0] BCD_MINUTE_ONES,
    output logic [BCD_BIT-1:0] BCD_MINUTE_TENS
);

logic carry_12,carry_23,carry_34;

BCD_down #(
    .BCD_MAX(BCD_BIT'(9))
) 
u_BCD_DOWN_COUNTER_SECOND_ONES 
(
    .clk(clk), .rst_n(rst_n), 
    .minus_one(minus_one),
    .load_inital(load_inital), .initial_value(BCD_SECOND_ONES_inital),
    
    .carry(carry_12), .BCD_out(BCD_SECOND_ONES)
);

BCD_down #(
    .BCD_MAX(BCD_BIT'(5))
) 
u_BCD_DOWN_COUNTER_SECOND_TENS 
(
    .clk(clk), .rst_n(rst_n), 
    .minus_one(carry_12),
    .load_inital(load_inital), .initial_value(BCD_SECOND_TENS_inital),
    
    .carry(carry_23), .BCD_out(BCD_SECOND_TENS)
);

BCD_down #(
    .BCD_MAX(BCD_BIT'(9))
) 
u_BCD_DOWN_COUNTER_MINUTE_ONES 
(
    .clk(clk), .rst_n(rst_n), 
    .minus_one(carry_23),
    .load_inital(load_inital), .initial_value(BCD_MINUTE_ONES_inital),
    
    .carry(carry_34), .BCD_out(BCD_MINUTE_ONES)
);

BCD_down #(
    .BCD_MAX(BCD_BIT'(5))
) 
u_BCD_DOWN_COUNTER_MINUTE_TENS 
(
    .clk(clk), .rst_n(rst_n), 
    .minus_one(carry_34),
    .load_inital(load_inital), .initial_value(BCD_MINUTE_TENS_inital),
    
    .carry(), .BCD_out(BCD_MINUTE_TENS)
);

endmodule