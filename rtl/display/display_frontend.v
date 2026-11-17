`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none
// Owner B. SKELETON: display selection exists; content remains blank.
module display_frontend #(parameter CW = `COUNT_WIDTH)(
    input wire clk, input wire rst,
    input wire [35:0] board, input wire [3:0] filled_count,
    input wire [1:0] phase, input wire init_error, input wire move_error,
    input wire [CW-1:0] valid_count, input wire [CW-1:0] invalid_count,
    input wire [7:0] hint_mask,
    input wire view_toggle, input wire view_reset, input wire view_default_hint,
    input wire demo_mode, input wire advanced_active, input wire output_blank,
    output wire [31:0] symbols,
    output wire [7:0] info_leds, output wire [3:0] tile9_leds,
    output wire advanced_led, output wire game_led,
    output wire demo_led, output wire status_led
);
    reg show_hint;
    always @(posedge clk) begin
        if (rst)             show_hint <= 1'b0;
        else if (view_reset) show_hint <= view_default_hint;
        else if (view_toggle) show_hint <= ~show_hint;
    end
    // TODO(B/F04-F06): first eight cells, partial init, E, tile9 LEDs.
    // TODO(B/F11,F13): hint/count mux, decimal counts at positions 0,1,6,7.
    // TODO(B/F17): mode lamps, invalid blink, WON/STATS solid status.
    // output_blank must override EVERY output including mode/status lamps.
    assign symbols = {8{`SYMBOL_BLANK}};
    assign info_leds = 8'b0;
    assign tile9_leds = 4'b0;
    assign advanced_led = 1'b0;
    assign game_led = 1'b0;
    assign demo_led = 1'b0;
    assign status_led = 1'b0;
endmodule
`default_nettype wire
