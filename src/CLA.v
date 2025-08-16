module CLA(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] s,
    output cout,
    output ovf // Overflow flag
);
    wire [7:0] p = a ^ b; //propagate
    wire [7:0] g = a & b; //generate

    wire c1 = g[0] | (p[0] & cin);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
     | (p[3] & p[2] & p[1] & p[0] & cin);
    wire c5 = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1])
     | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & cin);
    wire c6 = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2])
     | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
     | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
    wire c7 = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3])
     | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
     | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
    wire c8 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & g[3])
     | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
     | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);
    // si = pi xor ci, p is an 8 bit vector
    assign s = p ^ {c7, c6, c5, c4, c3, c2, c1, cin};
    assign cout = c8; // unsigned ovf
    assign ovf = c7 ^ c8; // signed ofv (2s comp max 127)
endmodule 