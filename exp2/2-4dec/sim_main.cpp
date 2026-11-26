#include <cassert>
#include <cstdio>
#include <cstdlib>
#include "Vtest.h"
#include "verilated.h"

void dumpWave(VerilatedContext *ctxp, Vtest *topp){
	topp->eval();
	ctxp->timeInc(1);
}

int main(int argc, char** argv) {
    VerilatedContext context;
    context.commandArgs(argc, argv);
    context.traceEverOn(true);
    Vtest top{&context};

	top.en = 0b0;  top.x = 0b00;  dumpWave(&context, &top);
	                top.x = 0b01;  dumpWave(&context, &top);
                    top.x = 0b10;  dumpWave(&context, &top);
                    top.x = 0b11;  dumpWave(&context, &top);
	top.en = 0b1;  top.x = 0b00;  dumpWave(&context, &top);
                    top.x = 0b01;  dumpWave(&context, &top);
                    top.x = 0b10;  dumpWave(&context, &top);
                    top.x = 0b11;  dumpWave(&context, &top);

    top.eval();
    top.final();
    return 0;
}
