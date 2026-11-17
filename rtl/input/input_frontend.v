`timescale 1ns / 1ps
`default_nettype none
// Owner C. SKELETON: raw inputs are intentionally not forwarded as pulses.
module input_frontend #(parameter CLK_HZ = 100_000_000, parameter DEBOUNCE_MS = 20)(
    input wire clk, input wire rst,
    input wire [3:0] tile_sw, input wire mode_sw,
    input wire [3:0] buttons,
    output wire [3:0] tile_value,
    output wire demo_mode, output wire mode_changed,
    output wire confirm_pulse, output wire view_pulse,
    output wire undo_pulse, output wire demo_step_pulse
);
    // buttons[0:3] = confirm, view, undo, demo step (active high).
    // TODO(C/C1): 2-FF synchronizers, stable-time debounce, press-edge pulses.
    // TODO(C/C1): stable switch sampling; preserve ALL values 0..15.
    // TODO(C/C2): stable mode and one-cycle mode_changed notification.
    assign tile_value = 4'd0;
    assign demo_mode = 1'b0;
    assign mode_changed = 1'b0;
    assign confirm_pulse = 1'b0;
    assign view_pulse = 1'b0;
    assign undo_pulse = 1'b0;
    assign demo_step_pulse = 1'b0;
endmodule
`default_nettype wire
