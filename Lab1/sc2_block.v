// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, c, a, b, cin);
    output s, c;
    input  a, b, cin;
    wire SA, c1, c2;

    sc_block scOne (SA, c1, a, b);
    sc_block scTwo (s, c2, SA, cin);
    or o1(c, c1, c2);

endmodule
