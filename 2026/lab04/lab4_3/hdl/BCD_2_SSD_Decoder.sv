`include "head.sv"
module BCD_2_SSD_Decoder #(
    parameter BOUNDARY = 9,
    parameter BCD_BIT = 4
)(
    input logic [BCD_BIT-1:0] BCD_out,

    output ssd_codeword SSD
);

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