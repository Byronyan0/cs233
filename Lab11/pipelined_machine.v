module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];

    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;

    wire [31:2]  PC_plus4_new, PC_for_stalling, next_PC_old;
    wire [31:0]  inst_old;
    wire [31:0]  alu_out_data_old;
    wire [31:0]  rd1_data_new, rd2_data_new, wr_data_new, rd2_data_new2;
    wire [4:0]   wr_regnum_MW;
    wire         ForwardA, ForwardB, MemToReg_MW, flush, RegWrite_new, MemWrite_new, MemRead_new, stall; 

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_new, imm[29:0]);
    mux2v #(30) branch_mux(next_PC_old, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_old, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_new, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data_new, imm, ALUSrc);
    alu32 alu(alu_out_data_old, zero, ALUOp, rd1_data_new, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data, rd2_data_new2, MemRead_new, MemWrite_new, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

    assign flush = PCSrc || reset || stall;

    register #(30, 30'd0) IFDE1(PC_plus4_new, PC_plus4, clk, 1'b1, reset);
    register #(32, 32'd0) IFDE2(inst, inst_old, clk, 1'b1, reset);

    register #(32, 32'd0) DEMW1(alu_out_data, alu_out_data_old, clk, 1'b1, reset);
    register #(32, 32'd0) DEMW2(rd2_data_new2, rd2_data_new, clk, 1'b1, flush);
    register #(5, 5'd0) DEMW4(wr_regnum_MW, wr_regnum, clk, 1'b1, reset);

    mux2v forwarda(rd1_data_new, rd1_data, alu_out_data, ForwardA);
    mux2v forwardb(rd2_data_new, rd2_data, alu_out_data, ForwardB);

    register #(1, 1'd0) controlMTR(MemToReg_MW, MemToReg, clk, 1'b1, reset);
    register #(1, 1'd0) controlRW(RegWrite_new, RegWrite, clk, 1'b1, reset);
    register #(1, 1'd0) controlMR(MemRead_new, MemRead, clk, 1'b1, reset);
    register #(1, 1'd0) controlMW(MemWrite_new, MemWrite, clk, 1'b1, reset);

    assign ForwardA = (rs == wr_regnum_MW) && RegWrite_new && (rs != 0);
    assign ForwardB = (rt == wr_regnum_MW) && RegWrite_new && (rt != 0);

    assign stall = MemRead_new && ((rs == wr_regnum_MW) || (rt == wr_regnum_MW)) && (rs != 0) && (rt != 0);
    assign PC_for_stalling = PC[31:2];
    mux2v #(30) st(next_PC, next_PC_old, PC_for_stalling, stall);
    
    
endmodule // pipelined_machine

