`include "config.inc.v"


module Control(
    input [3:0] opcode,
    output reg_d_enable,
    output use_imm,
    output alu_enable,
    output [2:0] alu_func,
    output mem_read,
    output mem_write
);
    assign alu_enable = opcode[0];
    assign alu_func = opcode[3:1];
    assign mem_write = opcode == `OPCODE_STORE;
    assign mem_read = opcode == `OPCODE_LOAD;
    assign use_imm = opcode == `OPCODE_SET;
    assign reg_d_enable = alu_enable
        || opcode == `OPCODE_LOAD
        || opcode == `OPCODE_SET 
        || opcode == `OPCODE_DUP;
endmodule