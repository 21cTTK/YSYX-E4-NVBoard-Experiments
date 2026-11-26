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

	top.en = 0b0;   top.x = 0b0000;   dumpWave(&context, &top);
	                top.x = 0b0001;   dumpWave(&context, &top);
	                top.x = 0b0010;   dumpWave(&context, &top);
                    top.x = 0b0100;   dumpWave(&context, &top);
                    top.x = 0b1000;   dumpWave(&context, &top);
	top.en = 0b1;   top.x = 0b0000;   dumpWave(&context, &top);
                    top.x = 0b0001;   dumpWave(&context, &top);
                    top.x = 0b0010;   dumpWave(&context, &top);
                    top.x = 0b0100;   dumpWave(&context, &top);
                    top.x = 0b1000;   dumpWave(&context, &top);

    top.eval();
    top.final();
    return 0;
}
