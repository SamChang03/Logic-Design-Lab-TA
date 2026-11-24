`include "head.sv"

module lab4_2#(
    parameter LED_NUM = 16,
    parameter BOUNDARY = 10,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)
(
    input logic f_crystal,
    input logic rst_n,
    input logic input_buttom_R_raw, // lap_reset
    input logic input_buttom_L_raw, // start_pause

    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic start_pause,lap_reset; // buttom
logic add_one,load_inital,freeze; // FSM control signal
logic [BCD_BIT-1:0] BCD_SECOND_ONES, BCD_SECOND_TENS,
                    BCD_MINUTE_ONES, BCD_MINUTE_TENS;
                    
logic [BCD_BIT-1:0] BCD_SECOND_ONES_buf, BCD_SECOND_TENS_buf,
                    BCD_MINUTE_ONES_buf, BCD_MINUTE_TENS_buf;

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
    // .input_buttom_B_raw(), 
    // .input_buttom_U_raw(), 
    .input_buttom_R_raw(input_buttom_R_raw),
    .input_buttom_L_raw(input_buttom_L_raw),

    // .input_buttom_C(),
    // .input_buttom_B(), 
    // .input_buttom_U(), 
    .input_buttom_R(lap_reset),
    .input_buttom_L(start_pause)
);

// ================ Finite State Machine ================ //
FSM u_FSM(
    .clk(f_1kHz), .rst_n(rst_n), 
    .start_pause(start_pause),.lap_reset(lap_reset),
    
    .add_one(add_one),.load_inital(load_inital),.freeze(freeze)
);

// ================ BCD Down Counter ================ //
BCD_top u_BCD_top
(
    .clk(f_1Hz),.rst_n(rst_n),.add_one(add_one),.load_inital(load_inital),
    
    .BCD_SECOND_ONES(BCD_SECOND_ONES),.BCD_SECOND_TENS(BCD_SECOND_TENS),
    .BCD_MINUTE_ONES(BCD_MINUTE_ONES),.BCD_MINUTE_TENS(BCD_MINUTE_TENS)
);

// ================ Output Buffer ================ //
output_buf u_output_buf(
    .clk(f_1kHz), .load_enable(~freeze),
    .BCD_SECOND_ONES(BCD_SECOND_ONES),.BCD_SECOND_TENS(BCD_SECOND_TENS),
    .BCD_MINUTE_ONES(BCD_MINUTE_ONES),.BCD_MINUTE_TENS(BCD_MINUTE_TENS),

    .BCD_SECOND_ONES_buf(BCD_SECOND_ONES_buf),.BCD_SECOND_TENS_buf(BCD_SECOND_TENS_buf),
    .BCD_MINUTE_ONES_buf(BCD_MINUTE_ONES_buf),.BCD_MINUTE_TENS_buf(BCD_MINUTE_TENS_buf)
);
// ================ BCD to SSD Decoder ================ //
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_1 (.BCD_out(BCD_SECOND_ONES_buf),.SSD(SSD_position_0));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_2 (.BCD_out(BCD_SECOND_TENS_buf),.SSD(SSD_position_1));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_3 (.BCD_out(BCD_MINUTE_ONES_buf),.SSD(SSD_position_2));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_4 (.BCD_out(BCD_MINUTE_TENS_buf),.SSD(SSD_position_3));

// ================ SSD controller ================ // 
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

endmodule