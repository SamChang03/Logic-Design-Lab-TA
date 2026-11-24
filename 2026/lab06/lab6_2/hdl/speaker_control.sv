module speaker_control#(
    parameter DATA_NUM = 16,
    parameter COUNTER_BITS = 9,         // 2^9 = 512

    parameter MASTER_DIVIDER = 2,       // 25 = 100/4 (MHz)
    parameter LEFT_RIGHT_DIVIDER = 9,   // 25/128 = 100/512 (MHz)
    parameter SERIAL_DIVIDER = 4        // 25/128*32 = 100/32 (MHz)
)
(
    input logic f_crystal, // 100MHz
    input logic rst_n,
    input logic en,
    input logic [DATA_NUM-1:0] audio_in_left,
    input logic [DATA_NUM-1:0] audio_in_right,

    output logic audio_mclk, // 25MHz
    output logic audio_lrck, // 25/128 MHz
    output logic audio_sck,  // (25/128)*32MHz (right:16, left:16)
    output logic audio_sdin  // (25/128)*32MHz (right:16, left:16)
);
logic [COUNTER_BITS-1:0] freq_divider_n, freq_divider;
logic [$clog2(DATA_NUM)-1:0] data_counter, data_counter_n;
//logic [$clog2(DATA_NUM)-1:0] data_pointer;

//assign data_pointer = data_counter + 1; // delay one cycle since the MSB is at 2nd cycle

assign audio_mclk = freq_divider[MASTER_DIVIDER-1];  // 25 = 100/4 (MHz)
assign audio_lrck = freq_divider[LEFT_RIGHT_DIVIDER-1];  // 25/128 = 100/512 (MHz)
assign audio_sck  = freq_divider[SERIAL_DIVIDER-1];  // 25/128*32 = 100/32 (MHz)
assign audio_sdin = (audio_lrck) ? audio_in_left [data_counter] 
                                 : audio_in_right[data_counter];

//============ Friquency Divider ==============//
always_comb begin
    freq_divider_n = freq_divider;
    if (en) begin
        freq_divider_n = freq_divider + 1;
    end
end

always_ff @(posedge f_crystal or negedge rst_n) begin
    if (~rst_n) begin
        freq_divider <= '0;
    end
    else begin
        freq_divider <= freq_divider_n;
    end
end

//============ Parallel to Serial ==============//
always_comb begin
    data_counter_n = data_counter;
    if (en) begin
        data_counter_n = data_counter - 1;
    end
end

always_ff @(posedge audio_sck or negedge rst_n) begin
    if (~rst_n) begin
        data_counter <= '0;
    end
    else begin
        data_counter <= data_counter_n;
    end
end
endmodule