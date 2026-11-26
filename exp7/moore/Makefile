all: obj_dir/Vmoore

obj_dir/Vmoore: moore.v sim_main.cpp Makefile
	verilator --cc --exe --build --trace-fst -Wall --top-module moore moore.v sim_main.cpp

test: all
	./obj_dir/Vmoore +trace

run: test
	gtkwave waveform.fst

.PHONY: all test run
