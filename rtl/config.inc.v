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

// 8 bits RISC CPU
// ===============
//
// Configuration
// -------------
//
// Registers: 16 of 8 bits (r0 to r15)
// r0 is read only and contains 0
`define REGS_COUNT 16
// 
// Data width: 8 bits
`define DMEM_DATA_WIDTH 8
// 
// Address width: 8 bits
`define DMEM_ADDR_WIDTH 8
// 
// Instruction width: 16 bits
`define IMEM_DATA_WIDTH 16
// 
// Instruction address width: 8 bits
`define IMEM_ADDR_WIDTH 8
//
// 
// Instructions encoding
// ---------------------
// 
//                        15      8 7      0
// Normal instruction:     BBBBAAAA DDDDOOOO
// Immediate instruction:  IIIIIIII DDDDOOOO
// 
// Field | Width | Range | Description 
// -----------------------------------
//     O |     4 |  [3:0] | Opcode
//     D |     4 |  [7:4] | Destination register d
//     A |     4 | [12:8] | Source register a
//     B |     4 | [15:12]| Source register b
//     I |     8 | [12:8] | Immediate value
//
//
// Instructions
// ------------
// 
// Opcode encoding: FFFA
// 
// A: ALU mode, if 1, the ALU is used
// F: function, see table below 
//
//       Normal mode                      ALU mode
//   | 00 | 01 | 10 | 11           | 00 | 01 | 10 | 11
// ----------------------        ---------------------
// 0 | nop| ld | set|            0 | add| lsh| or | xor
// 1 | hcf| st | dup|            1 | sub| rsh| and| not
// 
// - No operation
// nop
// Do nothing
`define OPCODE_NOP 4'b0000
//
// - Halt, and Catch Fire
// hcf
// Do nothing
`define OPCODE_HCF 4'b1000
//
// - Load
// ld rd, [ra]
// Copy in the register \rd the value stored at the address in 
// the register \ra
`define OPCODE_LOAD 4'b0010
//
// - Store
// st [ra], rb
// Store at the address in the register \rd the value stored 
// in the register \ra
`define OPCODE_STORE 4'b1010
//
// - Set
// set rd, imm
// Set the register \rd with the immediate value \imm 
`define OPCODE_SET 4'b0100
//
// - Duplicate
// dub rd, ra
// Set the register \rd with the value stored in the register \ra
`define OPCODE_DUP 4'b1100
//
// - Add
// add rd, ra, rb
// Add the values stored in the registers \ra and \rb and store the
// result in register \rd 
`define ALU_FUNC_ADD 3'b000
`define OPCODE_ADD ((`ALU_FUNC_ADD << 1) | 1'b1)
//
// - Substract
// sub rd, ra, rb
// Add the values stored in the registers \ra and \rb and store the
// result in register \rd 
`define ALU_FUNC_SUB 3'b100
`define OPCODE_SUB ((`ALU_FUNC_SUB << 1) | 1'b1)
//
// - Left shift
// lsh rd, ra, rb
`define ALU_FUNC_LSH 3'b001
`define OPCODE_LSH ((`ALU_FUNC_LSH << 1) | 1'b1)
//
// - Right shift
// lsh rd, ra, rb
`define ALU_FUNC_RSH 3'b101
`define OPCODE_RSH ((`ALU_FUNC_RSH << 1) | 1'b1)
//
// - Bitwise or
// or rd, ra, rb
`define ALU_FUNC_OR 3'b010
`define OPCODE_OR ((`ALU_FUNC_OR << 1) | 1'b1)
//
// - Bitwise and
// and rd, ra, rb
`define ALU_FUNC_AND 3'b110
`define OPCODE_AND ((`ALU_FUNC_AND << 1) | 1'b1)
//
// - Bitwise xor
// xor rd, ra, rb
`define ALU_FUNC_XOR 3'b011
`define OPCODE_XOR ((`ALU_FUNC_XOR << 1) | 1'b1)
//
// - Bitwise not
// xor ra, rb
`define ALU_FUNC_NOT 3'b111
`define OPCODE_NOT ((`ALU_FUNC_NOT << 1) | 1'b1)