`include "head.sv"

module lab7_1#(
    parameter BCD_BIT = 4,
    parameter SSD_NUM = 4,
    parameter PS2_BIT = 9,
    parameter KEY_BIT = 512
)
(
    input logic f_crystal,
    input logic rst_n,
    inout logic PS2_CLK,
    inout logic PS2_DATA,

    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic [PS2_BIT-1:0] last_change;
logic [KEY_BIT-1:0] key_down;

ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

assign SSD_position_1 = SSD_NOSHOW;
assign SSD_position_2 = SSD_NOSHOW;
assign SSD_position_3 = SSD_NOSHOW;

// ================ Frequency divider ================ //
clock_gen_1Hz u_clock_1Hz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz)); // rst_n = 1'b1 --> countinuous clock
clock_gen_1kHz u_clock_1kHz(.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)); // rst_n = 1'b1 --> countinuous clock

// ================ Keyboard Decoder ================ //
KeyboardDecoder U_KeyboardDecoder(
    .clk(f_crystal), .rst(~rst_n),
    .PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),
    
    .key_valid(key_valid),.key_down(key_down),.last_change(last_change)
);

// ================ BCD to SSD Decoder ================ //
PS2_Decoder u_PS2_Decoder (
    // .clk(f_crystal), .rst_n(rst_n),
    // .key_valid(key_valid),
    .last_change(last_change),
    
    .is_num(is_num),.BCD_keyboard(BCD_keyboard),.SSD_keyboard(SSD_position_0)
);

// ================ SSD controller ================ // 
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

endmodule