module alu(
    input [15:0] A,
    input [15:0] B,
    input Ext_cin,
    input [4:0] ALUop,
    output reg [15:0] y,
    output z, // Zero flag
    output n, // Negative flag
    output reg c, // Carry flag
    output reg v, // Signed overflow flag
);
    // CLA
    localparam ADD = 5'b00000; // Add
    localparam ADC = 5'b00001; // Add-carry
    localparam SUB = 5'b00010; // Subtract
    localparam SBC = 5'b00011; // Subtract-carry
    localparam AND = 5'b00100; 
    localparam OR = 5'b00101;
    localparam XOR = 5'b00110;
    localparam NOT = 5'b00111;

    localparam LSL = 5'b01000; // Logical shift left
    localparam LSR = 5'b01001; // Logical shift right
    localparam ASR = 5'b01010; // Arithmetic shift right
    localparam ROL = 5'b01011; // Roll left
    localparam ROR = 5'b01100; // Roll right

    // MOV = 5'b01101; // Move
    // LD = 5'b01110; // Load
    // ST = 5'b01111; // Store
    // JMP = 5'b10000; // Jump
    // JZ = 5'b10001; // Jump if zero
    // JC = 5'b10010;
    // ...

    /*
    [15:12] Opcode
    [11:8]  Dest Reg
    [7:4]   Src Reg
    [3:0]   Unused / flags
    */





    wire add_operation = (ALUop==ADD) | (ALUop==ADC);
    wire sub_operation = (ALUop==SUB) | (ALUop==SBC);

    wire [15:0] B_eff = sub_operation ? ~B : B;
    wire Cin_eff = (ALUop==ADD) ? 1'b0 :
                    (ALUop==ADC) ? Ext_cin :
                    (ALUop==SUB) ? 1'b1 :
                    (ALUop==SBC) ? Ext_cin : 1'b0;

    wire [15:0] add_sum;
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
        y = 16'h0000;
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
            ROR: begin
                y = {Ext_cin, A[7:1]};
                c = A[0];
            end
            ROL: begin
                y = {A[6:0], Ext_cin};
                c = A[7];
            end
            default: begin
                y = 16'h0000;
            end
        endcase
    end
    assign z = (y == 16'h0000);
    assign n = y[15];
endmodule