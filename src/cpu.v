module cpu (
    input  wire        clk,
    input  wire        reset,
    output reg  [15:0] pc,
    input  wire [15:0] instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            pc <= pc + 1; // simple increment for now
        end
    end

endmodule