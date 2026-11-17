`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none
// Owner A. SKELETON: reset state only, no game commands accepted yet.
module game_core #(parameter CW = `COUNT_WIDTH)(
    input wire clk, input wire rst,
    input wire cmd_valid, output wire cmd_ready,
    input wire [2:0] cmd_kind, input wire [3:0] cmd_tile,
    input wire [35:0] cmd_board,
    output reg [35:0] board, output reg [3:0] filled_count,
    output reg [1:0] phase,
    output reg init_error, output reg move_error,
    output reg [CW-1:0] valid_count, output reg [CW-1:0] invalid_count,
    output reg undo_available
);
    // TODO(A): replace tie-off with real command acceptance logic.
    // Keeping ready low prevents the shell from pretending to execute commands.
    assign cmd_ready = 1'b0;
    always @(posedge clk) begin
        if (rst) begin
            board <= 36'd0;
            filled_count <= 4'd0;
            phase <= `PHASE_INIT;
            init_error <= 1'b0;
            move_error <= 1'b0;
            valid_count <= {CW{1'b0}};
            invalid_count <= {CW{1'b0}};
            undo_available <= 1'b0;
        end
        // TODO(A/F01-F03): CLEAR, sequential init, range/duplicate checks.
        // TODO(A/F07-F09): tile lookup, Manhattan adjacency, swap and counters.
        // TODO(A/F12-F14): WON -> STATS, one pre-move snapshot, UNDO.
        // TODO(A/F16): LOAD_DEMO clears counts/history and checks victory.
        // All command actions must be gated by cmd_valid && cmd_ready.
    end
endmodule
`default_nettype wire
