`include "head.sv"

module lab4_3#(
    parameter LED_NUM = 16,
    parameter BOUNDARY = 10,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)
(
    input logic f_crystal,
    input logic rst_n,
    input logic setting,
    input logic input_buttom_R_raw, // second
    input logic input_buttom_L_raw, // minute
    input logic input_buttom_U_raw, // start_stop
    input logic input_buttom_B_raw,  // pause_resume

    output logic [LED_NUM-1:0] LED,
    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic start_stop,pause_resume,second_add_one,minute_add_one; // buttom
logic BCD_all_zero,minus_one_clock,load_inital; // FSM control signal
logic [BCD_BIT-1:0] BCD_SECOND_ONES, BCD_SECOND_TENS,
                    BCD_MINUTE_ONES, BCD_MINUTE_TENS;

logic [BCD_BIT-1:0] BCD_SECOND_ONES_bottom, BCD_SECOND_TENS_bottom,
                    BCD_MINUTE_ONES_bottom, BCD_MINUTE_TENS_bottom;

ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

// ================ Frequency divider ================ //
clock_gen_1Hz u_clock_1Hz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz)); // rst_n = 1'b1 --> countinuous clock
clock_gen_1kHz u_clock_1kHz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)); // rst_n = 1'b1 --> countinuous clock

// ================ Input Buttom Onepulse ================ //

input_processing u_input
(
    .clk(f_1kHz), .rst_n(rst_n),
    // .input_buttom_C_raw(),
    .input_buttom_B_raw(input_buttom_B_raw), 
    .input_buttom_U_raw(input_buttom_U_raw), 
    .input_buttom_R_raw(input_buttom_R_raw),
    .input_buttom_L_raw(input_buttom_L_raw),

    // .input_buttom_C(),
    .input_buttom_B(pause_resume),
    .input_buttom_U(start_stop), 
    .input_buttom_R(second_add_one),
    .input_buttom_L(minute_add_one)
);

// ================ Finite State Machine ================ //
FSM u_FSM(
    .clk(f_1kHz), .rst_n(rst_n), .setting(setting),
    .start_stop(start_stop),.pause_resume(pause_resume),.BCD_all_zero(BCD_all_zero),
    
    .minus_one(minus_one_clock),.load_inital(load_inital)
);

// ================ BCD Up Counter (Buttom trigger) ================ //
BCD_up_buttom u_BCD_up_buttom
(
    .clk(f_1kHz),.rst_n(rst_n),.enable(setting),
    .second_add_one(second_add_one), .minute_add_one(minute_add_one),
    
    .BCD_SECOND_ONES(BCD_SECOND_ONES_bottom),.BCD_SECOND_TENS(BCD_SECOND_TENS_bottom),
    .BCD_MINUTE_ONES(BCD_MINUTE_ONES_bottom),.BCD_MINUTE_TENS(BCD_MINUTE_TENS_bottom)
);

// ================ BCD Down Counter (Clock trigger) ================ //
logic [BCD_BIT-1:0] BCD_SECOND_ONES_inital = (setting) ? BCD_SECOND_ONES_bottom : '0 ;
logic [BCD_BIT-1:0] BCD_SECOND_TENS_inital = (setting) ? BCD_SECOND_TENS_bottom : '0 ;
logic [BCD_BIT-1:0] BCD_MINUTE_ONES_inital = (setting) ? BCD_MINUTE_ONES_bottom : '0 ;
logic [BCD_BIT-1:0] BCD_MINUTE_TENS_inital = (setting) ? BCD_MINUTE_TENS_bottom : '0 ;

BCD_down_top u_BCD_down_top
(
    .clk(f_1Hz),.rst_n(rst_n),.minus_one(minus_one_clock),.load_inital(load_inital),
    .BCD_SECOND_ONES_inital(BCD_SECOND_ONES_inital),.BCD_SECOND_TENS_inital(BCD_SECOND_TENS_inital),
    .BCD_MINUTE_ONES_inital(BCD_MINUTE_ONES_inital),.BCD_MINUTE_TENS_inital(BCD_MINUTE_TENS_inital),
    
    .BCD_SECOND_ONES(BCD_SECOND_ONES),.BCD_SECOND_TENS(BCD_SECOND_TENS),
    .BCD_MINUTE_ONES(BCD_MINUTE_ONES),.BCD_MINUTE_TENS(BCD_MINUTE_TENS)
);

// ================ Finish LED ================ //
logic BCD_SECOND_ONES_is_zero = (BCD_SECOND_ONES == '0);
logic BCD_SECOND_TENS_is_zero = (BCD_SECOND_TENS == '0);
logic BCD_MINUTE_ONES_is_zero = (BCD_MINUTE_ONES == '0);
logic BCD_MINUTE_TENS_is_zero = (BCD_MINUTE_TENS == '0);

assign BCD_all_zero =   BCD_SECOND_ONES_is_zero & BCD_SECOND_TENS_is_zero &
                        BCD_MINUTE_ONES_is_zero & BCD_MINUTE_TENS_is_zero ;

assign LED = {LED_NUM{BCD_all_zero & ~setting}}; // finish

// ================ BCD to SSD Decoder ================ //
logic [BCD_BIT-1:0] BCD_out_0 = (setting) ? BCD_SECOND_ONES_bottom  : BCD_SECOND_ONES;
logic [BCD_BIT-1:0] BCD_out_1 = (setting) ? BCD_SECOND_TENS_bottom  : BCD_SECOND_TENS;
logic [BCD_BIT-1:0] BCD_out_2 = (setting) ? BCD_MINUTE_ONES_bottom  : BCD_MINUTE_ONES;
logic [BCD_BIT-1:0] BCD_out_3 = (setting) ? BCD_MINUTE_TENS_bottom  : BCD_MINUTE_TENS;

BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_1 (.BCD_out(BCD_out_0),.SSD(SSD_position_0));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_2 (.BCD_out(BCD_out_1),.SSD(SSD_position_1));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_3 (.BCD_out(BCD_out_2),.SSD(SSD_position_2));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_4 (.BCD_out(BCD_out_3),.SSD(SSD_position_3));

// ================ SSD controller ================ // 
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

endmodule