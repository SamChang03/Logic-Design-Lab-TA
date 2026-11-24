`ifndef HEAD_SV
`define HEAD_SV

typedef enum logic [7:0] {
    SSD_FAULT       = 8'b0000_0000,
    SSD_ZERO        = 8'b0000_0011,
    SSD_ONE         = 8'b1001_1111,
    SSD_TWO         = 8'b0010_0101,
    SSD_THREE       = 8'b0000_1101,
    SSD_FOUR        = 8'b1001_1001,
    SSD_FIVE        = 8'b0100_1001,
    SSD_SIX         = 8'b0100_0001,
    SSD_SEVEN       = 8'b0001_1111,
    SSD_EIGHT       = 8'b0000_0001,
    SSD_NINE        = 8'b0000_1001,
    SSD_A           = 8'b0001_0001,
    SSD_B           = 8'b1100_0001,
    SSD_C           = 8'b0110_0011,
    SSD_D           = 8'b1000_0101,
    SSD_E           = 8'b0110_0001,
    SSD_F           = 8'b0111_0001,
    SSD_H           = 8'b1001_0001,
    SSD_N           = 8'b1101_0101,
    SSD_T           = 8'b1110_0001,
    SSD_U           = 8'b1000_0011
} ssd_codeword;

`endif