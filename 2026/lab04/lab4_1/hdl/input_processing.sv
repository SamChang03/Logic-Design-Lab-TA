module input_processing

(
    input logic clk,
    input logic rst_n,
    // input logic input_buttom_C_raw,
    // input logic input_buttom_B_raw, 
    // input logic input_buttom_U_raw, 
    input logic input_buttom_R_raw,
    input logic input_buttom_L_raw,

    // output logic  input_buttom_C,
    // output logic  input_buttom_B, 
    // output logic  input_buttom_U, 
    output logic  input_buttom_R,
    output logic  input_buttom_L
);

one_pulse U_op_buttom_L
(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(input_buttom_L_raw), // input trigger
  .out_pulse(input_buttom_L) // output one pulse 
);

one_pulse U_op_buttom_R
(
  .clk(clk),  // clock input
  .rst_n(rst_n), //active low reset
  .in_trig(input_buttom_R_raw), // input trigger
  .out_pulse(input_buttom_R) // output one pulse 
);

// one_pulse U_op_buttom_U
// (
//   .clk(clk),  // clock input
//   .rst_n(rst_n), //active low reset
//   .in_trig(input_buttom_U_raw), // input trigger
//   .out_pulse(input_buttom_U) // output one pulse 
// );

// one_pulse U_op_buttom_B
// (
//   .clk(clk),  // clock input
//   .rst_n(rst_n), //active low reset
//   .in_trig(input_buttom_B_raw), // input trigger
//   .out_pulse(input_buttom_B) // output one pulse 
// );

// one_pulse U_op_buttom_C
// (
//   .clk(clk),  // clock input
//   .rst_n(rst_n), //active low reset
//   .in_trig(input_buttom_C_raw), // input trigger
//   .out_pulse(input_buttom_C) // output one pulse 
// );

endmodule