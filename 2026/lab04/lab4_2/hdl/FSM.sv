
module FSM #(
    parameter STATE_BIT = 2
)(
    input logic clk,
    input logic rst_n,
    input logic start_pause,
    input logic lap_reset,

    output logic add_one,
    output logic load_inital,
    output logic freeze
);

typedef enum logic [STATE_BIT-1:0]{ 
    IDLE        = STATE_BIT'(0),
    COUNTTING   = STATE_BIT'(1),
    PAUSE       = STATE_BIT'(2),
    FREEZE      = STATE_BIT'(3)
} FSM_state;

FSM_state state, state_n;

always_comb begin 
    state_n = state;
    add_one = '0;
    freeze = '0;
    load_inital = '0;
    case (state)
        IDLE: begin
            load_inital = '1;
            if (start_pause) begin
                state_n = COUNTTING;
            end
        end 
        COUNTTING: begin
            add_one = '1;
            if (start_pause) begin
                state_n = PAUSE;
            end
            else if(lap_reset) begin
                state_n = FREEZE;
            end
            
        end
        PAUSE: begin
            if (start_pause) begin
                state_n = COUNTTING;
            end
            else if(lap_reset) begin
                state_n = IDLE;
            end
        end
        FREEZE: begin
            add_one = '1;
            freeze = '1;
            if (lap_reset) begin
                state_n = COUNTTING;
            end
        end
    endcase
end

always_ff @(posedge clk) begin : FF
    if (~rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= state_n;
    end
end

endmodule