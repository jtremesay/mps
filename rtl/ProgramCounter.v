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


module ProgramCounter(
    output reg [`IMEM_ADDR_WIDTH - 1:0] pc,
    input clock,
    input nreset,
    input on_fire
);
    always @(posedge clock) begin
        if (!nreset) begin
            pc <= 0;
        end else if (!on_fire) begin
            pc <= pc + 1;
        end
    end
endmodule