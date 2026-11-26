module shreg(
    input [7:0] oprd,
    input [2:0] op,
    input clk,
    input sw,
    output reg [7:0] result
);
    always @(posedge clk) begin
        case (op)
            3'b000: result <= 8'h00;                  // clear
            3'b001: result <= oprd;                   // parallel load
            3'b010: result <= {1'b0, result[7:1]};    // logical right
            3'b011: result <= {result[6:0], 1'b0};    // logical left
            3'b100: result <= {result[7], result[7:1]}; // arithmetic right
            3'b101: result <= {sw, result[7:1]};      // shift in sw at bit 7
            3'b110: result <= {result[0], result[7:1]}; // rotate right
            3'b111: result <= {result[6:0], result[7]}; // rotate left
        endcase
    end

    initial begin
        if ($test$plusargs("trace")) begin
            $dumpfile("waveform.fst");
            $dumpvars(0, shreg);
        end
    end
endmodule
