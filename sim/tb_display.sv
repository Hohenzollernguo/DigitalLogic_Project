`timescale 1ns / 1ps
`include "project_defs.vh"
// Owner B. Direct state injection, independent of core.
module tb_display;
    localparam CW = `COUNT_WIDTH;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1;
    reg [35:0] board = `DEMO_BOARD;
    reg [3:0] filled_count = 9;
    reg [1:0] phase = `PHASE_PLAY;
    reg init_error = 0, move_error = 0;
    reg [CW-1:0] valid_count = 0, invalid_count = 0;
    reg view_toggle = 0, view_reset = 0, view_default_hint = 0;
    reg demo_mode = 1, advanced_active = 0, output_blank = 1;
    wire [7:0] hint_mask, info_leds;
    wire [3:0] tile9_leds;
    wire [31:0] symbols;
    wire advanced_led, game_led, demo_led, status_led;
    wire [7:0] seg_cs_pin, seg_data_0_pin, seg_data_1_pin;
    hint_logic hints(.board(board), .filled_count(filled_count), .hint_mask(hint_mask));
    display_frontend #(.CW(CW)) dut(.*);
    seg_scan scan(.clk(clk), .rst(rst), .output_blank(output_blank), .symbols(symbols),
        .seg_cs_pin(seg_cs_pin), .seg_data_0_pin(seg_data_0_pin), .seg_data_1_pin(seg_data_1_pin));
    initial begin
        repeat (3) @(negedge clk); rst = 0;
        repeat (3) @(negedge clk);
        if ({info_leds, tile9_leds, advanced_led, game_led, demo_led, status_led,
             seg_cs_pin, seg_data_0_pin, seg_data_1_pin} !== '0)
            $fatal(1, "Blank override must disable all outputs");
        // TODO(B): remove blank; test 00001011 hints, E, digits, stats, scan.
        $display("PASS: tb_display (blank override only; rendering NOT tested)");
        $finish;
    end
    initial begin #100000; $fatal(1, "Watchdog timeout"); end
endmodule
