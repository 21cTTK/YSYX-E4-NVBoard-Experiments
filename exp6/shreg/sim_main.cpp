#include <cassert>
#include <cstdio>
#include "Vshreg.h"

void check(Vshreg& reg, VerilatedContext& context, unsigned op,
           unsigned oprd, bool sw, unsigned expected) {
    unsigned previous = reg.result;
    reg.clk = 0;
    reg.op = op;
    reg.oprd = oprd;
    reg.sw = sw;
    reg.eval();
    assert(reg.result == previous);
    context.timeInc(1);

    reg.clk = 1;
    reg.eval();
    assert(reg.result == expected);
    context.timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Vshreg reg{&context};
    reg.clk = 0;
    reg.eval();
    context.timeInc(1);

    check(reg, context, 1, 0x83, 0, 0x83); // load
    check(reg, context, 2, 0,    0, 0x41); // logical right
    check(reg, context, 3, 0,    0, 0x82); // logical left
    check(reg, context, 4, 0,    0, 0xc1); // retain sign
    check(reg, context, 6, 0,    0, 0xe0); // bit 0 wraps to bit 7
    check(reg, context, 7, 0,    0, 0xc1); // bit 7 wraps to bit 0
    check(reg, context, 0, 0xff, 1, 0x00); // synchronous clear

    // Send 0x96 least-significant bit first.
    const unsigned states[] = {0x00, 0x80, 0xc0, 0x60, 0xb0, 0x58, 0x2c, 0x96};
    for (unsigned i = 0; i < 8; ++i)
        check(reg, context, 5, 0, (0x96 >> i) & 1, states[i]);

    reg.clk = 0;
    reg.eval();
    reg.final();
    std::printf("All shift-register tests passed.\n");
}
