`include "config.inc.v"


module ProgramCounter(
    output reg [`IMEM_ADDR_WIDTH - 1:0] pc,
    input clock,
    input nreset
);
    always @(posedge clock) begin
        if (!nreset) begin
            pc <= 0;
        end else begin
            pc <= pc + 1;
        end
    end
endmodule