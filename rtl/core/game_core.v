`timescale 1ns / 1ps
`include "project_defs.vh"
`default_nettype none

// Owner A. Owns the board, game phase, counters, errors, and one-step history.
// A command is accepted on a rising edge when cmd_valid && cmd_ready is high.
module game_core #(parameter CW = `COUNT_WIDTH)(
    input wire clk,
    input wire rst,
    input wire cmd_valid,
    output wire cmd_ready,
    input wire [2:0] cmd_kind,
    input wire [3:0] cmd_tile,
    input wire [35:0] cmd_board,
    output reg [35:0] board,
    output reg [3:0] filled_count,
    output reg [1:0] phase,
    output reg init_error,
    output reg move_error,
    output reg [CW-1:0] valid_count,
    output reg [CW-1:0] invalid_count,
    output reg undo_available
);
    // The core has no internal wait states. The router must still hold a
    // request and its payload stable until the accepting clock edge.
    assign cmd_ready = 1'b1;

    reg [35:0] history_board;
    reg [CW-1:0] history_valid_count;
    reg [CW-1:0] history_invalid_count;
    reg [1:0] history_phase;
    reg history_init_error;
    reg history_move_error;

    reg [35:0] updated_board;
    reg [8:0] seen_tiles;
    reg [3:0] board_tile;
    integer scan_index;
    integer blank_index;
    integer selected_index;

    // Search only confirmed initialization cells. This keeps an entered zero
    // distinct from an unfilled cell, as required by the interface contract.
    function board_contains_tile;
        input [35:0] layout;
        input [3:0] tile;
        input [3:0] used_cells;
        integer cell_index;
        begin
            board_contains_tile = 1'b0;
            for (cell_index = 0; cell_index < 9; cell_index = cell_index + 1) begin
                if ((cell_index < used_cells) &&
                    (layout[35 - (cell_index * 4) -: 4] == tile))
                    board_contains_tile = 1'b1;
            end
        end
    endfunction

    // LOAD_DEMO is an internal full-board command. Reject malformed payloads
    // instead of allowing duplicate or out-of-range tiles into PLAY.
    function valid_complete_board;
        input [35:0] layout;
        integer cell_index;
        reg [3:0] tile;
        reg [8:0] seen;
        begin
            seen = 9'b0;
            valid_complete_board = 1'b1;
            for (cell_index = 0; cell_index < 9; cell_index = cell_index + 1) begin
                tile = layout[35 - (cell_index * 4) -: 4];
                if (tile > 4'd8) begin
                    valid_complete_board = 1'b0;
                end else if (seen[tile]) begin
                    valid_complete_board = 1'b0;
                end else begin
                    seen[tile] = 1'b1;
                end
            end
        end
    endfunction

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

            history_board <= 36'd0;
            history_valid_count <= {CW{1'b0}};
            history_invalid_count <= {CW{1'b0}};
            history_phase <= `PHASE_INIT;
            history_init_error <= 1'b0;
            history_move_error <= 1'b0;
        end else if (cmd_valid && cmd_ready) begin
            case (cmd_kind)
                `CMD_CLEAR: begin
                    board <= 36'd0;
                    filled_count <= 4'd0;
                    phase <= `PHASE_INIT;
                    init_error <= 1'b0;
                    move_error <= 1'b0;
                    valid_count <= {CW{1'b0}};
                    invalid_count <= {CW{1'b0}};
                    undo_available <= 1'b0;
                end

                `CMD_CONFIRM: begin
                    if (phase == `PHASE_INIT) begin
                        if ((cmd_tile > 4'd8) ||
                            board_contains_tile(board, cmd_tile, filled_count)) begin
                            // Invalid initialization does not consume a cell
                            // and does not count as a gameplay move.
                            init_error <= 1'b1;
                            move_error <= 1'b0;
                        end else if (filled_count < 4'd9) begin
                            updated_board = board;
                            updated_board[35 - (filled_count * 4) -: 4] = cmd_tile;
                            board <= updated_board;
                            filled_count <= filled_count + 1'b1;
                            init_error <= 1'b0;
                            move_error <= 1'b0;
                            if (filled_count == 4'd8) begin
                                if (updated_board == `SOLVED_BOARD)
                                    phase <= `PHASE_WON;
                                else
                                    phase <= `PHASE_PLAY;
                            end
                        end
                    end else if (phase == `PHASE_PLAY) begin
                        // Every attempted move replaces the one-level history,
                        // including an invalid attempt, so UNDO restores both
                        // the board and the matching statistics/error state.
                        history_board <= board;
                        history_valid_count <= valid_count;
                        history_invalid_count <= invalid_count;
                        history_phase <= phase;
                        history_init_error <= init_error;
                        history_move_error <= move_error;
                        undo_available <= 1'b1;
                        init_error <= 1'b0;

                        blank_index = -1;
                        selected_index = -1;
                        for (scan_index = 0; scan_index < 9; scan_index = scan_index + 1) begin
                            board_tile = board[35 - (scan_index * 4) -: 4];
                            if (board_tile == 4'd0)
                                blank_index = scan_index;
                            if ((cmd_tile <= 4'd8) && (board_tile == cmd_tile))
                                selected_index = scan_index;
                        end

                        if ((cmd_tile != 4'd0) && (cmd_tile <= 4'd8) &&
                            (blank_index >= 0) && (selected_index >= 0) &&
                            (((blank_index - selected_index == 1) &&
                              (blank_index / 3 == selected_index / 3)) ||
                             (blank_index - selected_index == -1 &&
                              (blank_index / 3 == selected_index / 3)) ||
                             (blank_index - selected_index == 3) ||
                             (blank_index - selected_index == -3))) begin
                            updated_board = board;
                            updated_board[35 - (blank_index * 4) -: 4] = cmd_tile;
                            updated_board[35 - (selected_index * 4) -: 4] = 4'd0;
                            board <= updated_board;
                            valid_count <= valid_count + 1'b1;
                            move_error <= 1'b0;
                            if (updated_board == `SOLVED_BOARD)
                                phase <= `PHASE_WON;
                        end else begin
                            invalid_count <= invalid_count + 1'b1;
                            move_error <= 1'b1;
                        end
                    end else if (phase == `PHASE_WON) begin
                        // The first confirmation after winning opens the
                        // statistics view. The board itself remains intact.
                        phase <= `PHASE_STATS;
                    end
                end

                `CMD_UNDO: begin
                    if ((phase == `PHASE_PLAY) && undo_available) begin
                        board <= history_board;
                        valid_count <= history_valid_count;
                        invalid_count <= history_invalid_count;
                        phase <= history_phase;
                        init_error <= history_init_error;
                        move_error <= history_move_error;
                        undo_available <= 1'b0;
                    end
                end

                `CMD_LOAD_DEMO: begin
                    if (valid_complete_board(cmd_board)) begin
                        board <= cmd_board;
                        filled_count <= 4'd9;
                        valid_count <= {CW{1'b0}};
                        invalid_count <= {CW{1'b0}};
                        init_error <= 1'b0;
                        move_error <= 1'b0;
                        undo_available <= 1'b0;
                        if (cmd_board == `SOLVED_BOARD)
                            phase <= `PHASE_WON;
                        else
                            phase <= `PHASE_PLAY;
                    end else begin
                        // Keep the core in a clean initialization state if a
                        // malformed demo payload reaches this interface.
                        board <= 36'd0;
                        filled_count <= 4'd0;
                        phase <= `PHASE_INIT;
                        valid_count <= {CW{1'b0}};
                        invalid_count <= {CW{1'b0}};
                        init_error <= 1'b1;
                        move_error <= 1'b0;
                        undo_available <= 1'b0;
                    end
                end

                default: begin
                    // Reserved command kinds are accepted and ignored.
                end
            endcase
        end
    end
endmodule

`default_nettype wire
