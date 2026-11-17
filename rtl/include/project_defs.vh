`ifndef PROJECT_DEFS_VH
`define PROJECT_DEFS_VH
// Shared contract v0.1. Change together with docs/interfaces.md.
`define CMD_CLEAR     3'd0
`define CMD_CONFIRM   3'd1
`define CMD_UNDO      3'd2
`define CMD_LOAD_DEMO 3'd3
`define PHASE_INIT    2'd0
`define PHASE_PLAY    2'd1
`define PHASE_WON     2'd2
`define PHASE_STATS   2'd3
`define SOLVED_BOARD  36'h123456780
`define DEMO_BOARD    36'h123456708
// Interface default only; overflow policy is NOT decided by this width.
`define COUNT_WIDTH   4
// Each display symbol is a nibble. Numeric 0 is distinct from blank.
`define SYMBOL_E      4'hE
`define SYMBOL_BLANK  4'hF
`endif
