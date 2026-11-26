#include <cassert>
#include "Vtest.h"
#include "verilated.h"

void check(Vtest& top, VerilatedContext& context, unsigned x, unsigned expected) {
    top.x = x;
    top.eval();
    assert(top.seg == expected);
    context.timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Vtest top{&context};

    const unsigned expected[16] = {
        0xFC, 0x60, 0xDA, 0xF2, 0x66, 0xB6, 0xBE, 0xE0,
        0xFE, 0xF6, 0xEF, 0x3F, 0x9D, 0x7B, 0x9F, 0x8F
    };
    for (unsigned x = 0; x < 16; ++x) {
        check(top, context, x, expected[x]);
    }

    top.eval();
    top.final();
}
