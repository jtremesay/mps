`include "config.inc.v"


module InstructionFetcher(
    input [`IMEM_ADDR_WIDTH - 1:0] pc,
    output [`IMEM_DATA_WIDTH - 1:0] instr,
    output [`IMEM_ADDR_WIDTH - 1:0] mem_addr,
    input [`IMEM_DATA_WIDTH - 1:0] mem_value
);
    assign mem_addr = pc;
    assign instr = mem_value;
endmodule