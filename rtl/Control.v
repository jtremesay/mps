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


module Control(
    input [3:0] opcode,
    output reg_d_enable,
    output use_imm,
    output alu_enable,
    output [2:0] alu_func,
    output mem_read,
    output mem_write,
    output fire_starting
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
    assign fire_starting = opcode == `OPCODE_HCF;
endmodule