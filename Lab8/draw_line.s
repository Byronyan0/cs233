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
## // Draw a line on canvas from start_pos to end_pos.
## // start_pos will always be smaller than end_pos.
## void draw_line(unsigned int start_pos, unsigned int end_pos,
##                Canvas* canvas) {
##     unsigned int width = canvas->width;
##     unsigned int step_size = 1;
##     // Check if the line is vertical.
##     if (end_pos - start_pos >= width) {
##         step_size = width;
##     }
##     // Update the canvas with the new line.
##     for (int pos = start_pos; pos != end_pos + step_size;
##              pos += step_size) {
##         canvas->canvas[pos / width][pos % width] = canvas->pattern;
##     }
## }

.globl draw_line
draw_line:
        sub        $sp, $sp, 20
        sw         $s0, 0($sp)
        sw         $s1, 4($sp)
        sw         $s2, 8($sp)
        sw         $s3, 12($sp)
        sw         $ra, 16($sp)

        lw         $s0, 4($a2)            # $s0 = width = canvas->width
        li         $s1, 1                 # $s1 = step_size = 1
        sub        $t0, $a1, $a0          # $t0 = end_pos - start_pos
        bgt        $s0, $t0, if_done      # skip the if if (width > end_pos - start_pos)
        move       $s1, $s0               # step_size = width
if_done:
        move       $s2, $a0               # $s2 = pos = start_pos
        add        $t1, $a1, $s1          # $t1 = end_pos + step_size
for_loop:
        beq 	   $s2, $t1, loop_done    # loop is done if pos == end_pos + step_size
        lb 	   $s3, 8($a2)            # $s3 = canvas->pattern
        lw 	   $t2, 12($a2)           # $t2 = canvas->canvas
        div 	   $s2, $s0               # $t7 = pos / width, $t8 = pos % width
        mflo 	   $t7
        mfhi 	   $t8
        mul 	   $t7, $t7, 4
        add 	   $t3, $t2, $t7	  # $t3 = &canvas->canvas[pos / width]
        lw 	   $t3, 0($t3)	      	  # $t3 = canvas->canvas[pos / width]
        add        $t4, $t3, $t8          # $t4 = $canvas->canvas[pos / width][pos % width]
        sb         $s3, 0($t4)
        add        $s2, $s2, $s1	  # pos += step_size
        j          for_loop

loop_done:
        lw 	   $ra, 16($sp)
        lw 	   $s3, 12($sp)
        lw 	   $s2, 8($sp)
        lw    	   $s1, 4($sp)
        lw 	   $s0, 0($sp)
        add        $sp, $sp, 20
        jr         $ra
