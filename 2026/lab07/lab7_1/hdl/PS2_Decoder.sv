`include "head.sv"
module PS2_Decoder #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4,
    parameter PS2_BIT = 9
)(
    // input logic clk,
    // input logic rst_n,
    // input logic key_valid,
    input logic [PS2_BIT-1:0] last_change,

    output logic is_num,
    output logic is_operator,
    output logic is_enter,
    output logic [BCD_BIT-1:0] BCD_keyboard,
    output ssd_codeword SSD_keyboard
);

// logic [PS2_BIT-1:0] letter;

// always_ff @(posedge clk) begin
//     if (~rst_n) begin
//         letter <= '0;
//     end
//     else begin
//         letter <= (key_valid) ? last_change : letter;
//     end
// end

always_comb begin
    SSD_keyboard = SSD_FAULT;
    is_num = 0; is_operator=0; is_enter = 0;
    BCD_keyboard = BCD_BIT'(0);
    case(last_change)
        PS2_BIT'('h45): begin is_num = 1; SSD_keyboard = SSD_ZERO;  BCD_keyboard = BCD_BIT'(0); end // 0
        PS2_BIT'('h16): begin is_num = 1; SSD_keyboard = SSD_ONE;   BCD_keyboard = BCD_BIT'(1); end // 1
        PS2_BIT'('h1E): begin is_num = 1; SSD_keyboard = SSD_TWO;   BCD_keyboard = BCD_BIT'(2); end // 2
        PS2_BIT'('h26): begin is_num = 1; SSD_keyboard = SSD_THREE; BCD_keyboard = BCD_BIT'(3); end // 3
        PS2_BIT'('h25): begin is_num = 1; SSD_keyboard = SSD_FOUR;  BCD_keyboard = BCD_BIT'(4); end // 4
        PS2_BIT'('h2E): begin is_num = 1; SSD_keyboard = SSD_FIVE;  BCD_keyboard = BCD_BIT'(5); end // 5
        PS2_BIT'('h36): begin is_num = 1; SSD_keyboard = SSD_SIX;   BCD_keyboard = BCD_BIT'(6); end // 6
        PS2_BIT'('h3D): begin is_num = 1; SSD_keyboard = SSD_SEVEN; BCD_keyboard = BCD_BIT'(7); end // 7
        PS2_BIT'('h3E): begin is_num = 1; SSD_keyboard = SSD_EIGHT; BCD_keyboard = BCD_BIT'(8); end // 8
        PS2_BIT'('h46): begin is_num = 1; SSD_keyboard = SSD_NINE;  BCD_keyboard = BCD_BIT'(9); end // 9

        PS2_BIT'('h1C): begin is_operator = 1; SSD_keyboard = SSD_ADD; end //A
        PS2_BIT'('h1B): begin is_operator = 1; SSD_keyboard = SSD_SUB; end //S
        PS2_BIT'('h23): begin is_operator = 1; SSD_keyboard = SSD_MUL; end //D

        PS2_BIT'('h5A): begin is_enter = 1; SSD_keyboard = SSD_NOSHOW; end //enter
    endcase
end
    
endmodule