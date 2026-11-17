`timescale 1ns / 1ps
// Owner C. Driver fixture independent of game_core. Add a stalled mock receiver.
module tb_control;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1;
    reg [3:0] tile_sw = 0, buttons = 0;
    reg mode_sw = 0, cmd_ready = 0;
    wire [3:0] tile_value;
    wire demo_mode, mode_changed, confirm_pulse, view_pulse, undo_pulse, demo_step_pulse;
    wire demo_valid, demo_ready, demo_blank, sequence_reset;
    wire [2:0] demo_kind, cmd_kind;
    wire [3:0] demo_tile, cmd_tile;
    wire [35:0] demo_board, cmd_board;
    wire cmd_valid, view_toggle, view_reset, view_default_hint, output_blank;
    input_frontend #(.CLK_HZ(1000), .DEBOUNCE_MS(2)) front(.*);
    demo_controller demo(.step_pulse(demo_step_pulse), .*);
    command_router router(.*);
    initial begin
        repeat (3) @(negedge clk);
        if (cmd_valid !== 0 || demo_valid !== 0) $fatal(1, "Spurious command in reset");
        rst = 0;
        repeat (3) @(negedge clk);
        if (cmd_valid !== 0 || confirm_pulse !== 0) $fatal(1, "Spurious idle command");
        // TODO(C): bouncing/held keys, mode transitions, ready=0 backpressure,
        // payload stability, one acceptance per press, complete five-scene demo.
        $display("PASS: tb_control (reset/idle only; input/demo NOT tested)");
        $finish;
    end
    initial begin #100000; $fatal(1, "Watchdog timeout"); end
endmodule
