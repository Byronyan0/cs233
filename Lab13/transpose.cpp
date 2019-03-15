#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {\
    int tile_size = 22;
    for (int i = 0; i < SIZE ; i = i + tile_size) {
        for (int j = 0; j < SIZE; j ++) {
          for (int ii = i; ii < min(tile_size + i, SIZE); ii ++) {
            dest[ii][j] = src[j][ii];
          }
        }
    }
}
