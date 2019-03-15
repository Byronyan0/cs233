#include <stdio.h>
#include <stdlib.h>
#include "filter.h"

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {
    filter1(image1, image2, 1);
    filter1(image1, image2, 2);
    filter1(image1, image2, 3);
    filter1(image1, image2, 4);
    filter1(image1, image2, 5);
    filter1(image1, image2, 6);
    for (int i = 1; i < SIZE - 1; i ++) {
        if(i < SIZE - 6)
            filter1(image1, image2, i + 5);
        if(i >= 2 && i < SIZE - 2)
            filter2(image1, image2, i);
        if(i < SIZE - 5)
            filter3(image2, i);
    }
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
        __builtin_prefetch (&image1[i+10], 0, 3);
		__builtin_prefetch (&image2[i+11], 1, 3);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
        __builtin_prefetch (&image1[i+10], 0, 3);
		__builtin_prefetch (&image2[i+12], 1, 3);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
        __builtin_prefetch (&image2[i+5], 0, 1);
    }
}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {
    filter1(image1, image2, 1);
    filter1(image1, image2, 2);
    filter1(image1, image2, 3);
    filter1(image1, image2, 4);
    filter1(image1, image2, 5);
    filter1(image1, image2, 6);
    for (int i = 1; i < SIZE - 1; i ++) {
        if(i < SIZE - 6)
            filter1(image1, image2, i + 5);
        if(i >= 2 && i < SIZE - 2)
            filter2(image1, image2, i);
        if(i < SIZE - 5)
            filter3(image2, i);
        __builtin_prefetch (&image1[i+10], 0, 3);
		__builtin_prefetch (&image2[i+11], 1, 3);
    }
}

