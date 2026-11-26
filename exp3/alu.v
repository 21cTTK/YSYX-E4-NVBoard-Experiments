module alu(
    input  [3:0] a, b,
    input  [2:0] op,
    output reg [3:0] result,
    output zero, overflow, carry
);
    // decides if it involves subtraction;
    // reused for op '-', '<' and '=='
    wire subtract = (op == 3'b001) || (op == 3'b110) || (op == 3'b111);
    // decides if it's arith
    wire arithmetic = (op == 3'b000) || (op == 3'b001);
    // RHS operand 'b' combined with the operator; make it "a+b" anyway
    wire [3:0] rhs = b ^ {4{subtract}};     // subtract: flip bits if it's a subtraction;
                                            //           do nothing if it's not.
    // 2's complement sum
    // with an extra bit for ovf
    wire [4:0] sum = {1'b0, a} + {1'b0, rhs}
                     + {4'b0, subtract};    // compensate the '1' if 'b'(rhs) is bit-flipped
                                            // 'cause 2's complement requires that
    // Same sign, Output diff method to decide ovf
    wire sign_ovf = (a[3] == rhs[3]) && (sum[3] != a[3]);

    always @(*) begin
        case (op)
            //arith
            3'b000, 3'b001: result = sum[3:0];
            //logic
            3'b010: result = ~a;
            3'b011: result = a & b;
            3'b100: result = a | b;
            3'b101: result = a ^ b;
            //cmp
            3'b110: result = {3'b0, sum[3] ^ sign_ovf};
            3'b111: result = {3'b0, ~(|sum[3:0])};
        endcase
    end

    assign zero = ~(|result);   // literally "0"
    assign overflow = arithmetic && sign_ovf;   // Is an arith op and Has ovf signal
    assign carry = arithmetic && sum[4];  // For subtraction, 1 means no borrow.

    initial
    begin
        if ($test$plusargs("trace"))
        begin
            $dumpfile("waveform.fst");
            $dumpvars(0, alu);
        end
    end
endmodule
