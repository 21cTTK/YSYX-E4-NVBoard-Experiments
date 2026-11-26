all: obj_dir/Vshreg

obj_dir/Vshreg: shreg.v sim_main.cpp Makefile
	verilator --cc --exe --build --trace-fst -Wall --top-module shreg shreg.v sim_main.cpp

test: all
	./obj_dir/Vshreg +trace

run: test
	gtkwave waveform.fst

.PHONY: all test run
