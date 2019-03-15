#include "declarations.h"

void
t6(float *restrict A, float *restrict R) {
    for (int nl = 0; nl < ntimes; nl ++) {
        A[0] = 0;
        #pragma clang loop vectorize_width(4) interleave_count(2)
        for (int i = 0; i < (LEN6 - 3); i ++) {
            R[i + 1] = A[i] + (float) 2.0;
            A[i] = R[i + 2] + (float) 1.0;
        }
    }
}
