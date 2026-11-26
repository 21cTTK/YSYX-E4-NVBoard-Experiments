/// @author adapted on [this](https://nju-projectn.github.io/dlco-lecture-note/exp/07.html#list-ps02)

module ps2_keyboard(clk,resetn,ps2_clk,ps2_data,data,ready);
    input clk,resetn,ps2_clk,ps2_data;
    output reg [7:0] data;
    output reg ready;

    reg [9:0] buffer; // ps2_data bits buffer
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync; // slower ps2_clk that need to be recorded to determine edges

    // Update ps2_clk value queue
    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    //detects a falling edge; whether we need to sample or not
    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk)
    begin
        ready <= 0;
        if (resetn == 0)
        begin // reset
            count <= 0;
            data <= 0;
        end
        else
        begin  // normal
            if (sampling)
            begin   // falling edge detected --> we need to sample once
              if (count == 4'd10)
              begin // byte rx complete (count max'ed)
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1]))      // parity check
                begin   // odd parity (PASS)
                    data <= buffer[8:1];
                    ready <= 1;
                end
                //else;

                count <= 0;     // for next
              end
              else
              begin // pending following bits
                buffer[count] <= ps2_data;  // stash ps2_data
                count <= count + 3'b1;      // cnt++
              end
            end
            //else;
        end
    end

endmodule
