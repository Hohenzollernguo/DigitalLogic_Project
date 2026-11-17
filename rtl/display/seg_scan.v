`timescale 1ns / 1ps
`default_nettype none
// Owner B. SKELETON: all physical digit and segment outputs disabled.
module seg_scan #(parameter CLK_HZ = 100_000_000, parameter SCAN_HZ = 1000)(
    input wire clk, input wire rst, input wire output_blank,
    input wire [31:0] symbols,
    output wire [7:0] seg_cs_pin,
    output wire [7:0] seg_data_0_pin, output wire [7:0] seg_data_1_pin
);
    // TODO(B/B1): clock-enable scanning, high-active digit/segment outputs.
    // symbols[31:28] is leftmost; segment bits [7:0] = {dp,g,f,e,d,c,b,a}.
    // Verify left/right bank and digit order on the real board before use.
    assign seg_cs_pin = 8'b0;
    assign seg_data_0_pin = 8'b0;
    assign seg_data_1_pin = 8'b0;
endmodule
`default_nettype wire
