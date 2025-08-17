# 'make' to run and compile 'make view' for GTKWave
all:
	iverilog -o cpu_sim tb/tb_cpu.v src/*.v
	vvp cpu_sim
view:
	gtkwave dump.vcd
clean:
	rm -f cpu_sim, dump.vcd
	rm -f alu_sim, dumpalu.vcd
alu:
	iverilog -o alu_sim tb/tb_alu.v src/*.v
	vvp alu_sim
viewalu:
	gtkwave dumpalu.vcd