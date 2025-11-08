`default_nettype none

// ============================================================
// TinyTapeout-compatible top wrapper for your endecoder core
// ============================================================

module tt_um_endecoder_workfefra (
    input  wire        clk,      // system clock
    input  wire        rst_n,    // active-low reset
    input  wire        ena,      // enable signal (always high during normal operation)
    input  wire [7:0]  ui_in,    // user inputs
    output wire [7:0]  uo_out,   // user outputs
    input  wire [7:0]  uio_in,   // bidirectional inputs (unused)
    output wire [7:0]  uio_out,  // bidirectional outputs (unused)
    output wire [7:0]  uio_oe    // bidirectional enables (unused)
);

    // Map standard TinyTapeout signals to your core's ports
    wire clk_i   = clk;
    wire rst_i   = ~rst_n;   // convert active-low to active-high
    wire [3:0] code_i  = ui_in[3:0];
    wire [3:0] key_i   = ui_in[7:4];

    // You can repurpose unused bits of ui_in for mode/start, e.g. via ena/uio_in
    // For now, let's tie them to fixed values or user inputs:
    wire mode_i  = uio_in[0];  // optional external control (0=encrypt, 1=decrypt)
    wire start_i = uio_in[1];  // optional external trigger

    // Outputs
    wire [3:0] code_o;
    wire       done_o;

    // Drive unused IOs safely
    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

    // Map your outputs to standard TinyTapeout outputs
    assign uo_out = {3'b000, done_o, code_o}; // pack outputs: [7:4] unused, [3:0] code_o, [4]=done_o

    // ============================================================
    // Instantiate your core
    // ============================================================
    EnDecoder (
        .clk_i   (clk_i),
        .rst_i   (rst_i),
        .code_i  (code_i),
        .key_i   (key_i),
        .mode_i  (mode_i),
        .start_i (start_i),
        .code_o  (code_o),
        .done_o  (done_o)
    );

endmodule

`default_nettype wire

