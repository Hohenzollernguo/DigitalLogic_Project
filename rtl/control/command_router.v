`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none
// Owner C. SKELETON: arbitration/queues are pending; all requests disabled.
module command_router(
    input wire clk, input wire rst,
    input wire demo_mode, input wire mode_changed,
    input wire [3:0] tile_value,
    input wire confirm_pulse, input wire undo_pulse, input wire view_pulse,
    input wire demo_valid, output wire demo_ready,
    input wire [2:0] demo_kind, input wire [3:0] demo_tile,
    input wire [35:0] demo_board, input wire demo_blank,
    output wire sequence_reset,
    output wire cmd_valid, input wire cmd_ready,
    output wire [2:0] cmd_kind, output wire [3:0] cmd_tile,
    output wire [35:0] cmd_board,
    output wire view_toggle, output wire view_reset,
    output wire view_default_hint, output wire output_blank
);
    // TODO(C/C2): reset > mode CLEAR > undo > confirm/demo arbitration.
    // Snapshot tile_value on event; retain command until accepted by core.
    // Mode change: finish any already-presented command, then CLEAR before
    // enabling new-mode commands; reset alone may cancel a presented command.
    // sequence_reset cancels the demo source; view_reset seeds its view.
    assign demo_ready = 1'b0;
    assign sequence_reset = rst;
    assign cmd_valid = 1'b0;
    assign cmd_kind = `CMD_CLEAR;
    assign cmd_tile = 4'd0;
    assign cmd_board = 36'd0;
    assign view_toggle = 1'b0;
    assign view_reset = rst;
    assign view_default_hint = 1'b0;
    // Keep hardware dark while this is a skeleton.
    assign output_blank = 1'b1;
endmodule
`default_nettype wire
