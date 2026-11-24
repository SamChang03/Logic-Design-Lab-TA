`include "head.sv"

module lab3_6#(
    parameter PATTERN_NUM = 10,
    parameter PATTERN_CNT_BIT = 4,
    parameter SSD_NUM = 4,
    parameter SSD_CNT_BIT = 2
)
(
    input logic f_crystal,
    input logic rst_n,

    output logic [SSD_NUM-1:0] SSD_order,
    output ssd_codeword SSD
);

logic f_1Hz, f_1kHz;
logic [SSD_CNT_BIT-1:0] ssd_cnt, ssd_cnt_n;
ssd_codeword SSD_position_0, SSD_position_1,
             SSD_position_2, SSD_position_3;

logic [PATTERN_CNT_BIT-1:0] pattern_cnt, pattern_cnt_n;

clock_gen_1Hz u_clock_1Hz(
    .f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1Hz) // rst_n = 1'b1 --> countinuous clock
);

clock_gen_1kHz u_clock_1kHz(
.f_crystal(f_crystal),.rst_n(1'b1),.f_out(f_1kHz)  // rst_n = 1'b1 --> countinuous clock
);

// SSD controller
ssd_control u_SSD_CONTROLLER
(
    .clk_1kHz(f_1kHz),.rst_n(rst_n),
    .SSD_position_0(SSD_position_0),.SSD_position_1(SSD_position_1),
    .SSD_position_2(SSD_position_2),.SSD_position_3(SSD_position_3),

    .SSD_order(SSD_order),.SSD(SSD)
);

// Pattern decoder
always_comb begin : pattern_counter
    pattern_cnt_n = (pattern_cnt == PATTERN_NUM-1) ? '0 : pattern_cnt + 1'b1;
end

always_comb begin : pattern_decoder
    {SSD_position_3,SSD_position_2,SSD_position_1,SSD_position_0} = {4{SSD_FAULT}};
    case (pattern_cnt)
        PATTERN_CNT_BIT'(0): begin SSD_position_3 = SSD_N;   SSD_position_2 = SSD_T;   SSD_position_1 = SSD_H;   SSD_position_0 = SSD_U;   end
        PATTERN_CNT_BIT'(1): begin SSD_position_3 = SSD_T;   SSD_position_2 = SSD_H;   SSD_position_1 = SSD_U;   SSD_position_0 = SSD_E;   end
        PATTERN_CNT_BIT'(2): begin SSD_position_3 = SSD_H;   SSD_position_2 = SSD_U;   SSD_position_1 = SSD_E;   SSD_position_0 = SSD_E;   end
        PATTERN_CNT_BIT'(3): begin SSD_position_3 = SSD_U;   SSD_position_2 = SSD_E;   SSD_position_1 = SSD_E;   SSD_position_0 = SSD_TWO; end
        PATTERN_CNT_BIT'(4): begin SSD_position_3 = SSD_E;   SSD_position_2 = SSD_E;   SSD_position_1 = SSD_TWO; SSD_position_0 = SSD_ZERO;end
        PATTERN_CNT_BIT'(5): begin SSD_position_3 = SSD_E;   SSD_position_2 = SSD_TWO; SSD_position_1 = SSD_ZERO;SSD_position_0 = SSD_TWO; end
        PATTERN_CNT_BIT'(6): begin SSD_position_3 = SSD_TWO; SSD_position_2 = SSD_ZERO;SSD_position_1 = SSD_TWO; SSD_position_0 = SSD_SIX; end
        PATTERN_CNT_BIT'(7): begin SSD_position_3 = SSD_ZERO;SSD_position_2 = SSD_TWO; SSD_position_1 = SSD_SIX; SSD_position_0 = SSD_N;   end
        PATTERN_CNT_BIT'(8): begin SSD_position_3 = SSD_TWO; SSD_position_2 = SSD_SIX; SSD_position_1 = SSD_N;   SSD_position_0 = SSD_T;   end
        PATTERN_CNT_BIT'(9): begin SSD_position_3 = SSD_SIX; SSD_position_2 = SSD_N;   SSD_position_1 = SSD_T;   SSD_position_0 = SSD_H;   end
    endcase
end

always_ff @(posedge f_1Hz) begin : slow_clock
    if (~rst_n) begin
        pattern_cnt <= '0;
    end
    else begin
        pattern_cnt <= pattern_cnt_n;
    end
end


endmodule