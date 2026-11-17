`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none
// Owner C. Wiring is implemented; connected functional modules are shells.
module top #(
    parameter CLK_HZ = 100_000_000,
    parameter CW = `COUNT_WIDTH,
    parameter RESET_ACTIVE_LOW = 1 // Provisional; confirm S6 polarity on board.
)(
    input wire sys_clk_in, input wire reset_pin,
    input wire [3:0] tile_sw, input wire mode_sw,
    input wire [3:0] btn_pin,
    output wire [15:0] led_pin,
    output wire [7:0] seg_cs_pin,
    output wire [7:0] seg_data_0_pin, output wire [7:0] seg_data_1_pin
);
    wire rst;
    wire async_rst = RESET_ACTIVE_LOW ? ~reset_pin : reset_pin;
    reset_sync u_reset(.clk(sys_clk_in), .async_rst(async_rst), .rst(rst));

    wire [3:0] tile_value;
    wire demo_mode, mode_changed, confirm_pulse, view_pulse, undo_pulse, step_pulse;
    input_frontend #(.CLK_HZ(CLK_HZ)) u_input(
        .clk(sys_clk_in), .rst(rst), .tile_sw(tile_sw), .mode_sw(mode_sw),
        .buttons(btn_pin), .tile_value(tile_value), .demo_mode(demo_mode),
        .mode_changed(mode_changed), .confirm_pulse(confirm_pulse),
        .view_pulse(view_pulse), .undo_pulse(undo_pulse), .demo_step_pulse(step_pulse)
    );

    wire demo_valid, demo_ready, demo_blank, sequence_reset;
    wire [2:0] demo_kind;
    wire [3:0] demo_tile;
    wire [35:0] demo_board;
    demo_controller u_demo(
        .clk(sys_clk_in), .rst(rst), .demo_mode(demo_mode),
        .sequence_reset(sequence_reset), .step_pulse(step_pulse),
        .demo_valid(demo_valid), .demo_ready(demo_ready), .demo_kind(demo_kind),
        .demo_tile(demo_tile), .demo_board(demo_board), .demo_blank(demo_blank)
    );

    wire cmd_valid, cmd_ready, view_toggle, view_reset, view_default_hint, output_blank;
    wire [2:0] cmd_kind;
    wire [3:0] cmd_tile;
    wire [35:0] cmd_board;
    command_router u_router(
        .clk(sys_clk_in), .rst(rst), .demo_mode(demo_mode), .mode_changed(mode_changed),
        .tile_value(tile_value), .confirm_pulse(confirm_pulse), .undo_pulse(undo_pulse),
        .view_pulse(view_pulse), .demo_valid(demo_valid), .demo_ready(demo_ready),
        .demo_kind(demo_kind), .demo_tile(demo_tile), .demo_board(demo_board),
        .demo_blank(demo_blank), .sequence_reset(sequence_reset),
        .cmd_valid(cmd_valid), .cmd_ready(cmd_ready), .cmd_kind(cmd_kind),
        .cmd_tile(cmd_tile), .cmd_board(cmd_board), .view_toggle(view_toggle),
        .view_reset(view_reset), .view_default_hint(view_default_hint), .output_blank(output_blank)
    );

    wire [35:0] board;
    wire [3:0] filled_count;
    wire [1:0] phase;
    wire init_error, move_error, undo_available;
    wire [CW-1:0] valid_count, invalid_count;
    game_core #(.CW(CW)) u_core(
        .clk(sys_clk_in), .rst(rst), .cmd_valid(cmd_valid), .cmd_ready(cmd_ready),
        .cmd_kind(cmd_kind), .cmd_tile(cmd_tile), .cmd_board(cmd_board),
        .board(board), .filled_count(filled_count), .phase(phase),
        .init_error(init_error), .move_error(move_error),
        .valid_count(valid_count), .invalid_count(invalid_count), .undo_available(undo_available)
    );

    wire [7:0] hint_mask;
    hint_logic u_hint(.board(board), .filled_count(filled_count), .hint_mask(hint_mask));
    wire [31:0] symbols;
    wire [7:0] info_leds;
    wire [3:0] tile9_leds;
    wire advanced_led, game_led, demo_led, status_led;
    display_frontend #(.CW(CW)) u_display(
        .clk(sys_clk_in), .rst(rst), .board(board), .filled_count(filled_count),
        .phase(phase), .init_error(init_error), .move_error(move_error),
        .valid_count(valid_count), .invalid_count(invalid_count), .hint_mask(hint_mask),
        .view_toggle(view_toggle), .view_reset(view_reset), .view_default_hint(view_default_hint),
        .demo_mode(demo_mode), .advanced_active(1'b0), .output_blank(output_blank),
        .symbols(symbols), .info_leds(info_leds), .tile9_leds(tile9_leds),
        .advanced_led(advanced_led), .game_led(game_led), .demo_led(demo_led), .status_led(status_led)
    );
    seg_scan #(.CLK_HZ(CLK_HZ)) u_scan(
        .clk(sys_clk_in), .rst(rst), .output_blank(output_blank), .symbols(symbols),
        .seg_cs_pin(seg_cs_pin), .seg_data_0_pin(seg_data_0_pin), .seg_data_1_pin(seg_data_1_pin)
    );

    // Physical sample XDC indices increase LEFT to RIGHT for these LED groups.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : g_info
            assign led_pin[i] = output_blank ? 1'b0 : info_leds[7-i];
        end
        for (i = 0; i < 4; i = i + 1) begin : g_tile9
            assign led_pin[8+i] = output_blank ? 1'b0 : tile9_leds[3-i];
        end
    endgenerate
    assign led_pin[12] = output_blank ? 1'b0 : advanced_led;
    assign led_pin[13] = output_blank ? 1'b0 : game_led;
    assign led_pin[14] = output_blank ? 1'b0 : demo_led;
    assign led_pin[15] = output_blank ? 1'b0 : status_led;
endmodule
`default_nettype wire
