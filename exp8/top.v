module top(
    input clk, rst, pattern,
    output VGA_HSYNC, VGA_VSYNC, VGA_BLANK_N,
    output [7:0] VGA_R, VGA_G, VGA_B
);
    // position coordinate 
    wire [9:0] x, y;
    // read img stuff idk
    // anyway we will get a huge (width=640,height=480(visible),color-depth=12(RGB444))
    // array that represents an img, stored in `rom`
    reg [11:0] rom [0:640*512-1];
    // the `$readmemh` stuff loads a big img data stuff generated from some png and cpp program idc
    initial $readmemh("build/picture.hex", rom);
    // now `rom` Is the img, we still need to translate it

    // do some crazy wiring so we got the color data for every pixel point (x,y)
    // then we can put it later
    wire [11:0] pixel = rom[{x, y[8:0]}];
    // `image_rgb` is the full color info {R,G,B} for a pixel point (x,y)
    // this is difference from `pixel` since we only takes 4 out of 8 available bits
    // for each of R/G/B so there's a `4'b0` in every slot
    wire [23:0] image_rgb = {pixel[11:8], 4'b0, pixel[7:4], 4'b0, pixel[3:0], 4'b0};
    // add a bar screen so it's Interactive and thus funnier than just a static img
    wire [23:0] bars = x < 320 ? 24'hff0000 : 24'h0000ff;
    // choose which to display based on user input `pattern`
    wire [23:0] rgb = VGA_BLANK_N ? (pattern ? bars : image_rgb) : 24'h0;

    // call NVBoard's example vga_ctrl.v module to dump all that `rgb` to the screen
    vga_ctrl timing(.pclk(clk),
                    .reset(rst),
                    .vga_data(rgb),
                    .h_addr(x), .v_addr(y),
                    .hsync(VGA_HSYNC), .vsync(VGA_VSYNC),
                    .valid(VGA_BLANK_N),
                    .vga_r(VGA_R), .vga_g(VGA_G), .vga_b(VGA_B)
    );
endmodule
