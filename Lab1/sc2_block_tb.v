module sc2_test;
reg a_in, b_in, cin_in;                           // these are inputs to "circuit under test"
                                          // use "reg" not "wire" so can assign a value
wire s_out, c_out;                        // wires for the outputs of "circuit under test"

sc2_block sc2 (s_out, c_out, a_in, b_in, cin_in);  // the circuit under test

initial begin                             // initial = run at beginning of simulation
                                          // begin/end = associate block with initial

    $dumpfile("sc2.vcd");                  // name of dump file to create
    $dumpvars(0,sc2_test);                 // record all signals of module "sc_test" and sub-modules
                                          // remember to change "sc_test" to the correct
                                          // module name when writing your own test benches

    // test all four input combinations
    // remember that 2 inputs means 2^2 = 4 combinations
    // 3 inputs would mean 2^3 = 8 combinations to test, and so on
    // this is very similar to the input columns of a truth table
    a_in = 0; b_in = 0; cin_in = 0; # 10;             // set initial values and wait 10 time units
    a_in = 0; b_in = 0; cin_in = 1; # 10;
    a_in = 0; b_in = 1; cin_in = 0; # 10;
    a_in = 0; b_in = 1; cin_in = 1; # 10;
    a_in = 1; b_in = 0; cin_in = 0; # 10;
    a_in = 1; b_in = 0; cin_in = 1; # 10;
    a_in = 1; b_in = 1; cin_in = 0; # 10;
    a_in = 1; b_in = 1; cin_in = 1; # 10;

    $finish;                              // end the simulation
end

initial
    $monitor("At time %2t, a_in = %d b_in = %d cin_in = %d s_out = %d c_out = %d",
             $time, a_in, b_in, cin_in, s_out, c_out);
endmodule // sc2_test
