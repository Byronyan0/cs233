module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here
    wire timeWrite, timeRead, acknoledge, resetOr;
    wire [31:0] Q1, Q2, D2;
    wire QEQ, AEQ1, AEQ2;

    assign QEQ = (Q1 == Q2);
    assign AEQ1 = (address == 32'hffff001c);
    assign AEQ2 = (address == 32'hffff006C);

    and and1(timeRead, AEQ1, MemRead);
    and and2(timeWrite, AEQ1, MemWrite);
    or or1(TimerAddress, AEQ1, AEQ2);
    and and3(acknoledge, AEQ2, MemWrite);

    register #(32, 32'hffffffff) interruptCycle(Q1, data, clock, timeWrite, reset);
    register #(32) cycleCounter(Q2, D2, clock, 1'b1, reset);

    alu32 alu(D2, , , `ALU_ADD, Q2, 32'b1);

    tristate t(cycle, Q2, timeRead);
    or or0(resetOr, acknoledge, reset);
    dffe interruptLine(TimerInterrupt, 1'b1, clock, QEQ, resetOr);

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
