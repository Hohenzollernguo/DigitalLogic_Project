`timescale 1ns / 1ps
`default_nettype none
// Owner B. 
module hint_logic(
    input wire [35:0] board, input wire [3:0] filled_count,
    output reg [7:0] hint_mask
);

integer i;
reg     [3:0]zero_place;


always@(*)begin
    hint_mask=8'b00000000;
    zero_place=4'b1001;
    if(filled_count==4'b1001)begin
        for(i=0;i<9;i=i+1)begin
            if(board[4*i+:4]==4'b0000)begin
                zero_place=8-i;
            end
        end
    end

    case(zero_place)
        4'b0000:begin
        hint_mask[8-board[31:28]]=1;hint_mask[8-board[23:20]]=1;
        end
        4'b0001:begin
        hint_mask[8-board[35:32]]=1;hint_mask[8-board[27:24]]=1;hint_mask[8-board[19:16]]=1;
        end
        4'b0010:begin
        hint_mask[8-board[31:28]]=1;hint_mask[8-board[15:12]]=1;
        end
        4'b0011:begin
        hint_mask[8-board[35:32]]=1;hint_mask[8-board[19:16]]=1;hint_mask[8-board[11:8]]=1;
        end
        4'b0100:begin
        hint_mask[8-board[31:28]]=1;hint_mask[8-board[23:20]]=1;hint_mask[8-board[15:12]]=1;hint_mask[8-board[7:4]]=1;
        end
        4'b0101:begin
        hint_mask[8-board[27:24]]=1;hint_mask[8-board[19:16]]=1;hint_mask[8-board[3:0]]=1;
        end
        4'b0110:begin
        hint_mask[8-board[23:20]]=1;hint_mask[8-board[7:4]]=1;
        end
        4'b0111:begin
        hint_mask[8-board[19:16]]=1;hint_mask[8-board[11:8]]=1;hint_mask[8-board[3:0]]=1;
        end
        4'b1000:begin
        hint_mask[8-board[15:12]]=1;hint_mask[8-board[7:4]]=1;
        end

    endcase
end
endmodule
`default_nettype wire
