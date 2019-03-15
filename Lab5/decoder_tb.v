module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction
        # 10 opcode = `OP_ANDI;
        # 10 opcode = `OP_ORI;
        # 10 opcode = `OP_XORI;
        # 10 opcode = `OP_ADDI;
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB;
        # 10 opcode = `OP_OTHER0; funct = `OP0_AND;
        # 10 opcode = `OP_OTHER0; funct = `OP0_OR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_NOR;
        # 10 opcode = `OP_OTHER0; funct = `OP0_XOR;
        // add more tests here!

        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       rd_src, alu_src2, writeenable, except;
    mips_decode decoder(alu_op, rd_src, alu_src2, writeenable, except,
                        opcode, funct);
endmodule // decoder_test
