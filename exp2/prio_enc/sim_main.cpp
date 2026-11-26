#include <cassert>
#include "Vtest.h"
#include "verilated.h"

void check(Vtest& top, VerilatedContext& context, bool en, unsigned x, unsigned expected) {
    top.en = en;
    top.x = x;
    top.eval();
    assert(top.y == expected);
    context.timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Vtest top{&context};

    check(top, context, false, 0b1111, 0);
    check(top, context, true,  0b0000, 0);
    check(top, context, true,  0b0001, 0);
    check(top, context, true,  0b0011, 1);
    check(top, context, true,  0b0111, 2);
    check(top, context, true,  0b1111, 3);
    check(top, context, false, 0b1111, 0);

    top.eval();
    top.final();
}
