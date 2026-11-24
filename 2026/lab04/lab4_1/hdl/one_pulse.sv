module one_pulse(
  input logic clk,
  input logic rst_n,
  input logic in_trig,
  
  output logic out_pulse
);

logic in_debounced;

debounce_circuit U0(.clk(clk), .rst_n(rst_n), .pb_in(in_trig), .pb_debounced(in_debounced));

// internal registers
logic out_next;
logic in_debounced_delay;

always_comb begin
  out_next = in_debounced & ~in_debounced_delay;
end


always_ff @(posedge clk) begin
  if (~rst_n) begin
    out_pulse <= 1'b0; 
    in_debounced_delay <= 1'b0; 
  end 
  else begin
    out_pulse <= out_next;
    in_debounced_delay <= in_debounced;
  end
end


endmodule