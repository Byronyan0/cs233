module blackbox_test;
reg l, s, q;                           // these are inputs to "circuit under test"
                                          // use "reg" not "wire" so can assign a value
wire m;                        // wires for the outputs of "circuit under test"

blackbox sc1 (m, l, s, q);  // the circuit under test

initial begin                             // initial = run at beginning of simulation
                                          // begin/end = associate block with initial

    $dumpfile("blackbox.vcd");                  // name of dump file to create
    $dumpvars(0,blackbox_test);                 // record all signals of module "sc_test" and sub-modules
                                          // remember to change "sc_test" to the correct
                                          // module name when writing your own test benches

    // test all four input combinations
    // remember that 2 inputs means 2^2 = 4 combinations
    // 3 inputs would mean 2^3 = 8 combinations to test, and so on
    // this is very similar to the input columns of a truth table
    l = 0; s = 0; q = 0; # 10;             // set initial values and wait 10 time units
    l = 0; s = 0; q = 1; # 10;             // change inputs and then wait 10 time units
    l = 0; s = 1; q = 0; # 10;               // as above
    l = 0; s = 1; q = 1; # 10;
    l = 1; s = 0; q = 0; # 10;
    l = 1; s = 0; q = 1; # 10;
    l = 1; s = 1; q = 0; # 10;
    l = 1; s = 1; q = 1; # 10;


    $finish;                              // end the simulation
end

initial
    $monitor("At time %2t, l = %d s = %d q = %d m = %d",
             $time, l, s, q, m);
endmodule // blackbox_test
