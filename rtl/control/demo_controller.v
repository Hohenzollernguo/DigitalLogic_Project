`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none
// Owner C. SKELETON: no sequence has been implemented.
module demo_controller(
    input wire clk, input wire rst,
    input wire demo_mode, input wire sequence_reset, input wire step_pulse,
    output wire demo_valid, input wire demo_ready,
    output wire [2:0] demo_kind, output wire [3:0] demo_tile,
    output wire [35:0] demo_board, output wire demo_blank
);
    // TODO(C/F16): LOAD(123456708), CONFIRM(1), CONFIRM(8), CONFIRM, CLEAR.
    // Entry auto-loads the first scene; later scenes advance per button press.
    // Hold valid/payload until handshake; advance on handshake, not on press.
    // After final CLEAR is accepted, assert demo_blank until restart/reset.
    assign demo_valid = 1'b0;
    assign demo_kind = `CMD_CLEAR;
    assign demo_tile = 4'd0;
    assign demo_board = `DEMO_BOARD;
    assign demo_blank = 1'b0;
endmodule
`default_nettype wire
