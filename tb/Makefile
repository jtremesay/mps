RTL_SOURCES ?= ../rtl/main.v 
all: dut.vcd

waves: dut.vcd
	gtkwave $<

dut.vcd: a.out
	./$<

a.out: $(RTL_SOURCES) tb.v instructions.mem
	iverilog $(RTL_SOURCES) tb.v

instructions.mem: main.s
	../asm.py $< $@

clean:
	$(RM) *.out *.vcd *.mem