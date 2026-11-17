`timescale 1ns / 1ps
`default_nettype none
// Owner B. SKELETON: hints disabled until implemented.
module hint_logic(
    input wire [35:0] board, input wire [3:0] filled_count,
    output wire [7:0] hint_mask
);
    // TODO(B/F10): find zero, enumerate orthogonal neighbours, map TILE IDs.
    // bit7 = tile 1; bit0 = tile 8. Incomplete board => zero mask.
    assign hint_mask = 8'b0;
endmodule
`default_nettype wire
