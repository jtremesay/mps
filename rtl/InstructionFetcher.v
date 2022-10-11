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


module InstructionFetcher(
    input [`IMEM_ADDR_WIDTH - 1:0] pc,
    output [`IMEM_DATA_WIDTH - 1:0] instr,
    output [`IMEM_ADDR_WIDTH - 1:0] mem_addr,
    input [`IMEM_DATA_WIDTH - 1:0] mem_value
);
    assign mem_addr = pc;
    assign instr = mem_value;
endmodule