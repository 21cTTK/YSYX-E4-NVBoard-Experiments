export NVBOARD_HOME ?= $(abspath ../../nvboard)
RTL = top.v $(NVBOARD_HOME)/example/vsrc/vga_ctrl.v
all: build/top build/picture.hex

include $(NVBOARD_HOME)/scripts/nvboard.mk

build:
	mkdir -p $@

build/auto_bind.cpp: top.nxdc $(NVBOARD_HOME)/scripts/auto_pin_bind.py | build
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $< $@

build/img2hex: img2hex.cpp | build
	$(CXX) $< $$(pkg-config --cflags --libs SDL2_image) -o $@

build/picture.hex: picture.png build/img2hex
	build/img2hex $< > $@.tmp && mv $@.tmp $@

build/top: $(RTL) sim_main.cpp build/auto_bind.cpp $(NVBOARD_ARCHIVE) Makefile
	verilator --cc --build --exe --top-module top --Mdir build/obj_dir $(RTL) $(abspath sim_main.cpp build/auto_bind.cpp) $(NVBOARD_ARCHIVE) -CFLAGS '$(CXXFLAGS) -I$(NVBOARD_USR_INC) -DTOP_NAME=Vtop' -LDFLAGS '$(LDFLAGS)' -o $(abspath $@)

run: all
	./build/top

build/check: $(RTL) check.cpp Makefile | build
	verilator --cc --build --exe --top-module top --Mdir build/test $(RTL) $(abspath check.cpp) -o $(abspath $@)

.PHONY: all run
