`include "head.sv"

module lab4_1#(
    parameter LED_NUM = 16,
    parameter BOUNDARY = 10,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)
(
    input logic f_crystal,
    input logic rst_n,
    input logic input_buttom_R_raw, // reset
    input logic input_buttom_L_raw, // start_pause

    output logic [LED_NUM-1:0] LED,
    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic start_pause,reset; // buttom
logic BCD_all_zero,load_inital; // FSM control signal
logic [BCD_BIT-1:0] BCD_ONES, BCD_TENS;

ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

assign SSD_position_2 = SSD_ZERO;
assign SSD_position_3 = SSD_ZERO;

// ================ Frequency divider ================ //
clock_gen_1Hz u_clock_1Hz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz)); // rst_n = 1'b1 --> countinuous clock
clock_gen_1kHz u_clock_1kHz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)); // rst_n = 1'b1 --> countinuous clock

// ================ Input Buttom Onepulse ================ //

input_processing u_input
(
    .clk(f_1kHz), .rst_n(rst_n),
    // .input_buttom_C_raw(),
    // .input_buttom_B_raw(), 
    // .input_buttom_U_raw(), 
    .input_buttom_R_raw(input_buttom_R_raw),
    .input_buttom_L_raw(input_buttom_L_raw),

    // .input_buttom_C(),
    // .input_buttom_B(), 
    // .input_buttom_U(), 
    .input_buttom_R(reset),
    .input_buttom_L(start_pause)
);

// ================ Finite State Machine ================ //
FSM u_FSM(
    .clk(f_1kHz), .rst_n(rst_n), 
    .start_pause(start_pause),.reset(reset),.BCD_all_zero(BCD_all_zero),
    
    .minus_one(minus_one),.load_inital(load_inital)
);

// ================ BCD Down Counter ================ //
logic carry;

BCD_down #(
    .BCD_MAX(BCD_BIT'(9))
) 
u_BCD_DOWN_COUNTER_ONES 
(
    .clk(f_1Hz), .rst_n(rst_n), 
    .minus_one(minus_one),
    .load_inital(load_inital), .initial_value(BCD_BIT'(0)),
    
    .carry(carry), .BCD_out(BCD_ONES)
);

BCD_down #(
    .BCD_MAX(BCD_BIT'(5))
) 
u_BCD_DOWN_COUNTER_TENS 
(
    .clk(f_1Hz), .rst_n(rst_n), 
    .minus_one(carry),
    .load_inital(load_inital), .initial_value(BCD_BIT'(5)),
    
    .carry(), .BCD_out(BCD_TENS)
);

// ================ Finish LED ================ //
logic BCD_ONES_is_zero = (BCD_ONES == '0);
logic BCD_TENS_is_zero = (BCD_TENS == '0);
assign BCD_all_zero = BCD_ONES_is_zero & BCD_TENS_is_zero;
assign LED = {LED_NUM{BCD_all_zero}}; // finish

// ================ BCD to SSD Decoder ================ //
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_1 (.BCD_out(BCD_ONES),.SSD(SSD_position_0));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_2 (.BCD_out(BCD_TENS),.SSD(SSD_position_1));

// ================ SSD controller ================ // 
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

endmodule