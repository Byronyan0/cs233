.data
.align 2
canvas:		.space 4 * 10
origins:	.space 4 * 10 * 32

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, origins
	jal	init_origins

	li	$a0, 0
	li	$a1, 3
	la	$a2, canvas
	la	$a3, origins
	jal	add_line

	li	$a0, 3
	li	$a1, 99
	la	$a2, canvas
	la	$a3, origins
	jal	add_line

	la	$a0, canvas
	jal	print_canvas
	la	$a0, origins
	jal	print_origins

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
