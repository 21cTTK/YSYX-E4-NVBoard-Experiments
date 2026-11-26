module top(
    input [7:0] sw,
    input en,
    output [2:0] led,
    output valid,
    output [7:0] hex0
);
    wire [7:0] segments;
    prio_enc encoder(.x(sw), .en(en), .y(led), .valid(valid));
    seg_hex display(.x({1'b0, led}), .seg(segments));

    // active-low
    assign hex0 = ~segments;
endmodule
