#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME* top);

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  nvboard_bind_all_pins(&dut);
  nvboard_init();


  while (nvboard_update()) {
    dut.eval();
  }

  nvboard_quit();
}

