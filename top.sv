`include "pwm.sv"
`include "fade_R.sv"
`include "fade_G.sv"
`include "fade_B.sv"


module top #(
    parameter PWM_INTERVAL = 1200
)(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);
    
    logic [$clog2(PWM_interval) - 1:0] pwm_value_R, pwm_value_G, pwm_value_B;
    logic pwm_out_R;
    logic pwm_out_G;
    logic pwm_out_B;

    fade_R #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) u_R (
        .clk (clk),
        .pwm_value_R (pwm_value_R),
        .pwm_out_R (pwm_out_R)
    );

    fade_G #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) u_G (
        .clk (clk),
        .pwm_value_G (pwm_value_G),
        .pwm_out_G (pwm_out_G)
    );

    fade_B #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) u_B (
        .clk (clk),
        .pwm_value_B (pwm_value_B),
        .pwm_out_B (pwm_out_B)
    );

    assign RGB_R = ~pwm_out_R;
    assign RGB_G = ~pwm_out_G;
    assign RGB_B = ~pwm_out_B;

endmodule
    