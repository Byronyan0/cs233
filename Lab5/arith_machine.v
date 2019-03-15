// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC, out;
    wire [31:0] nextPC, rsdata, B, rtData, imm32;
    wire zero0, negative0, overflow0, zero1, negative1, overflow1;
    wire [2:0] alu_op;
    wire [4:0] rdNum;
    wire ex, rd_src, alu_src2, wr_enable;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( PC, nextPC, clock, 1'b1, reset );

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    mips_decode md(alu_op, rd_src, alu_src2, wr_enable, ex, inst[31:26], inst[5:0] );
    mux2v #(5) mrdrt(rdNum, inst[15:11], inst[20:16], rd_src);
    regfile rf (rsdata, rtData, inst[25:21], inst[20:16], rdNum, out, wr_enable, clock, reset );

    /* add other modules */
    alu32 a(nextPC, zero0, negative0, overflow0, PC, 32'h00000004, 3'b010);
    alu32 b(out, zero1, negative1, overflow1, rsdata, B, alu_op);

    assign imm32 = {{16{inst[15]}}, inst[15:0]};
    mux2v mrtdataimm(B, rtData, imm32, alu_src2);

    assign except = ex;


endmodule // arith_machine
