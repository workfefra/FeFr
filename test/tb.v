`default_nettype none
`timescale 1ns / 1ps

module tb_tt_um_endecoder_workfefra;

  reg clk = 0;
  always #5 clk = ~clk;

  reg [7:0] ui_in = 0;
  wire [7:0] uo_out;

  tt_um_endecoder_workfefra uut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .clk(clk),
    .rst_n(1'b1),
    .ena(1'b1),
    .uio_in(8'h00),
    .uio_out(),
    .uio_oe()
  );

  initial begin
    $display("Testbench running OK");
    #100 $finish;
  end

endmodule
