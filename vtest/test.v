module test(
  input a,
  input b,
  output f
);
  assign f = a ^ b;

  initial begin
    if ($test$plusargs("trace")) begin
      $dumpfile("wave.vcd");
      $dumpvars(0, test);
    end
  end
endmodule
