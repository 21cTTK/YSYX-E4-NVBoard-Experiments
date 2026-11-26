#include <string_view>
#include "Vmoore.h"

void cycle(Vmoore& top, VerilatedContext& context, bool reset, bool w) {
    top.clk = 0;
    top.reset = reset;
    top.w = w;
    top.eval();
    context.timeInc(1);

    top.clk = 1;
    top.eval();
    context.timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Vmoore top{&context};

    cycle(top, context, true, false);
    for (char bit : std::string_view("00000111110010001101")) {
        cycle(top, context, false, bit == '1');
    }
    cycle(top, context, true, false);
    cycle(top, context, false, true);
    top.clk = 0;
    top.eval();
    top.final();
}
