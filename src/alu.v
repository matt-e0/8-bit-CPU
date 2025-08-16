module alu(
    input [7:0] A,
    input [7:0] B,
    input Ext_cin,
    input [3:0] ALUop,
    output reg [7:0] y,
    output z, // Zero flag
    output n, // Negative flag
    output reg c, // Carry flag
    output reg v, // Signed overflow flag
    output bor
);
    // CLA
    localparam ADD = 4'b0000; // Add
    localparam ADC = 4'b0001; // Add-Carry
    localparam SUB = 4'b0010; // Subtract
    localparam SBC = 4'b0011; // Subtract-Carry

    localparam AND = 4'b0100; // AND
    localparam OR = 4'b0101; // OR
    localparam XOR = 4'b0110; // XOR
    localparam NOT = 4'b0111; // NOT
    localparam LSR = 4'b1000; // Logical shift right
    localparam LSL = 4'b1001; // Logical shift left
    localparam ASR = 4'b1010; // Arithmatic shift right
    //localparam ASL = 4'b1011; // Arithmatic shift left
    localparam ROR = 4'b1100; // Roll right
    localparam ROL = 4'b1101; // Roll left
    localparam PSA = 4'b1110; // Pass A
    localparam PSB = 4'b1111; // Pass B

    wire add_operation = (ALUop==ADD) | (ALUop==ADC);
    wire sub_operation = (ALUop==SUB) | (ALUop==SBC);

    wire [7:0] B_eff = sub_operation ? ~B : B;
    wire Cin_eff = (ALUop==ADD) ? 1'b0 :
                    (ALUop==ADC) ? Ext_cin :
                    (ALUop==SUB) ? 1'b1 :
                    (ALUop==SBC) ? Ext_cin : 1'b0;

    wire [7:0] add_sum;
    wire add_cout;
    wire add_ovf;

    CLA u_adder (
        .a(A),
        .b(B_eff),
        .cin(Cin_eff),
        .s(add_sum),
        .cout(add_cout),
        .ovf(add_ovf)
    );

    always @* begin
        y = 8'h00;
        c = 1'b0;
        v = 1'b0;

        case(ALUop)
            ADD, ADC: begin
                y = add_sum;
                c = add_cout;
                v = add_ovf;
            end 
            SUB, SBC: begin
                y = add_sum;
                c = add_cout;
                v = add_ovf;
            end
            AND: begin
                y = A & B;
            end
            OR: begin
                y = A | B;
            end
            XOR: begin
                y = A ^ B;
            end
            NOT: begin
                y = ~A;
            end
            LSR: begin
                y = {1'b0, A[7:1]};
                c = A[0];
            end
            LSL: begin
                y = {A[6:0], 1'b0};
                c = A[7];
            end
            ASR: begin
                y = {A[7], A[7:1]};
                c = A[0];
            end
            /*ASL: begin
                y = {A[6:0], 1'b0};
                c = A[7];
            end*/
            ROR: begin
                y = {Ext_cin, A[7:1]};
                c = A[0];
            end
            ROL: begin
                y = {A[6:0], Ext_cin};
                c = A[7];
            end
            PSA: y = A;
            PSB: y = B;
            default: begin
                y = 8'h00;
            end
        endcase
    end
    assign bor = sub_operation ? ~add_cout : 1'b0;
    assign z = (y == 8'h00);
    assign n = y[7];
endmodule