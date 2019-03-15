
module palindrome_control(palindrome, done, select, load, go, a_ne_b, front_ge_back, clock, reset);
	output palindrome, done, select, load;
	input go, a_ne_b, front_ge_back;
	input clock, reset;

	wire sGarbage, sStart, sP, sNp, stest;

	wire sGarbage_next = (sGarbage & ~go) | reset;
	wire sStart_next = ((sStart & go) | (sGarbage & go) | sP & go | sNp & go) & ~reset;
	wire stest_next =((sStart & ~go) | (stest & ~a_ne_b & ~front_ge_back)) & ~reset;
	wire sNp_next = ((stest & a_ne_b) | sNp & ~go ) & ~reset;
	wire sP_next = ((stest & ~a_ne_b & front_ge_back) | sP & ~go) & ~reset;

	dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe fsStart(sStart, sStart_next, clock, 1'b1, 1'b0);
	dffe fstest(stest, stest_next, clock, 1'b1, 1'b0);
	dffe fsSp(sP, sP_next, clock, 1'b1, 1'b0);
	dffe fssNp(sNp, sNp_next, clock, 1'b1, 1'b0);

	assign palindrome = sP;
	assign done = sNp | sP;
	assign select = stest;
	assign load = stest | sStart;

endmodule // palindrome_control
