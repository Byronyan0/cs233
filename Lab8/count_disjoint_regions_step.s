.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
##
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,
##                                          Canvas* canvas) {
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
        sub       $sp, $sp, 36
        sw        $s0, 0($sp)
        sw        $s1, 4($sp)
        sw        $s2, 8($sp)
        sw        $s3, 12($sp)
        sw        $s4, 16($sp)
        sw        $s5, 20($sp)
        sw        $s6, 24($sp)
        sw        $s7, 28($sp)
        sw        $ra, 32($sp)

        move      $s6, $a0              # $s6 = marker
        move      $s7, $a1              # $s7 = canvas

        li        $s0, 0                # $s0 = region_count = 0
        li        $s1, 0                # $s1 = row = 0
        lw        $s3, 0($s7)           # $s3 = canvas->height
        lw        $s5, 4($s7)           # $s5 = canvas->width
        lb        $s4, 8($s7)           # $s4 = canvas->pattern
loop1:
        bge       $s1, $s3, loop1_done  # if row >= canvas->height branch
        li        $s2, 0                # $s2 = 0 = col
loop2:
        bge       $s2, $s5, loop2_done  # if col >= canvas->width branch
        lw        $t0, 12($s7)          # $t0 = canvas->canvas
        mul       $t2, $s1, 4
        add       $t0, $t0, $t2         # $t0 = &canvas->canvas[row]
        lw        $t0, 0($t0)           # $t0 = canvas->canvas[row]
        add       $t0, $t0, $s2         # $t0 = &canvas->canvas[row][col]
        lb        $t0, 0($t0)           # $t0 = canvas->canvas[row][col] = curr_char

        li        $t3, 0
        li        $t4, 0
        beq       $t0, $s4, noteq       # if curr_char == canvas->pattern branch
        li        $t3, 1
noteq:
        beq       $t0, $s6, noteq1      # if curr_char == marker branch
        li        $t4, 1
noteq1:
        and       $t3, $t3, $t4
        beq       $t3, $0, if_done      # branch if and product == 0
        add       $s0, $s0, 1           # region_count ++
        move      $a0, $s1
        move      $a1, $s2
        move      $a2, $s6
        move      $a3, $s7
        jal       flood_fill
if_done:
        add       $s2, $s2, 1           # col++
        j         loop2
loop2_done:
        add       $s1, $s1, 1           # row++
        j         loop1
loop1_done:
        move      $v0, $s0
        lw        $ra, 32($sp)
        lw        $s7, 28($sp)
        lw        $s6, 24($sp)
        lw        $s5, 20($sp)
        lw        $s4, 16($sp)
        lw        $s3, 12($sp)
        lw        $s2, 8($sp)
        lw        $s1, 4($sp)
        lw        $s0, 0($sp)
        add       $sp, $sp, 36
        jr        $ra
