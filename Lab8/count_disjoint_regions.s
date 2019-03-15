.text

## struct Lines {
##     unsigned int num_lines;
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];
## };
##
## struct Solution {
##     unsigned int length;
##     int* counts;
## };
##
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct.
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##     for (unsigned int i = 0; i < lines->num_lines; i++) {
##         unsigned int start_pos = lines->coords[0][i];
##         unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##         draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##         unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##         solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
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

        move      $s0, $a0
        move      $s1, $a1
        move      $s2, $a2

        li        $s3, 0                # $s3 = i
loop:
        lw        $t0, 0($s0)           # $t0 = num_lines
        bge       $s3, $t0, loop_done   # if i >= num_lines branch
        lw        $t1, 4($s0)           # $t1 = lines->coords[0]
        mul       $t2, $s3, 4
        add       $t1, $t1, $t2         # $t1 = &lines->coords[0][i]
        lw        $s4, 0($t1)           # $s4 = lines->coords[0][i] = start_pos

        lw        $t3, 8($s0)           # $t3 = lines->coords[1]
        add       $t3, $t3, $t2         # $t3 = &lines->coords[0][i]
        lw        $s5, 0($t3)           # $s5 = lines->coords[1][i] = end_pos

        move      $a0, $s4
        move      $a1, $s5
        move      $a2, $s1
        jal       draw_line

        div       $a0, $s3, 2
        mfhi      $a0                   # $a0 = i % 2
        add       $a0, $a0, 65          # $a0 = 'A' + (i % 2)
        move      $a1, $s1
        jal       count_disjoint_regions_step
        move      $s6, $v0              # $s6 = count = count_disjoint_regions_step('A' + (i % 2), canvas)
        lw        $t0, 4($s2)           # $t0 = solution->counts
        mul       $t1, $s3, 4
        add       $t0, $t0, $t1         # $t0 = &solution->counts[i]
        sw        $s6, 0($t0)           # solution->counts[i] = count
        add       $s3, $s3, 1           # i++
        j         loop
loop_done:

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
