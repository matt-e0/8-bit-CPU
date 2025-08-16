module memory #(parameter WIDTH=8, DEPTH=256) (
    input clk,
    input [7:0] addr,
    output reg [WIDTH-1:0] data
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    initial $readmemb("src/program.mem", mem); // Load binary file
endmodule
