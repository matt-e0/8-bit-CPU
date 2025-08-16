`timescale 1ns/1ps

module tb_cpu;
    reg clk = 0;
    reg reset = 1;

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz simulated clock

    // Instantiate CPU
    cpu DUT (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("dump.vcd");   // Waveform output file
        $dumpvars(0, tb_cpu);

        #20 reset = 0;           // Release reset after 20ns

        #2000 $finish;           // End simulation after 2000ns
    end
endmodule
