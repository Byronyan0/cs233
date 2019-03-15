#include "declarations.h"

#ifdef SCALAR
void
t6(float *A, float *R) {
    for (int nl = 0; nl < ntimes; nl ++) {
        A[0] = 0;
        for (int i = 0; i < (LEN6 - 3); i ++) {
            R[i + 1] = A[i] + (float) 2.0;
            A[i] = R[i + 2] + (float) 1.0;
        }
    }
}
#endif

int
main() {
    float *A = (float *) memalign(16, LEN6 * sizeof(float));
    float *R = (float *) memalign(16, LEN6 * sizeof(float));

    for (int i = 0; i < LEN6; i ++) {
        A[i] = (float) (i) / (float) LEN6;
        R[i] = (float) (i + 3) / (float) LEN6;
    }

    unsigned long long start_c, end_c, diff_c;
    start_c = __rdtsc();

    t6(A, R);

    end_c = __rdtsc();
    diff_c = end_c - start_c;
    float giga_cycle = diff_c / 1000000000.0;

    float ttt = (float) 0.;
    for (int i = 0; i < LEN6; i ++) {
        ttt += A[i];
    }
    printf("t6 took %f giga cycles and the result is: %f\n", giga_cycle, ttt);
}
