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