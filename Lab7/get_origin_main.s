.data
.align 2
origins:	.space 4 * 10 * 32

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, origins
	jal	init_origins

	li	$a0, 3
	la	$a1, origins
	jal	get_origin
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a1, origins
	li	$t0, 0			# $t0 = i
for_mod_origin:
	bge	$t0, 4, for_mod_origin_end
	mul	$t1, $t0, 32
	add	$t1, $t1, 3
	mul	$t1, $t1, 4
	add	$t1, $t1, $a1
	sw	$0, 0($t1)		# origins[3 + i * 32] = 0
	mul	$t1, $t0, 4
	add	$t1, $t1, $a1
	sw	$0, 0($t1)		# origins[i] = 0
	add	$t0, $t0, 1
	j	for_mod_origin
for_mod_origin_end:

	la	$a0, origins
	jal	print_origins

	li	$a0, 0
	la	$a1, origins
	jal	get_origin
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	li	$a0, 3
	la	$a1, origins
	jal	get_origin
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	li	$a0, 99
	la	$a1, origins
	jal	get_origin
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
