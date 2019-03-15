// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator
#include <cstdio>
using std::printf;

int
main() {
    int width = 32;

    printf("    wire [31:0] cout;\n");

    printf("    wire ab, nab, test;\n");

    printf("    alu1 a%d(out[%d], cout[%d], A[%d], B[%d], control[%d], control);\n", 0, 0, 0, 0, 0, 0);

    for(int i = 1; i < width; i++)
        printf("    alu1 a%d(out[%d], cout[%d], A[%d], B[%d], cout[%d], control);\n", i, i, i, i, i, i-1);

    printf("\n");

    printf("    nor x0(zero, ");
    for (int i = 0; i < width; i ++){
        printf("out[%d]", i);
        if(i == width - 1)
            break;
        printf(",");
    }

    printf(");\n");

    printf("    or d1(negative, out[%d], 0);\n", 31);

    printf("     xor o_out(overflow, cout[%d], cout[%d]);;\n", 31, 30);

    return 0;
}
