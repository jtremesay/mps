// MPS - an educational 8 bits processor and its toolchain
// Copyright (C) 2022 Jonathan Tremesaygues <jonathan.tremesaygues@slaanesh.org>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

`timescale 1ns / 1ps

`include "config.inc.v"


module MPSCPU(
    // Instructions memory ports
    output [`IMEM_ADDR_WIDTH - 1:0] imem_addr,
    input [`IMEM_DATA_WIDTH - 1:0] imem_value,

    // Data memory ports
    output [`DMEM_ADDR_WIDTH - 1:0] dmem_addr,
    output dmem_wenable,
    input [`DMEM_DATA_WIDTH - 1:0] dmem_rvalue,
    output [`DMEM_DATA_WIDTH - 1:0] dmem_wvalue,

    // Sync signals
    input clock,
    input nreset
);
    reg r_on_fire;
    wire r_fire_starting;
    always @(posedge clock) begin
        if (!nreset) begin
            r_on_fire <= 0;
        end else if (r_fire_starting) begin
            r_on_fire <= 1;
        end
    end

    // Instruction Fetch
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Instruction_fetch
    //
    // Update the program counter and fetch the next instruction to 
    // execute from the memory
    wire [`IMEM_ADDR_WIDTH - 1:0] r_pc; // Program counter
    ProgramCounter c_pc(
        .pc(r_pc),
        .clock(clock),
        .nreset(nreset),
        .on_fire(r_on_fire)
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
        .mem_write(r_mem_write),
        .fire_starting(r_fire_starting)
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
        .reg_b_value(r_reg_b_value)
    );


    // Execute
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Execute
    //
    // Do the actual work
    wire [`DMEM_DATA_WIDTH - 1:0] r_alu_z;
    ALU c_alu(
        .a(r_use_imm ? r_imm : r_reg_a_value),
        .b(r_reg_b_value),
        .z(r_alu_z),
        .func(r_alu_func),
        .enable(r_alu_enable)
    );
    

    // Memory access
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Memory_access
    // 
    // Write or read any value from the memory
    wire [`DMEM_DATA_WIDTH - 1:0] r_mem_value;
    MemoryAccesser c_ma(
        .addr(r_reg_a_value),
        .write_enable(r_mem_write),
        .wvalue(r_reg_b_value),
        .rvalue(r_mem_value),
        .mem_addr(dmem_addr),
        .mem_wenable(dmem_wenable),
        .mem_rvalue(dmem_rvalue),
        .mem_wvalue(dmem_wvalue)
    );

    // Writeback
    // https://en.wikipedia.org/wiki/Classic_RISC_pipeline#Writeback
    //
    // Write back to the register file the computed or fetched value
    WriteBacker c_wb(
        .alu_z(r_alu_z),
        .mem_value(r_mem_value),
        .mem_read(r_mem_read),
        .d_value(r_reg_d_value)
    );
endmodule