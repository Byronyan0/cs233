// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire a, o, no, xo;

    and a1(a, A, B);
    or o1(o, A, B);
    nor n1(no, A, B);
    xor x1(xo, A, B);

    mux4 r(out, a, o, no, xo, control);

endmodule // logicunit
