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
    wire [3:0] r_opcode;
    wire [3:0] r_reg_d;
    wire [3:0] r_reg_a;
    wire [3:0] r_reg_b;
    wire [`DMEM_DATA_WIDTH - 1:0] r_imm;
    InstructionDecoder c_id(
        .instr(r_instr),
        .opcode(r_opcode),
        .reg_d(r_reg_d),
        .reg_a(r_reg_a),
        .reg_b(r_reg_b),
        .imm(r_imm)
    );
    
    wire r_alu_enable;
    wire [2:0] r_alu_func;
    wire r_use_imm;
    wire r_reg_d_enable;
    wire r_mem_read; 
    wire r_mem_write; 
    Control c_c(
        .opcode(r_opcode),
        .reg_d_enable(r_reg_d_enable),
        .use_imm(r_use_imm),
        .alu_enable(r_alu_enable),
        .alu_func(r_alu_func),
        .mem_read(r_mem_read),
        .mem_write(r_mem_write)
    );

    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_d_value;
    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_a_value;
    wire [`DMEM_DATA_WIDTH - 1:0] r_reg_b_value;
    RegisterFile c_rf(
        .reg_d_enable(r_reg_d_enable),
        .reg_d(r_reg_d),
        .reg_d_value(r_reg_d_value),
        .reg_a(r_reg_a),
        .reg_a_value(r_reg_a_value),
        .reg_b(r_reg_b),
        .reg_b_value(r_reg_b_value),
        .clock(clock),
        .nreset(nreset)
    );

    // Execute
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Execute
    //
    // Do the actual work
    wire [`DMEM_DATA_WIDTH - 1:0] r_alu_res;
    ALU c_alu(
        .a(r_use_imm ? r_imm : r_reg_a_value),
        .b(r_reg_b_value),
        .z(r_alu_res),
        .func(r_alu_func),
        .enable(r_alu_enable)
    );
    

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