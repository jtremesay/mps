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


module ALU(
    input [`DMEM_DATA_WIDTH - 1:0] a,
    input [`DMEM_DATA_WIDTH - 1:0] b,
    output reg [`DMEM_DATA_WIDTH - 1:0] z,
    input [2:0] func,
    input enable
);
    always @(*) begin
        if (enable) begin
            case (func)
                `ALU_FUNC_ADD: z <= a + b;
                `ALU_FUNC_SUB: z <= a - b;
                `ALU_FUNC_LSH: z <= a << b;
                `ALU_FUNC_RSH: z <= a >> b;
                `ALU_FUNC_OR: z <= a | b;
                `ALU_FUNC_AND: z <= a & b;
                `ALU_FUNC_XOR: z <= a ^ b;
                `ALU_FUNC_NOT: z <= ~a;
                default: z <= 0;
            endcase
        end else begin
            z <= a;
        end
    end
endmodule