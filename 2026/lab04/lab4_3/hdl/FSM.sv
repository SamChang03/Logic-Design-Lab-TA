
module FSM #(
    parameter STATE_BIT = 3
)(
    input logic clk,
    input logic rst_n,
    input logic setting,
    input logic start_stop,
    input logic pause_resume,
    input logic BCD_all_zero,

    output logic minus_one,
    output logic load_inital
    
);

typedef enum logic [STATE_BIT-1:0]{ 
    IDLE        = STATE_BIT'(0),
    COUNTTING   = STATE_BIT'(1),
    PAUSE       = STATE_BIT'(2),
    STOP        = STATE_BIT'(3),
    DONE        = STATE_BIT'(4),
    SETTING     = STATE_BIT'(5)
} FSM_state;

FSM_state state, state_n;

always_comb begin : FSM
    state_n = (setting) ? SETTING :state;
    minus_one = '0;
    load_inital = '0;
    case (state)
        IDLE: begin
            if(start_stop) begin
                state_n = COUNTTING;
            end
        end
        COUNTTING: begin
            minus_one = '1;
            if (BCD_all_zero) begin
                state_n = DONE;
            end
            else if (pause_resume) begin
                state_n = PAUSE;
            end
            else if (start_stop) begin
                state_n = STOP;
            end
        end
        PAUSE: begin
            if (pause_resume) begin
                state_n = COUNTTING;
            end
        end
        STOP: begin
            if (start_stop) begin
                state_n = DONE;
            end
        end
        DONE: begin
            load_inital = '1;
            // do nothing and wait setting or golbal reset
        end
        SETTING: begin
            load_inital = '1;
            if (~setting) begin
                state_n = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk ) begin : FF
    if (~rst_n) begin
        state <= SETTING;
    end
    else begin
        state <= state_n;
    end
end
endmodule