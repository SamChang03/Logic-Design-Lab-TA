`include "head.sv"

module lab6_2#(
    parameter DATA_NUM = 16,
    parameter NOTE_BIT = 22,
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4
)(
    input logic f_crystal, // 100MHz
    input logic rst_n,

    input logic input_buttom_C_raw,
    input logic input_buttom_B_raw,
    input logic input_buttom_U_raw,
    input logic input_buttom_R_raw,
    input logic input_buttom_L_raw,

    output logic audio_mclk, // 25MHz
    output logic audio_lrck, // 25/128 MHz
    output logic audio_sck,  // (25/128)*32MHz (right:16, left:16)
    output logic audio_sdin,  // (25/128)*32MHz (right:16, left:16)
    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);


logic [DATA_NUM-1:0] audio_in_left, audio_in_right;
logic [BCD_BIT-1:0] audio_volume, BCD_ONES, BCD_TENS;
logic [NOTE_BIT-1:0] note_div;

ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

// ================ Frequency divider ================ //
clock_gen_1Hz u_clock_1Hz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz)); // rst_n = 1'b1 --> countinuous clock
clock_gen_1kHz u_clock_1kHz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)); // rst_n = 1'b1 --> countinuous clock

// ================ Input Buttom Onepulse ================ //
logic increase_volume, decreas_volume;
logic button_Do = input_buttom_L_raw;
logic button_Re = input_buttom_C_raw;
logic button_Me = input_buttom_R_raw;
input_processing u_input
(
    .clk(f_1kHz), .rst_n(rst_n),
    // .input_buttom_C_raw(input_buttom_C_raw),
    .input_buttom_B_raw(input_buttom_B_raw), 
    .input_buttom_U_raw(input_buttom_U_raw), 
    // .input_buttom_R_raw(input_buttom_R_raw),
    // .input_buttom_L_raw(input_buttom_L_raw),

    // .input_buttom_C(button_Re),
    .input_buttom_B(decreas_volume), 
    .input_buttom_U(increase_volume) 
    // .input_buttom_R(button_Me),
    // .input_buttom_L(button_Do)
);

// ================ BCD Upcounter ================ //
logic carry;
logic [BCD_BIT-1:0] min = (BCD_ONES == BCD_BIT'(0) & BCD_TENS == BCD_BIT'(0));
logic [BCD_BIT-1:0] max = (BCD_ONES == BCD_BIT'(5) & BCD_TENS == BCD_BIT'(1));

logic increase_volume_with_boundary = increase_volume & ~max;
logic decreas_volume_with_boundary = decreas_volume & ~min;

BCD_up #(
    .BOUNDARY(BCD_BIT'(9))
) 
u_BCD_UP_COUNTER_SECOND_ONES 
(
    .clk(f_1kHz), .rst_n(rst_n), 
    .add_one(increase_volume_with_boundary),
    .minus_one(decreas_volume_with_boundary),
    .load_inital(0), .initial_value(BCD_BIT'(8)),
    
    .carry(carry), .BCD_out(BCD_ONES)
);

BCD_up #(
    .BOUNDARY(BCD_BIT'(1))
) 
u_BCD_UP_COUNTER_SECOND_TENS 
(
    .clk(f_1kHz), .rst_n(rst_n), 
    .add_one(carry),
    .minus_one(carry),
    .load_inital(0), .initial_value(BCD_BIT'(0)),
    
    .carry(), .BCD_out(BCD_TENS)
);

always_ff @(posedge f_1kHz ) begin
    if (~rst_n) begin
        audio_volume <= BCD_BIT'(8);
    end
    else begin
        audio_volume <= audio_volume;
        if (increase_volume_with_boundary) begin
            audio_volume <= audio_volume + 1;
        end
        else if (decreas_volume_with_boundary) begin
            audio_volume <= audio_volume - 1;
        end
    end
end

// ================ BCD to SSD Decoder ================ //
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_1 (.BCD_out(BCD_ONES),.SSD(SSD_position_0));
BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_2 (.BCD_out(BCD_TENS),.SSD(SSD_position_1));
assign SSD_position_2 = SSD_NOSHOW;
assign SSD_position_3 = SSD_NOSHOW;
// BCD_2_SSD_Decoder u_BCD_2_SSD_Decoder_3 (.BCD_out(audio_volume),.SSD(SSD_position_3));

// ================ SSD controller ================ // 
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

// ================ Speaker ================ //
always_comb begin
    note_div = '0;
    case (1'b1)
        button_Do: note_div = 22'd191571;
        button_Re: note_div = 22'd170265;
        button_Me: note_div = 22'd151685;
    endcase
end
note_gen U_ng( 
    .clk(f_crystal), // clock from crystal
    .rst_n(rst_n), // active low reset
    .note_div(note_div), // div for note generation
    .audio_volume(audio_volume),

    .audio_left(audio_in_left), // left sound audio
    .audio_right(audio_in_right) // right sound audio
);

speaker_control u_speaker_control(
    .f_crystal(f_crystal),.rst_n(rst_n),.en(1'b1),
    .audio_in_left(audio_in_left), .audio_in_right(audio_in_right),

    .audio_mclk(audio_mclk),.audio_lrck(audio_lrck),
    .audio_sck(audio_sck), .audio_sdin(audio_sdin)
);

endmodule