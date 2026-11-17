`timescale 1ns / 1ps
`include "project_defs.vh"
// Owner A. Active checks cover RESET ONLY. Extend using docs/test_plan.md.
module tb_game_core;
    localparam CW = `COUNT_WIDTH;
    reg clk = 0;
    always #5 clk = ~clk;
    reg rst = 1, cmd_valid = 0;
    reg [2:0] cmd_kind = `CMD_CLEAR;
    reg [3:0] cmd_tile = 0;
    reg [35:0] cmd_board = 0;
    wire cmd_ready, init_error, move_error, undo_available;
    wire [35:0] board;
    wire [3:0] filled_count;
    wire [1:0] phase;
    wire [CW-1:0] valid_count, invalid_count;
    game_core #(.CW(CW)) dut(.*);

    // For A's future functional cases; times out instead of hanging on a stub.
    task automatic send_command(input [2:0] kind, input [3:0] tile, input [35:0] layout);
        integer cycles;
        begin
            @(negedge clk);
            cmd_valid = 1; cmd_kind = kind; cmd_tile = tile; cmd_board = layout;
            cycles = 0;
            @(posedge clk);
            while (!cmd_ready && cycles < 100) begin
                cycles = cycles + 1;
                @(posedge clk);
            end
            if (!cmd_ready) $fatal(1, "Command timed out: core is not implemented/ready");
            @(negedge clk); cmd_valid = 0;
        end
    endtask
    initial begin
        repeat (3) @(negedge clk);
        if ({board, filled_count, phase, init_error, move_error,
             valid_count, invalid_count, undo_available} !== '0)
            $fatal(1, "Core reset state mismatch");
        rst = 0;
        repeat (3) @(negedge clk);
        if (phase !== `PHASE_INIT || filled_count !== 0) $fatal(1, "Idle state mismatch");
        // TODO(A): initialization, movement, win, stats, undo, demo load cases.
        $display("PASS: tb_game_core (reset/idle only; gameplay NOT tested)");
        $finish;
    end
    initial begin #100000; $fatal(1, "Watchdog timeout"); end
endmodule
