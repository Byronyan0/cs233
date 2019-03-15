.data
.align 2
canvas:	.space 4 * 10

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	li	$a0, 0
	la	$a1, canvas
	jal	add_dot
	li	$a0, 319
	la	$a1, canvas
	jal	add_dot

	la	$a0, canvas
	jal	print_canvas

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
