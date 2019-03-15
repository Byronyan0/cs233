.text

## bool is_connected(unsigned int pos1, unsigned int pos2,
##                   unsigned int* origins) {
##     return get_origin(pos1, origins) == get_origin(pos2, origins);
## }

.globl is_connected
is_connected:
        add        $sp, $sp, 20       # stack
				sw  			 $ra, 0($sp)				 # $ra in stack 0 offset
				sw 				 $s0, 4($sp)				 # $s0 in stack 4 offset
  			sw 				 $s1, 8($sp)				 # $s1 in stack 8 offset
				sw 				 $s2, 12($sp)				 # $s2 in stack 12 offset
				sw 				 $s3, 16($sp)				 # $s3 in stack 16 offset

				move 			 $s0, $a0
				move 			 $s1, $a1
				move 			 $s2, $a2

				move 			 $a1, $a2						 # function arguments (pos1, origins)
				jal 			 get_origin
				move 			 $s3, $v0						 # store returned value to $s3

				move 			 $a0, $s1 					 # function arguments (pos2, origins)
				jal 			 get_origin
				move 			 $t0, $v0            # store returned value to $t4

				beq 			 $t0, $s3, true
				move 			 $v0, $zero
				j 			   finish
true:
				add 		   $t5, $zero, 1
				move 			 $v0, $t5

finish:
				lw 				 $s3, 16($sp)
				lw 				 $s2, 12($sp)
				lw 				 $s1, 8($sp)
  			lw 				 $s0, 4($sp)
				lw 				 $ra, 0($sp)
				sub 			 $sp, $sp, 20
				jr				 $ra
