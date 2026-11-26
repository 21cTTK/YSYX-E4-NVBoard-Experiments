#include <cstdio>
#include <cstdlib>
#include "Valu.h"

void check(Valu& alu, VerilatedContext& context, int op, int a, int b,
           int expected, bool overflow = false, bool carry = false) {
    alu.op = op;
    alu.a = a & 0xf;
    alu.b = b & 0xf;
    alu.eval();
    if (alu.result != (expected & 0xf) || alu.zero != (expected == 0) ||
        alu.overflow != overflow || alu.carry != carry) {
        std::fprintf(stderr, "op=%d a=%d b=%d: got result=%x Z=%d V=%d C=%d; "
                     "expected result=%x Z=%d V=%d C=%d\n",
                     op, a, b, alu.result, alu.zero, alu.overflow, alu.carry,
                     expected & 0xf, expected == 0, overflow, carry);
        std::exit(1);
    }
    context.timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Valu alu{&context};

    check(alu, context, 0,  6,  1,  7);
    check(alu, context, 0,  7,  1, -8, true);
    check(alu, context, 0, -8, -1,  7, true, true);
    check(alu, context, 0, -2,  2,  0, false, true);

    check(alu, context, 1,  1,  2, -1);
    check(alu, context, 1, -7, -7,  0, false, true);
    check(alu, context, 1,  0, -8, -8, true);
    check(alu, context, 1, -8,  1,  7, true, true);

    check(alu, context, 2,  6,  0, -7);  // ~0110 = 1001
    check(alu, context, 3,  6,  3,  2);
    check(alu, context, 4,  6,  3,  7);
    check(alu, context, 5,  6,  3,  5);

    check(alu, context, 6, -8,  7,  1);
    check(alu, context, 6,  7, -8,  0);
    check(alu, context, 6,  2,  2,  0);
    check(alu, context, 7, -1, -1,  1);
    check(alu, context, 7, -1,  1,  0);

    alu.eval();
    alu.final();
    std::printf("All ALU test cases passed.\n");
}
