`timescale 1ns / 1ps

`define CLOCK_DELAY 10


module Testbench();
    wire [7:0] r_imem_addr;
    wire [15:0] r_imem_value;
    wire [7:0] r_dmem_addr;
    wire r_dmem_wenable;
    wire [7:0] r_dmem_rvalue;
    wire [7:0] r_dmem_wvalue;
    reg clock;
    reg nreset;

    // Clock
    initial begin
        clock <= 0;
        nreset <= 1;
    end

    always begin
        #(`CLOCK_DELAY / 2) clock <= !clock;
    end

    // Instructions memory
    reg [15:0] r_imem [255:0];
    initial begin
        $readmemh("instructions.mem", r_imem);
    end
    assign r_imem_value = r_imem[r_imem_addr];

    // Data memory
    reg [7:0] r_dmem [255:0];
    assign r_dmem_rvalue = r_dmem[r_dmem_addr];
    always @(*) begin
        if (r_dmem_wenable) begin
            r_dmem[r_dmem_addr] <= r_dmem_wvalue;
        end 
    end

    // Device under test
    MPSCPU dut(
        .imem_addr(r_imem_addr),
        .imem_value(r_imem_value),
        .dmem_addr(r_dmem_addr),
        .dmem_wenable(r_dmem_wenable),
        .dmem_rvalue(r_dmem_rvalue),
        .dmem_wvalue(r_dmem_wvalue),
        .clock(clock),
        .nreset(nreset)
    );

    // Testbench
    initial begin
        $dumpfile("dut.vcd");
        $dumpvars(0, dut);

        // Reset the DUT
        #(`CLOCK_DELAY)
        nreset <= 0;
        #(`CLOCK_DELAY)
        nreset <= 1;

        // Run for some cycles
        #(`CLOCK_DELAY * 256)
        $finish;
    end
endmodule