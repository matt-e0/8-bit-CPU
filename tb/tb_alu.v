`timescale 1ps/1ps

module tb_alu;
    reg  [15:0] A, B;
    reg        Ext_cin;
    reg  [4:0] ALUop;
    wire [15:0] y;
    wire       z, n, c, v;

    alu DUT (
        .A(A), .B(B),
        .Ext_cin(Ext_cin),
        .ALUop(ALUop),
        .y(y),
        .z(z),
        .n(n),
        .c(c),
        .v(v)
    );

     initial begin
        $dumpfile("dumpalu.vcd");
        $dumpvars(0, tb_alu);

        // Test ADD
        A=16'd5; B=16'd10; Ext_cin=0; ALUop=5'b00000; #10;
        //$display("ADD: 5+10 = %0d, y=%0d c=%b v=%b", A,B,y,c,v);

        // Test SUB
        A=16'd15; B=16'd10; Ext_cin=0; ALUop=5'b00010; #10;
        //$display("SUB: 15-10 = %0d, y=%0d c=%b v=%b", A,B,y,c,v);

        // Test AND
        A=16'h00F0; B=16'h000F; ALUop=5'b00100; #10;
        //$display("AND: F0 & 0F = %h, y=%h", A,B,y);

        // Test OR
        A=16'h00F0; B=16'h000F; ALUop=5'b00101; #10;
        //$display("OR:  F0 | 0F = %h, y=%h", A,B,y);

        // Test XOR
        A=16'h00AA; B=16'h0055; ALUop=5'b00110; #10;
        //$display("XOR: AA ^ 55 = %h, y=%h", A,B,y);

        // Test NOT
        A=16'h000F; ALUop=5'b00111; #10;
        //$display("NOT: ~0F = %h, y=%h", A,y);

        // Test shift
        A=16'h00FF; ALUop=5'b01000; #10; // LSL
        //$display("LSR: A=%b, y=%b c=%b", A,y,c);

        A=16'hFF00; ALUop=5'b01001; #10; // LSR
        //$display("LSL: A=%b, y=%b c=%b", A,y,c);
        
        // Done
        $finish;
    end
endmodule
