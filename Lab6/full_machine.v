// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC, nextPC;

    wire zero0, negative0, overflow0, zero1, negative1, negative1Real,  overflow1, zero2, negative2, overflow2, zero3, negative3, overflow3;
    wire [31:0] t0, t1, t2, t3, bo;

    wire [2:0] alu_op;
    wire ex, rd_src, alu_src2, wr_enable;
    wire [1:0] control_type;
    wire mem_read, word_we, byte_we, byte_load, slt, lui, addm;

    wire [4:0] rdNum;
    wire [31:0] rsData, rdData, rtData, rdDataNormal, addmOp;


    wire [31:0] out;

    wire [31:0] lui1, imm32, B, aluB;

    wire [31:0] slt1, mem0;

    wire [31:0] data_out;

    wire [7:0] lworlb;
    wire [31:0] byte_load1, mem1;

    wire[31:0] lui0;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
    alu32 pcPlus4(t0, zero0, negative0, overflow0, PC, 32'h00000004, 3'b010);
    alu32 normalOrBranch(t1, zero2, negative2, overflow2, t0, bo, 3'b010);
    assign t2 = {PC[31:28], inst[25:0], 2'b00};
    assign t3 = rsData;
    mux4v control(nextPC, t0, t1, t2, t3, control_type);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    mips_decode md(alu_op, rd_src, alu_src2, wr_enable, ex, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], zero1);
    mux2v #(5) rTypeORiType(rdNum, inst[15:11], inst[20:16], rd_src);
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], rdNum, rdData, wr_enable, clock, reset);

    /* add other modules */
    assign lui1 = {inst[15:0], 16'b0000000000000000};
    assign imm32 = {{16{inst[15]}}, inst[15:0]};
    assign bo = {imm32[29:0], 2'b00};
    mux2v mrtdataimm(B, rtData, imm32, alu_src2);
    alu32 mainALU(out, zero1, negative1, overflow1, rsData, aluB, alu_op);

    assign negative1Real = overflow1 ? ~negative1 : negative1;
    assign slt1 = {31'b0000000000000000000000000000000, negative1Real};
    mux2v sltOrNot(mem0, out, slt1, slt);

    data_mem dm(data_out, out, rtData, word_we, byte_we, clock, reset);
    mux4v #(8) choose(lworlb, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
    assign byte_load1 = {24'b000000000000000000000000, lworlb};
    mux2v byte_loadOrNot(mem1, data_out, byte_load1, byte_load);

    mux2v memOrNot(lui0, mem0, mem1, mem_read);

    mux2v r(rdDataNormal, lui0, lui1, lui);
    assign except = ex;

    mux2v addmOrNot(aluB, B, 32'b0000000000000000000000, addm);
    alu32 addmalu(addmOp, zero3, negative3, overflow3, data_out, rtData, 3'b010);
    mux2v rdDataChoosing(rdData, rdDataNormal, addmOp, addm);


endmodule // full_machine
