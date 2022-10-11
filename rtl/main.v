`timescale 1ns / 1ps

`include "config.inc.v"


module MPSCPU(
    // Instructions memory ports
    output [`IMEM_ADDR_WIDTH - 1:0] imem_addr,
    input [`IMEM_DATA_WIDTH - 1:0] imem_value,

    // Data memory ports
    output [`DMEM_ADDR_WIDTH - 1:0] dmem_addr,
    output dmem_wenable,
    input [`DMEM_ADDR_WIDTH - 1:0] dmem_rvalue,
    output [`DMEM_ADDR_WIDTH - 1:0] dmem_wvalue,

    // Sync signals
    input clock,
    input nreset
);
    reg r_on_fire; // Is the processor on fire?



    // Instruction Fetch
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Instruction_fetch
    //
    // Update the program counter and fetch the next instruction to 
    // execute from the memory
    wire [`IMEM_ADDR_WIDTH - 1:0] r_pc; // Program counter
    ProgramCounter c_pc(
        .pc(r_pc),
        .clock(clock),
        .nreset(nreset)
    );

    wire [`IMEM_DATA_WIDTH - 1:0] r_instr;
    InstructionFetcher c_if(
        .pc(r_pc),
        .instr(r_instr),
        .mem_addr(imem_addr),
        .mem_value(imem_value)
    );



    // Instruction Decode
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Instruction_decode
    //
    // Extract the useful informations from the instruction
    
    // Extract the opcode
    wire [3:0] r_opcode = r_instr[3:0];

    // Extract the ALU mode and ALU func
    wire r_alu_mode = r_opcode[0];
    wire [2:0] r_func = r_opcode[3:1];

    // Dest register
    wire r_reg_d_enable = r_alu_mode
        || r_opcode == `OPCODE_LOAD
        || r_opcode == `OPCODE_SET 
        || r_opcode == `OPCODE_DUP;
    wire [3:0] r_reg_d = r_reg_d_enable ? r_instr[7:4] : 0;

    // Source register A
    wire r_reg_a_enable = r_alu_mode
        || r_opcode == `OPCODE_LOAD
        || r_opcode == `OPCODE_STORE
        || r_opcode == `OPCODE_DUP;
    wire [3:0] r_reg_a = r_reg_a_enable ? r_instr[11:8] : 0;

    // Source register B
    wire r_reg_b_enable  = r_alu_mode && r_opcode != `OPCODE_NOT 
        || r_opcode == `OPCODE_STORE;
    wire [3:0] r_reg_b = r_reg_b_enable ? r_instr[15:12] : 0;

    // Immediate value
    wire r_imm_enable = r_opcode == `OPCODE_SET;
    wire [7:0] r_imm = r_imm_enable ? r_instr[15:8] : 0;

    // Memory write?
    wire r_mem_write = r_opcode == `OPCODE_STORE;

    // Memory read?
    wire r_mem_read = r_opcode == `OPCODE_LOAD;

    // Our register file
    // https://en.wikipedia.org/wiki/Register_file
    reg [`DMEM_DATA_WIDTH - 1:0] r_regs [`REGS_COUNT - 1:0];
    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_d_value;
    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_a_value = r_reg_a_enable ? r_regs[r_reg_a] : 0;
    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_b_value = r_reg_b_enable ? r_regs[r_reg_b] : 0;
    integer i;
    always @(negedge clock) begin
        if (!nreset) begin
            for (i = 0; i < `REGS_COUNT; i = i + 1) begin
                r_regs[i] <= 0;
            end
        end else begin
            if (r_reg_d_enable && r_reg_d != 0) begin
                r_regs[r_reg_d] <= r_reg_d_value;
            end
        end
    end


    // Execute
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Execute
    //
    // Do the actual work
    reg [`DMEM_DATA_WIDTH - 1:0] r_alu_res;
    always @(*) begin
        case (r_opcode)
            `OPCODE_SET: r_alu_res <= r_imm;
            `OPCODE_DUP: r_alu_res <= r_reg_a_value;
            `OPCODE_ADD: r_alu_res <= r_reg_a_value + r_reg_b_value;
            `OPCODE_SUB: r_alu_res <= r_reg_a_value - r_reg_b_value;
            `OPCODE_LSH: r_alu_res <= r_reg_a_value << r_reg_b_value;
            `OPCODE_RSH: r_alu_res <= r_reg_a_value >> r_reg_b_value;
            `OPCODE_OR: r_alu_res <= r_reg_a_value | r_reg_b_value;
            `OPCODE_AND: r_alu_res <= r_reg_a_value & r_reg_b_value;
            `OPCODE_XOR: r_alu_res <= r_reg_a_value ^ r_reg_b_value;
            `OPCODE_NOT: r_alu_res <= ~r_reg_a_value;
            default: r_alu_res <= 0;
        endcase
    end


    // Memory access
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Memory_access
    // 
    // Write or read any value from the memory
    assign dmem_wenable = r_mem_write;
    assign dmem_addr = (r_mem_write || r_mem_read) ? r_reg_a_value : 0;
    assign dmem_wvalue = r_mem_write ? r_reg_b_value : 0;
    reg [`DMEM_DATA_WIDTH - 1:0] r_mem_value;
    always @(*) begin
        if (!nreset) begin
            r_mem_value <= 0;
        end else begin
            r_mem_value <= dmem_rvalue;
        end
    end


    // Writeback
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Writeback
    //
    // Write back to the register file the computed or fetched value
    assign r_reg_d_value = r_mem_read ? r_mem_value : r_alu_res;
endmodule