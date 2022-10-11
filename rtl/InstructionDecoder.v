`include "config.inc.v"


module InstructionDecoder(
    input [`IMEM_DATA_WIDTH - 1:0] instr,
    output [3:0] opcode,
    output [3:0] reg_d,
    output [3:0] reg_a,
    output [3:0] reg_b,
    output [`DMEM_DATA_WIDTH - 1:0] imm
);
    // Extract the opcode
    assign opcode = instr[3:0];

    // Dest register
    assign reg_d = instr[7:4];

    // Source registers
    assign reg_a = instr[11:8];
    assign reg_b = instr[15:12];

    // Immediate value
    assign imm = instr[15:8];
endmodule