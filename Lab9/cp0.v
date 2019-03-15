`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;
wire [31:0] decode, userStatus;
    wire resetEx, enableEPC, exceptionLevel;
    wire [29:0] D;
    wire [31:0] causeReg, statusReg;
    wire andup, anddown, notup;

    // your Verilog for coprocessor 0 goes here

    assign statusReg = {16'b0, userStatus[15:8], 6'b0, exceptionLevel, userStatus[0]};
    assign causeReg = {16'b0, TimerInterrupt, 15'b0};

    decoder32 enable(decode, regnum, MTC0);
    register #(32) userStatus0(userStatus, wr_data, clock, decode[12], reset);

    or or0(resetEx, reset, ERET);
    dffe exceptionLevel0(exceptionLevel, 1'b1, clock, TakenInterrupt, resetEx);

    mux2v #(30) wrdataOrNextPC(D, wr_data[31:2], next_pc, TakenInterrupt);
    or or1(enableEPC, decode[14], TakenInterrupt);
    register #(30) EPCRegister(EPC, D, clock, enableEPC, reset);

    and and0(andup, causeReg[15], statusReg[15]);
    not n0(notup, statusReg[1]);
    and and1(anddown, notup, statusReg[0]);
    and and2(TakenInterrupt, andup, anddown);

    mux3v mux0(rd_data, statusReg, causeReg, {EPC, 2'b0}, regnum[1:0]);
endmodule
