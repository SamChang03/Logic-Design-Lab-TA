`timescale 1ns/1ps
module test_lab6_1();

localparam CYCLE = 2;
localparam DATA_NUM = 16;

logic f_crystal,rst_n,en;
logic [DATA_NUM-1:0] audio_in_left, audio_in_right;

logic audio_mclk, audio_lrck, audio_sck, audio_sdin;

//====================== DUT ===========================//
lab6_1 u_speaker_countroller(
    .f_crystal(f_crystal),.rst_n(rst_n),.en(en),
    .audio_in_left(audio_in_left), .audio_in_right(audio_in_right),

    .audio_mclk(audio_mclk),.audio_lrck(audio_lrck),
    .audio_sck(audio_sck), .audio_sdin(audio_sdin)
);

//====================== Main ===========================//
always
    #(CYCLE/2) f_crystal = ~f_crystal;

initial begin
    f_crystal = 0; rst_n = 0; en = 0;
    audio_in_left = 16'hB000; audio_in_right = 16'hB000;

    # (CYCLE) rst_n = 1; en = 1;
    # (CYCLE*(2**10)) audio_in_left = 16'h5FFF; audio_in_right = 16'h5FFF;
end

initial begin
    # (CYCLE*(2**12)) $finish;
end


endmodule