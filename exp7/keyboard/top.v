module top(
    input clk, rst, ps2_clk, ps2_data,
    output [7:0] hex0, hex1, // scan (raw key press info)
                 hex2, hex3, // ascii (encoded `scan`)
                 hex4, hex5  // count
);
    wire ready; // from ps2_keyboard: `ready` is set when a full byte is received
    wire [7:0] scan, ascii; // temporarily stores code

    // keyboard module: processing key presses
    ps2_keyboard rx(.clk(clk),
                    .resetn(~rst),
                    .ps2_clk(ps2_clk),
                    .ps2_data(ps2_data),
                    .data(scan),
                    .ready(ready)
    );

    // convert scan to ascii
    scan_ascii lookup(.scan(scan), .ascii(ascii));

    //useful flags
    reg held, releasing, extended_key;
    //stores Make code and corresponding Ascii value
    reg [7:0] key_code, key_ascii;
    //counter: counts key presses
    reg [3:0] tens, ones;

    always @(posedge clk)
    begin
        if (rst)
        begin   // hard reset
            held <= 0;
            releasing <= 0;
            extended_key <= 0;
            key_code <= 0;
            key_ascii <= 0;
            tens <= 0;
            ones <= 0;
        end
        else if (ready)
        begin   // received full byte (new keyboard activity -- Make code or Break code)
            case (scan)
                8'he0: extended_key <= 1;   // new activity is "ctrl alt shift..." key press
                8'hf0: releasing    <= 1;   // new activity is key release
                default:
                begin
                    if (!extended_key)
                    begin   // processes non-"ctrl alt shift ..." normal keys
                        if (releasing)
                        begin   // detects Break code
                            // only releasing currently pressed key trig real "rls"
                            if (scan == key_code) held <= 0;
                        end
                        else if (!held && ascii != 0)
                        begin
                            held      <= 1;
                            key_code  <= scan;
                            key_ascii <= ascii;
                            if (ones == 9)
                            begin   // handles carry
                                ones <= 0;
                                tens <= (tens == 9) ? 0 : tens + 1'b1;
                            end
                            else    // normal ones++
                                ones <= ones + 1'b1;
                        end
                    end
                    //else; // don't care extended keys

                    //clear stale flags
                    releasing    <= 0;
                    extended_key <= 0;
                end
            endcase
        end
        //else; // not ready (no new key press)
    end

    // all stuffs to be displayed (count, ascii code, key code)
    wire [23:0] digits = {tens, ones, key_ascii, key_code};

    // temp var for storing convertion result (from scan,ascii to 7seg)
    wire [47:0] segments;
    // "display" block fancy wiring to get the 
    for (genvar i = 0; i < 6; i = i + 1) begin : display
        seg_hex digit(
            .x  (digits[4*i +: 4]),     // input: raw count and codes
            .seg(segments[8*i +: 8])    // output: display info (for 7seg)
        );
    end

    assign {hex5, hex4} = ~segments[47:32]; //count
    assign {hex3, hex2, hex1, hex0} = held ? ~segments[31:0] : 32'hffffffff; //codes
endmodule
