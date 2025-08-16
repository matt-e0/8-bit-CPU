`timescale 1ps/1ps

module tb_alu;
    reg  [7:0] A, B;
    reg        Ext_cin;
    reg  [3:0] ALUop;
    wire [7:0] y;
    wire       z, n, c, v, bor;

    alu DUT (
        .A(A), .B(B),
        .Ext_cin(Ext_cin),
        .ALUop(ALUop),
        .y(y),
        .z(z),
        .n(n),
        .c(c),
        .v(v),
        .bor(bor)
    );

     initial begin
        $dumpfile("dumpalu.vcd");
        $dumpvars(0, tb_alu);

        // Test ADD
        A=8'd5; B=8'd10; Ext_cin=0; ALUop=4'b0000; #10;
        $display("ADD: 5+10 = %0d, y=%0d c=%b v=%b", A,B,y,c,v);

        // Test SUB
        A=8'd15; B=8'd10; Ext_cin=0; ALUop=4'b0010; #10;
        $display("SUB: 15-10 = %0d, y=%0d c=%b v=%b", A,B,y,c,v);

        // Test AND
        A=8'hF0; B=8'h0F; ALUop=4'b0100; #10;
        $display("AND: F0 & 0F = %h, y=%h", A,B,y);

        // Test OR
        A=8'hF0; B=8'h0F; ALUop=4'b0101; #10;
        $display("OR:  F0 | 0F = %h, y=%h", A,B,y);

        // Test XOR
        A=8'hAA; B=8'h55; ALUop=4'b0110; #10;
        $display("XOR: AA ^ 55 = %h, y=%h", A,B,y);

        // Test NOT
        A=8'h0F; ALUop=4'b0111; #10;
        $display("NOT: ~0F = %h, y=%h", A,y);

        // Test shift
        A=8'b10010001; ALUop=4'b1000; #10; // LSR
        $display("LSR: A=%b, y=%b c=%b", A,y,c);

        A=8'b10010001; ALUop=4'b1001; #10; // LSL
        $display("LSL: A=%b, y=%b c=%b", A,y,c);

        // Done
        $finish;
    end
endmodule
