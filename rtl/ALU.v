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