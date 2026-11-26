module moore(
    input clk,
    input reset,
    input w,
    output zout,
    output [3:0] sout     // state out
);
    localparam [3:0] A = 0, B = 1, C = 2, D = 3, E = 4,
                     F = 5, G = 6, H = 7, I = 8;
    reg [3:0] state, nx_state;

    // State Transition Logic (combinational)
    always @(*)
    begin
        case (state)
            A: nx_state = w ? F : B;
            B: nx_state = w ? F : C;
            C: nx_state = w ? F : D;
            D: nx_state = w ? F : E;
            E: nx_state = w ? F : E;
            F: nx_state = w ? G : B;
            G: nx_state = w ? H : B;
            H: nx_state = w ? I : B;
            I: nx_state = w ? I : B;
            default: nx_state = A;
        endcase
    end

    // State Flip-flops (sequential)
    always @(posedge clk)
        state <= reset ? A : nx_state;

    // Output
    assign zout  = (state == E) || (state == I);
    assign sout = state;

    // Test
    initial
    begin
        if ($test$plusargs("trace")) begin
            $dumpfile("waveform.fst");
            $dumpvars(0, moore);
        end
    end
endmodule
