module prio_enc(
    input [7:0] x,
    input en,
    output reg [2:0] y,
    output valid
);
    assign valid = en && (|x);

    integer i;
    always @(*)begin
        y = 3'd0;
        if (en)
        begin
            for (i = 0; i < 8; i = i + 1)
                if (x[i]) y = i[2:0];
        end
        //else;
    end
endmodule
