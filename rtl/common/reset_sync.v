`timescale 1ns / 1ps
`default_nettype none
// Owner C. Infrastructure implemented: async assertion, sync deassertion.
// Board polarity is selected at top; all internal resets are active high.
module reset_sync(input wire clk, input wire async_rst, output wire rst);
    (* ASYNC_REG = "TRUE" *) reg [1:0] stages;
    always @(posedge clk or posedge async_rst) begin
        if (async_rst) stages <= 2'b11;
        else           stages <= {stages[0], 1'b0};
    end
    assign rst = stages[1];
endmodule
`default_nettype wire
