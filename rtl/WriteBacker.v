`include "config.inc.v"


module WriteBacker(
    input [`DMEM_DATA_WIDTH - 1:0] alu_z,
    input [`DMEM_DATA_WIDTH - 1:0] mem_value,
    input mem_read,
    output [`DMEM_DATA_WIDTH - 1:0] d_value
); 
    assign d_value = mem_read ? mem_value : alu_z;
endmodule