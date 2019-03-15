// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable (output) - should a new value be captured by the register file
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, opcode, funct);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    input  [5:0] opcode, funct;

    wire add1 = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    wire sub1 = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    wire and1 = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    wire or1 = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    wire nor1 = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    wire xor1 = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);
    wire all = add1 | sub1 | and1 | or1 | nor1 | xor1 | addi | andi | ori | xori;

    assign alu_op = add1 ? 3'b010 : (
                    sub1 ? 3'b011 : (
                    and1 ? 3'b100 : (
                    or1 ? 3'b101 : (
                    nor1 ? 3'b110 : (
                    xor1 ? 3'b111 : (
                    addi ? 3'b010 : (
                    andi ? 3'b100 : (
                    ori ? 3'b101 : (
                    xori ? 3'b111 : 3'b000
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    );

    assign rd_src = add1 ? 0 : (
                    sub1 ? 0 : (
                    and1 ? 0 : (
                    or1 ? 0 : (
                    nor1 ? 0 : (
                    xor1 ? 0 : (
                    addi ? 1 : (
                    andi ? 1 : (
                    ori ? 1 : (
                    xori ? 1 : 0
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    );

    assign alu_src2 = add1 ? 0 : (
                    sub1 ? 0 : (
                    and1 ? 0 : (
                    or1 ? 0 : (
                    nor1 ? 0 : (
                    xor1 ? 0 : (
                    addi ? 1 : (
                    andi ? 1 : (
                    ori ? 1 : (
                    xori ? 1 : 0
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    )
                    );




    assign writeenable = all ? 1 : 0;
    assign except = all ? 0 : 1;

endmodule // mips_decode
