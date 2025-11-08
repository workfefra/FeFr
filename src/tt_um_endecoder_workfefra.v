`default_nettype none

module endecoder (
    input  wire        clk_i,
    input  wire        rst_i,
    input  wire [3:0]  code_i,
    input  wire [3:0]  key_i,
    input  wire        mode_i,     // 0 = encrypt, 1 = decrypt
    input  wire        start_i,    // trigger encryption/decryption
    output reg  [3:0]  code_o,
    output reg         done_o      // goes high when finished
);

    // Internal registers
    reg [3:0] data;
    reg [3:0] rounds_left;
    reg       active;

    // One-round encryption/decryption
    function [3:0] encrypt_round;
    input [3:0] code;
    input [3:0] key;
    reg [3:0] tmp;
    begin
        // Step 1: XOR with key
        tmp = code ^ key;

        // Step 2: invert bits
        tmp = ~tmp;

        // Step 3: rotate left by 2
        tmp = {tmp[1:0], tmp[3:2]};

        encrypt_round = tmp;
    end
endfunction

    function [3:0] decrypt_round;
    input [3:0] code;
    input [3:0] key;
    reg [3:0] tmp;
    begin
        // Step 1: rotate right by 2 (inverse of left)
        tmp = {code[1:0], code[3:2]}; // same as rotate right 2 for 4 bits

        // Step 2: invert bits
        tmp = ~tmp;

        // Step 3: XOR with key
        tmp = tmp ^ key;

        decrypt_round = tmp;
    end
endfunction

    // Main FSM: one round per clock
    reg [3:0] next_data; // temporary storage for next round

always @* begin
    if (mode_i == 1'b0)
        next_data = encrypt_round(data, key_i);
    else
        next_data = decrypt_round(data, key_i);
end

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        active      <= 1'b0;
        done_o      <= 1'b0;
        rounds_left <= 4'd0;
        data        <= 4'd0;
        code_o      <= 4'd0;
    end else begin
        if (start_i && !active) begin
            active      <= 1'b1;
            done_o      <= 1'b0;
            rounds_left <= key_i;
            data        <= code_i;
        end else if (active) begin
            if (rounds_left == 4'd1) begin
                data        <= next_data;
                code_o      <= next_data;
                done_o      <= 1'b1;
                active      <= 1'b0;
                rounds_left <= 4'd0;
            end else begin
                data        <= next_data;
                rounds_left <= rounds_left - 1'b1;
                done_o      <= 1'b0;
            end
        end else begin
            done_o <= 1'b0;
        end
    end
end

endmodule

`default_nettype wire
