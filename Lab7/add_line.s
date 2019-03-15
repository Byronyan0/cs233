.text

## void add_line(unsigned int start_pos, unsigned int end_pos,
##               unsigned int* canvas, unsigned int* origins) {
##     int step_size = 1;
##     // Check if the line is vertical.
##     if (!((start_pos ^ end_pos) & 31)) {
##         step_size = 32;
##     }
##     if (start_pos > end_pos) {
##         step_size *= -1;
##     }
##     // Update the origin map.
##     add_dot(end_pos, canvas);
##     for (int i = start_pos; i != end_pos; i += step_size) {
##         add_dot(i, canvas);
##         origins[get_origin(i + step_size, origins)] = get_origin(i, origins);
##     }
## }

.globl add_line
add_line:
# Your code goes here :)
        sub       $sp, $sp, 36
        sw        $ra, 0($sp)
        sw        $s0, 4($sp)
        sw        $s1, 8($sp)
        sw        $s2, 12($sp)
        sw        $s3, 16($sp)
        sw        $s4, 20($sp)
        sw        $s5, 24($sp)
        sw        $s6, 28($sp)
        sw        $s7, 32($sp)

        li        $s0, 1                        # $s0 = step_size = 1

        move      $s1, $a0                      # $s1 = start_pos
        move      $s2, $a1                      # $s2 = end_pos
        move      $s3, $a2                      # $s3 = canvas
        move      $s4, $a3                      # $s4 = origins
        move      $s5, $a0                      # $s5 = start_pos = i

        xor       $t0, $a0, $a1                 # $t0 = start_pos ^ end_pos
        and       $t0, $t0, 31                  # $t0 = (start_pos ^ end_pos) & 31
        bne       $t0, $0, second_if            # if(!((start_pos ^ end_pos) & 31) == false) then jump
        li        $s0, 32

second_if:
        bge       $a1, $a0, update_origin_map   # if(end_pos >= start_pos) jump
        mul       $s0, $s0, -1                  # step_size = step_size * -1

update_origin_map:

        move      $a0, $s2                      # first arg = end_pos
        move      $a1, $s3                      # second arg = canvas
        jal       add_dot                       # add_dot(end_pos, canvas)

loop:
        beq       $s5, $s2, loop_done           # if(i == end_pos) loop_done
        move      $a0, $s5                      # first arg = i
        move      $a1, $s3                      # secod arg = canvas
        jal       add_dot                       # add_dot(i, canvas)

        move      $a0, $s5                      # first arg = i
        move      $a1, $s4                      # second arg = origins
        jal       get_origin                    # get_origin(i, origins)
        move      $s6, $v0                      # $s6 = get_origin(i, origins)

        move      $a0, $s5                      # $a0 = i
        add       $a0, $a0, $s0                 # first arg = i + step_size
        move      $a1, $s4                      # second arg = origins
        jal       get_origin                    # get_origin(i + step_size, origins)

        move      $s7, $v0                      # $s7 = get_origin(i + step_size, origins)
        mul       $s7, $s7, 4
        add       $t0, $s4, $s7                 # $t0 = origins[get_origin(i + step_size, origins)]
        sw        $s6, 0($t0)                   # origins[get_origin(i + step_size, origins)] = get_origin(i, origins)

        add       $s5, $s5, $s0                 # i = i + step_size
        j         loop

loop_done:

        lw        $s7, 32($sp)
        lw        $s6, 28($sp)
        lw        $s5, 24($sp)
        lw        $s4, 20($sp)
        lw        $s3, 16($sp)
        lw        $s2, 12($sp)
        lw        $s1, 8($sp)
        lw        $s0, 4($sp)
        lw        $ra, 0($sp)
        add       $sp, $sp, 36
        jr        $ra
