module note_gen#(
    parameter DATA_NUM = 16,
    parameter NOTE_BIT = 22,
    parameter BCD_BIT = 4
)( 
    input logic clk,                            // clock from crystal
    input logic rst_n,                          // active low reset
    input logic [NOTE_BIT-1:0] note_div,        // div for note generation
    input logic [BCD_BIT-1:0]  audio_volume,

    output logic [DATA_NUM-1:0] audio_left,     // left sound audio
    output logic [DATA_NUM-1:0] audio_right     // right sound audio
);
//============ Declare internal signals ==============//
logic [21:0] clk_cnt_next, clk_cnt;
logic b_clk, b_clk_next; // Note frequency generation

//============ Note Generator (Determine the frequency) ==============//
always_comb begin
    if (clk_cnt == note_div) begin
        clk_cnt_next = 22'd0;
        b_clk_next = ~b_clk;
    end else begin
        clk_cnt_next = clk_cnt + 1'b1;
        b_clk_next = b_clk;
    end
end

always_ff @(posedge clk or negedge rst_n)
if (~rst_n) begin
    clk_cnt <= 22'd0;
    b_clk <= 1'b0;
end else begin
    clk_cnt <= clk_cnt_next;
    b_clk <= b_clk_next;
end

//============ Assign the amplitude of the note ==============//
logic [DATA_NUM-1:0] p_peak,n_peak;

assign audio_left = (b_clk == 1'b0) ? n_peak : p_peak;
assign audio_right = (b_clk == 1'b0) ? n_peak : p_peak;

always_comb begin
    p_peak = 16'h0000; n_peak = 16'h0000;
    case (audio_volume)
        4'd0 : begin p_peak = 16'h0000; n_peak = 16'h0000; end
        4'd1 : begin p_peak = 16'h0100; n_peak = 16'hFF00; end
        4'd2 : begin p_peak = 16'h0180; n_peak = 16'hFE80; end
        4'd3 : begin p_peak = 16'h0240; n_peak = 16'hFDC0; end
        4'd4 : begin p_peak = 16'h0360; n_peak = 16'hFCA0; end
        4'd5 : begin p_peak = 16'h0510; n_peak = 16'hFAF0; end
        4'd6 : begin p_peak = 16'h0790; n_peak = 16'hF870; end
        4'd7 : begin p_peak = 16'h0B60; n_peak = 16'hF4A0; end
        4'd8 : begin p_peak = 16'h1100; n_peak = 16'hEF00; end
        4'd9 : begin p_peak = 16'h1900; n_peak = 16'hE700; end
        4'd10: begin p_peak = 16'h2500; n_peak = 16'hDB00; end
        4'd11: begin p_peak = 16'h3000; n_peak = 16'hD000; end
        4'd12: begin p_peak = 16'h3D00; n_peak = 16'hC300; end
        4'd13: begin p_peak = 16'h4A00; n_peak = 16'hB600; end
        4'd14: begin p_peak = 16'h5400; n_peak = 16'hAC00; end
        4'd15: begin p_peak = 16'h5FFF; n_peak = 16'hB000; end
    endcase
end

endmodule