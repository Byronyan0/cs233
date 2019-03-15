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
## // Mark an empty region as visited on the canvas using flood fill algorithm.
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
        sub        $sp, $sp, 36
        sw         $s0, 0($sp)
        sw         $s1, 4($sp)
        sw         $s2, 8($sp)
        sw         $s3, 12($sp)
        sw         $s4, 16($sp)
        sw         $s5, 20($sp)
        sw         $s6, 24($sp)
        sw         $s7, 28($sp)
        sw         $ra, 32($sp)

        move       $s0, $a0
        move       $s1, $a1
        move       $s2, $a2
        move       $s3, $a3

        slt        $s4, $a0, 0               # $s4 = 1 if row < 0
        slt        $s5, $a1, 0               # $s5 = 1 if col < 0
        li         $s6, 0
        li         $s7, 0

        lw         $t4, 0($a3)               # $t4 = canvas->height
        blt        $a0, $t4, not_lt
        li         $s6, 1                    # $s6 = 1 if canvas->height >= row
not_lt:
        lw         $t5, 4($a3)               # $t5 = canvas->width
        blt        $a1, $t5, not_lt1
        li         $s7, 1                    # $s7 = 1 if canvas->width >= col
not_lt1:
        or         $s4, $s4, $s5             # $s4 = row < 0 || col < 0
        or         $s4, $s4, $s6             # $s4 = row < 0 || col < 0 || canvas->height >= row
        or         $s4, $s4, $s7             # $s4 = row < 0 || col < 0 || canvas->height >= row || canvas->width >= col
        beq        $s4, $0, if_done          # branch if $s4 = 0

        lw         $ra, 32($sp)
        lw         $s7, 28($sp)
        lw         $s6, 24($sp)
        lw         $s5, 20($sp)
        lw         $s4, 16($sp)
        lw         $s3, 12($sp)
        lw         $s2, 8($sp)
        lw         $s1, 4($sp)
        lw         $s0, 0($sp)
        add        $sp, $sp, 36
        jr         $ra                       # return

if_done:
        lw         $t0, 12($a3)              # $t0 = canvas->canvas
        mul        $t1, $a0, 4
        add        $t0, $t1, $t0             # $t0 = &canvas->canvas[row]
        lw         $t0, 0($t0)               # $t0 = canvas->canvas[row]
        add        $t0, $t0, $a1             # $t0 = &canvas->canvas[row][col]
        lb         $t1, 0($t0)               # $t1 = canvas->canvas[row][col] = curr

        lb         $t2, 8($a3)               # $t2 = canvas->pattern
        li         $t3, 0
        li         $t4, 0
        beq        $t1, $t2, curr_not        # branch if curr == canvas->pattern
        li         $t3, 1
curr_not:
        beq        $t1, $a2, curr_not1       # branch if curr == marker
        li         $t4, 1
curr_not1:
        and        $t1, $t3, $t4             # $t1 = curr != canvas->pattern && curr != marker
        beq        $t1, $0, jump_if          # if (curr != canvas->pattern && curr != marker) == 0, branch
        sb         $a2, 0($t0)               # canvas->canvas[row][col] = marker

        add        $a0, $s0, -1              # $a0 = row - 1
        jal        flood_fill

        move       $a0, $s0                  # $a0 = row
        add        $a1, $s1, 1               # $a1 = col + 1
        jal        flood_fill

        move       $a1, $s1                  # $a1 = col
        add        $a0, $s0, 1               # $a0 = row + 1
        jal        flood_fill

        move       $a0, $s0                  # $a0 = row
        add        $a1, $s1, -1              # $a1 = col - 1
        jal        flood_fill
jump_if:
        lw         $ra, 32($sp)
        lw         $s7, 28($sp)
        lw         $s6, 24($sp)
        lw         $s5, 20($sp)
        lw         $s4, 16($sp)
        lw         $s3, 12($sp)
        lw         $s2, 8($sp)
        lw         $s1, 4($sp)
        lw         $s0, 0($sp)
        add        $sp, $sp, 36
        jr         $ra                       # return
