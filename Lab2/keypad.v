module keypad(valid, number, a, b, c, d, e, f, g);
    output 	valid;
    output [3:0] number;
    input 	a, b, c, d, e, f, g;

    wire ad, ae, af, bd, be, bf, cd, ce, cf;
    
    and a1(ad, a, d);
    and a2(ae, a, e);
    and a3(af, a, f);
    and a4(bd, b, d);
    and a5(be, b, e);
    and a6(bf, b, f);
    and a7(cd, c, d);
    and a8(ce, c, e);
    and a9(cf, c, f);

    or o1(number[3], bf, cf);

    or o2(number[2], ae, be, ce, af);

    or o3(number[1], bd, cd, ce, af);

    or o4(number[0], ad, cd, be, af, cf);

    or a10(valid, ad, ae, af, bd, be, bf, cd, ce, cf);
    
    

endmodule // keypad
