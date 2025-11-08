`default_nettype none
`timescale 1ns / 1ps

module tb;
  initial begin
    $display("Dummy test running OK");
    #10 $finish;
  end
endmodule

`default_nettype wire
