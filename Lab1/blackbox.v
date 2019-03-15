module blackbox(m, l, s, q);
    output m;
    input  l, s, q;
    wire   w04, w08, w09, w18, w20, w21, w22, w23, w27, w28, w29, w36, w42, w45, w50, w62, w79, w80, w84, w85, w92, w98, w99;
    or  o66(m, w79, w20, w23);
    and a56(w79, w29, w21, w62);
    not n10(w62, w98);
    and a76(w20, w21, w98, w29);
    and a65(w23, w80, w22);
    not n72(w80, w21);
    or  o93(w22, w50, w04);
    and a59(w50, w29, w98);
    and a94(w04, w18, w29);
    not n35(w18, w98);
    or  o88(w21, w85, w09);
    and a74(w85, w92, q);
    not n89(w92, l);
    and a54(w09, w42, l, s);
    not n15(w42, q);
    and a47(w98, w36, w28);
    not n2(w36, q);
    or  o32(w28, w99, w27);
    not n39(w99, s);
    not n26(w27, l);
    or  o61(w29, w08, w45, w84);
    not n70(w08, l);
    not n14(w45, s);
    not n58(w84, q);
endmodule // blackbox
