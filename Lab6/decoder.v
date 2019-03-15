// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// writeenable  (output) - should a new value be captured by the register file
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, rd_src, alu_src2, writeenable, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       rd_src, alu_src2, writeenable, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

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

    wire bne1 = (opcode == `OP_BNE);
    wire beq1 = (opcode == `OP_BEQ);
    wire j1 = (opcode == `OP_J);
    wire jr1 = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
    wire lui1 = (opcode == `OP_LUI);
    wire slt1 = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    wire lw1 = (opcode == `OP_LW);
    wire lbu1 = (opcode == `OP_LBU);
    wire sw1 = (opcode == `OP_SW);
    wire sb1 = (opcode == `OP_SB);
    wire addm1 = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

    wire all = add1 | sub1 | and1 | or1 | nor1 | xor1 | addi | andi | ori | xori | bne1 | beq1 | j1 | jr1 | lui1 | slt1 | lw1 | lbu1 | sw1 | sb1 | addm1;

    assign alu_op = add1 ? 3'b010 : (
                    sub1 ? 3'b011 : (
                    and1 ? 3'b100 : (
                    or1 ? 3'b101 : (
                    nor1 ? 3'b110 : (
                    xor1 ? 3'b111 : (
                    addi ? 3'b010 : (
                    andi ? 3'b100 : (
                    ori ? 3'b101 : (
                    xori ? 3'b111 : (
                    bne1 ? 3'b011 : (
                    beq1 ? 3'b011 : (
                    j1 ? 3'b000 : (
                    jr1 ? 3'b000 : (
                    lui1 ? 3'b000 : (
                    slt1 ? 3'b011 : (
                    lw1 ? 3'b010 : (
                    lbu1 ? 3'b010 : (
                    sw1 ? 3'b010 : (
                    sb1 ? 3'b010 : (
                    addm1 ? 3'b010 : 3'b000
                    ))))))))))))))))))));

    assign rd_src = add1 ? 0 : (
                    sub1 ? 0 : (
                    and1 ? 0 : (
                    or1 ? 0 : (
                    nor1 ? 0 : (
                    xor1 ? 0 : (
                    addi ? 1 : (
                    andi ? 1 : (
                    ori ? 1 : (
                    xori ? 1 : (
                    bne1 ? 1 : (
                    beq1 ? 1 : (
                    j1 ? 1 : (
                    jr1 ? 0 : (
                    lui1 ? 1 : (
                    slt1 ? 0 : (
                    lw1 ? 1 : (
                    lbu1 ? 1 : (
                    sw1 ? 1 : (
                    sb1 ? 1 : (
                    addm1 ? 0 : 0
                    ))))))))))))))))))));

    assign alu_src2 = add1 ? 0 : (
                    sub1 ? 0 : (
                    and1 ? 0 : (
                    or1 ? 0 : (
                    nor1 ? 0 : (
                    xor1 ? 0 : (
                    addi ? 1 : (
                    andi ? 1 : (
                    ori ? 1 : (
                    xori ? 1 : (
                    bne1 ? 0 : (
                    beq1 ? 0 : (
                    j1 ? 1 : (
                    jr1 ? 0 : (
                    lui1 ? 1 : (
                    slt1 ? 0 : (
                    lw1 ? 1 : (
                    lbu1 ? 1 : (
                    sw1 ? 1 : (
                    sb1 ? 1 : (
                    addm1 ? 0 : 0
                    ))))))))))))))))))));

    assign control_type = add1 ? 0 : (
                    sub1 ? 0 : (
                    and1 ? 0 : (
                    or1 ? 0 : (
                    nor1 ? 0 : (
                    xor1 ? 0 : (
                    addi ? 0 : (
                    andi ? 0 : (
                    ori ? 0 : (
                    xori ? 0 : (
                    (bne1 & ~zero) ? 1 : (
                    (beq1 & zero) ? 1 : (
                    j1 ? 2 : (
                    jr1 ? 3 : (
                    lui1 ? 0 : (
                    slt1 ? 0 : (
                    lw1 ? 0 : (
                    lbu1 ? 0 : (
                    sw1 ? 0 : (
                    sb1 ? 0 : (
                    addm1 ? 0 : 0
                    ))))))))))))))))))));

    assign writeenable = add1 ? 1 : (
                    sub1 ? 1 : (
                    and1 ? 1 : (
                    or1 ? 1 : (
                    nor1 ? 1 : (
                    xor1 ? 1 : (
                    addi ? 1 : (
                    andi ? 1 : (
                    ori ? 1 : (
                    xori ? 1 : (
                    bne1 ? 0 : (
                    beq1 ? 0 : (
                    j1 ? 0 : (
                    jr1 ? 0 : (
                    lui1 ? 1 : (
                    slt1 ? 1 : (
                    lw1 ? 1 : (
                    lbu1 ? 1 : (
                    sw1 ? 0 : (
                    sb1 ? 0 : (
                    addm1 ? 1 : 0
                    ))))))))))))))))))));

    assign mem_read = lbu1 ? 1 : (
               lw1 ? 1 : (
               addm ? 1 : 0
               ));

    assign word_we = sw1 ? 1 : 0;
    assign byte_we = sb1 ? 1 : 0;
    assign byte_load = lbu1 ? 1 : 0;
    assign slt = slt1;
    assign lui = lui1;
    assign addm = addm1;

    assign except = all ? 0 : 1;

endmodule // mips_decode
