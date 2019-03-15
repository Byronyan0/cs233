.text

## void add_dot(unsigned int pos, unsigned int* canvas) {
##     unsigned int row = pos >> 5;
##     unsigned int col = 31 - (pos & 31);
##     canvas[row] |= (1 << col);
## }

.globl add_dot
add_dot:
        # Your code goes here :)
        srl      $t1, $a0, 5         # $t1 = pos >> 5;
				add      $t2, $0, 31         # $t2 = 31
				and      $t3, $a0, $t2       # $t3 = pos & 31
				sub 		 $t4, $t2, $t3       # $t4 = 31 - (pos & 31)
				add      $t5, $t0, 1         # $t5 = 1
				sll      $t5, $t5, $t4
				mul      $t8, $t1, 4
				add      $t6, $a1, $t8       # $t6 = canvas[row] address
				lw       $t7, 0($t6)
				or       $t7, $t7, $t5
				sw       $t7, 0($t6)
				jr	     $ra
