RTL_DIR ?= ../rtl
RTL_SOURCES ?= \
	../rtl/ALU.v \
	../rtl/Control.v \
	../rtl/InstructionDecoder.v \
	../rtl/InstructionFetcher.v \
	../rtl/MemoryAccesser.v \
	../rtl/ProgramCounter.v \
	../rtl/RegisterFile.v \
	../rtl/WriteBacker.v \
	../rtl/main.v 
all: dut.vcd

waves: dut.vcd
	gtkwave $<

dut.vcd: dut.out
	./$<

dut.out: $(RTL_SOURCES) tb.v instructions.mem
	iverilog -I$(RTL_DIR) -o $@ $(RTL_SOURCES) tb.v

instructions.mem: main.s
	../asm.py $< $@

clean:
	$(RM) *.out *.vcd *.mem