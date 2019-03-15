.text

## unsigned int get_origin(unsigned int pos, unsigned int* origins) {
##     while (pos != origins[pos]) {
##         pos = origins[pos];
##     }
##     return pos;
## }

.globl get_origin
get_origin:
	# Your code goes here :)
				move       $v0, $a0
loop:
        mul        $t0, $v0, 4
	      add        $t1, $a1, $t0        # $t1 = &origins[pos]
	      lw         $t2, 0($t1)          # $t2 = origins[pos]
			  beq 	     $v0, $t2, loop_done
				move       $v0, $t2
	      j loop
loop_done:
	      jr	       $ra
