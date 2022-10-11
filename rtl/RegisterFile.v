`include "config.inc.v"


module RegisterFile(
    input reg_d_enable,
    input [3:0] reg_d,
    input [`DMEM_DATA_WIDTH - 1:0] reg_d_value,

    input [3:0] reg_a,
    output [`DMEM_DATA_WIDTH - 1:0] reg_a_value,

    input [3:0] reg_b,
    output [`DMEM_DATA_WIDTH - 1:0] reg_b_value,

    input clock,
    input nreset
); 
    // Declare the register
    reg [`DMEM_DATA_WIDTH - 1:0] r_regs [`REGS_COUNT - 1:0];
    
    // Bind regs A and B
    assign reg_a_value = r_regs[reg_a];
    assign reg_b_value = r_regs[reg_b];
    
    integer i;
    always @(negedge clock) begin
        if (!nreset) begin
            for (i = 0; i < `REGS_COUNT; i = i + 1) begin
                r_regs[i] <= 0;
            end
        end else begin
            if (reg_d_enable && reg_d != 0) begin
                r_regs[reg_d] <= reg_d_value;
            end
        end
    end

endmodule