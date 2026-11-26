VSRCS = $(wildcard *.v)
CSRCS = $(wildcard *.cpp)
TOP   ?= test
WAVE  ?= waveform.fst
EXE   = ./obj_dir/V$(TOP) 

all: $(VSRCS) $(CSRCS)
	verilator --cc --exe --build -j 0 -Wall --trace-fst --top-module $(TOP) $^ 

clean:
	rm -rf ./obj_dir/ $(WAVE)

run: all
	$(EXE) +trace
	gtkwave $(WAVE)

.PHONY: all run clean

