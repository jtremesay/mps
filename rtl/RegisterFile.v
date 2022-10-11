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


module RegisterFile(
    input reg_d_enable,
    input [3:0] reg_d,
    input [`DMEM_DATA_WIDTH - 1:0] reg_d_value,

    input [3:0] reg_a,
    output [`DMEM_DATA_WIDTH - 1:0] reg_a_value,

    input [3:0] reg_b,
    output [`DMEM_DATA_WIDTH - 1:0] reg_b_value
); 
    // Declare the register
    reg [`DMEM_DATA_WIDTH - 1:0] r_regs [`REGS_COUNT - 1:1];
    
    // Bind regs A and B
    assign reg_a_value = reg_a == 0 ? 0 : r_regs[reg_a];
    assign reg_b_value = reg_b == 0 ? 0 : r_regs[reg_b];
    
    always @(*) begin
        if (reg_d_enable && reg_d != 0) begin
            r_regs[reg_d] <= reg_d_value;
        end
    end

endmodule