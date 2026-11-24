
module FSM #(
    parameter STATE_BIT = 2
)(
    input logic clk,
    input logic rst_n,
    input logic start_pause,
    input logic reset,
    input logic BCD_all_zero,

    output logic minus_one,
    output logic load_inital
);

typedef enum logic [STATE_BIT-1:0]{ 
    IDLE        = STATE_BIT'(0),
    COUNTTING   = STATE_BIT'(1),
    PAUSE       = STATE_BIT'(2),
    DONE        = STATE_BIT'(3)
} FSM_state;

FSM_state state, state_n;

always_comb begin : FSM
    state_n = (reset) ? IDLE : state;
    minus_one = '0;
    load_inital = '0;
    unique case (state)
        IDLE: begin
            load_inital = '1;
            if(start_pause) begin
                state_n = COUNTTING;
            end
        end
        COUNTTING: begin
            minus_one = '1;
            if (BCD_all_zero) begin
                state_n = DONE;
            end
            else if (start_pause) begin
                state_n = PAUSE;
            end
        end
        PAUSE: begin
            if (start_pause) begin
                state_n = COUNTTING;
            end
        end
        DONE: begin
            // do nothing and wait reset
        end
    endcase
end

always_ff @(posedge clk ) begin : FF
    if (~rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= state_n;
    end
end
endmodule