all: obj_dir/Valu

obj_dir/Valu: alu.v sim_main.cpp Makefile
	verilator --cc --exe --build --trace-fst -Wall --top-module alu alu.v sim_main.cpp

test: all
	./obj_dir/Valu +trace

run: test
	gtkwave waveform.fst

.PHONY: all test run
