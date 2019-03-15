/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned a = 0b01010101010101010101010101010101;
	unsigned b = 0b10101010101010101010101010101010;
	unsigned rc1 = input & a;
	unsigned lc1 = input & b;
	lc1 = lc1 >> 1;
	unsigned result = lc1 + rc1;

	unsigned c = 0b00110011001100110011001100110011;
	unsigned d = 0b11001100110011001100110011001100;
	unsigned rc2 = result & c;
	unsigned lc2 = result & d;
	lc2 = lc2 >> 2;
	result = rc2 + lc2;

	unsigned e = 0b00001111000011110000111100001111;
	unsigned f = 0b11110000111100001111000011110000;
	unsigned rc3 = result & e;
	unsigned lc3 = result & f;
	lc3 = lc3 >> 4;
	result = rc3 + lc3;

	unsigned g = 0b00000000111111110000000011111111;
	unsigned h = 0b11111111000000001111111100000000;
	unsigned rc4 = result & g;
	unsigned lc4 = result & h;
	lc4 = lc4 >> 8;
	result = rc4 + lc4;

	unsigned i = 0b00000000000000001111111111111111;
	unsigned j = 0b11111111111111110000000000000000;
	unsigned rc5 = result & i;
	unsigned lc5 = result & j;
	lc5 = lc5 >> 16;
	result = rc5 + lc5;

	return result;
}
