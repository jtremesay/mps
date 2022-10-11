`include "config.inc.v"


module MemoryAccesser(
    input [`DMEM_ADDR_WIDTH - 1:0] addr,
    input write_enable,
    input [`DMEM_DATA_WIDTH - 1:0] wvalue,
    output rvalue,

    output [`DMEM_ADDR_WIDTH - 1:0] mem_addr,
    output mem_wenable,
    input [`DMEM_DATA_WIDTH - 1:0] mem_rvalue,
    output [`DMEM_DATA_WIDTH - 1:0] mem_wvalue
);
    assign mem_addr = addr;
    assign mem_wenable = write_enable;
    assign mem_wvalue = wvalue;
    assign rvalue = mem_rvalue;
endmodule