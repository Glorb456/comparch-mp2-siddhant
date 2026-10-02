module fade_B #(
    parameter INC_DEC_INTERVAL = 12000,
    parameter INC_DEC_MAX = 200,
    parameter PWM_INTERVAL = 1200,
    parameter INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX
)(
    input logic clk,
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_G
);

    localparam PWM_INC = 1'b0;
    localparam PWM_DEC = 1'b1; 

    logic current_state = PWM_INC;
    logic next_state;

    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;
    logic time_to_transition = 1'b0;

    initial begin
        pwm_value_G = 0;
    end 

    always_ff@(posedge time_to_transition)
        current_state <= next_state;

    always_comb begin
        next_state = 1'bx;
        case(current_state) 
            PWM_INC:
                next_state = PWM_DEC;
            PWM_DEC:
                next_state = PWM_INC;
        endcase

    end 

    always_ff @(posedge clk) begin
        if(count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end 
        else begin
            count <= count + 1; 
            time_to_inc_dec <= 1'b0;
        end 


    end 

    always_ff @(posedge time_to_inc_dec) begin
        case (current_state)
            PWM_INC:
                pwm_value_G <= pwm_value_G + INC_DEC_VAL;
            PWM_DEC:
                pwm_value_G <= pwm_value_G - INC_DEC_VAL;
        endcase 
    end

    always_ff @(posedge time_to_inc_dec) begin
        if (inc_dec_count == INC_DEC_MAX - 1) begin
            inc_dec_count <= 0; 
            time_to_transition <= 1'b1; 
        end 
        else begin
            inc_dec_count <= inc_dec_count + 1; 
            time_to_transition <= 1'b0;
        end 
    end 


endmodule
