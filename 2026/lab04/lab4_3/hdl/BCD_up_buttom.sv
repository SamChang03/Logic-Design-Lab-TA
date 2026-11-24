`include "head.sv"

module BCD_up_buttom#(
    parameter BCD_BIT = 4
)
(
    input logic clk,
    input logic rst_n,
    input logic second_add_one,
    input logic minute_add_one,
    input logic enable,

    output logic [BCD_BIT-1:0] BCD_SECOND_ONES,
    output logic [BCD_BIT-1:0] BCD_SECOND_TENS,
    output logic [BCD_BIT-1:0] BCD_MINUTE_ONES,
    output logic [BCD_BIT-1:0] BCD_MINUTE_TENS
);

logic carry_12,carry_34;

BCD_up #(
    .BOUNDARY(BCD_BIT'(9))
) 
u_BCD_DOWN_COUNTER_SECOND_ONES 
(
    .clk(clk), .rst_n(rst_n), 
    .add_one(second_add_one & enable),
    .load_inital('0), .initial_value(BCD_BIT'(0)),
    
    .carry(carry_12), .BCD_out(BCD_SECOND_ONES)
);

BCD_up #(
    .BOUNDARY(BCD_BIT'(5))
) 
u_BCD_DOWN_COUNTER_SECOND_TENS 
(
    .clk(clk), .rst_n(rst_n), 
    .add_one(carry_12),
    .load_inital('0), .initial_value(BCD_BIT'(0)),
    
    .carry(), .BCD_out(BCD_SECOND_TENS)
);

BCD_up #(
    .BOUNDARY(BCD_BIT'(9))
) 
u_BCD_DOWN_COUNTER_MINUTE_ONES 
(
    .clk(clk), .rst_n(rst_n), 
    .add_one(minute_add_one & enable),
    .load_inital('0), .initial_value(BCD_BIT'(0)),
    
    .carry(carry_34), .BCD_out(BCD_MINUTE_ONES)
);

BCD_up #(
    .BOUNDARY(BCD_BIT'(5))
) 
u_BCD_DOWN_COUNTER_MINUTE_TENS 
(
    .clk(clk), .rst_n(rst_n), 
    .add_one(carry_34),
    .load_inital('0), .initial_value(BCD_BIT'(0)),
    
    .carry(), .BCD_out(BCD_MINUTE_TENS)
);

endmodule