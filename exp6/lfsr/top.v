module top(
    input step,
    output [7:0] hex1,
    output [7:0] hex0
);
    wire [7:0] q;
    wire feedback = q[4] ^ q[3] ^ q[2] ^ q[0];
    // zero recovery
    shreg #(.INIT(8'h01)) lfsr (
        .clk(step), .op(q == 0 ? 3'b001 : 3'b101),
        .oprd(8'h01), .sw(feedback), .result(q)
    );

    wire [7:0] high_segments, low_segments;
    seg_hex high_digit(.x(q[7:4]), .seg(high_segments));
    seg_hex low_digit (.x(q[3:0]), .seg(low_segments));
    // active low
    assign hex1 = ~high_segments;
    assign hex0 = ~low_segments;
endmodule
