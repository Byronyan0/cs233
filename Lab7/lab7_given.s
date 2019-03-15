.text

.globl print_canvas
print_canvas:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	move	$s0, $a0
	li	$s1, 0
for_int:
	bge	$s1, 10, for_int_end
	li	$s2, 31
for_bit:
	blt	$s2, 0, for_bit_end
	mul	$t0, $s1, 4
	add	$t0, $s0, $t0
	lw	$a0, 0($t0)	# $a0 = canvas[i]
	srl	$a0, $a0, $s2
	and	$a0, $a0, 1
	li	$v0, 1
	syscall
	sub	$s2, $s2, 1
	j	for_bit
for_bit_end:
	jal	print_newline
	add	$s1, $s1, 1
	j	for_int
for_int_end:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	add	$sp, $sp, 16
	jr	$ra

.globl init_origins
init_origins:
	li	$t0, 0
for:
	bge	$t0, 320, for_end
	mul	$t1, $t0, 4
	add	$t1, $a0, $t1
	sw	$t0, 0($t1)
	add	$t0, $t0, 1
	j	for
for_end:
	jr	$ra

.globl print_origins
print_origins:
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)

	move	$s4, $a0
	li	$s0, 0		# $s0 = i
for_col:
	bge	$s0, 10, for_col_end
	li	$s1, 0		# $s1 = j
for_row:
	bge	$s1, 32, for_row_end
	mul	$s2, $s0, 32
	add	$s2, $s2, $s1	# $s2 = i * 32 + j
	mul	$s3, $s2, 4
	add	$s3, $s4, $s3
	lw	$s3, 0($s3)	# $s3 = origins[i * 32 + j]
	bne	$s2, $s3, if_else
	li	$a0, '.'
	jal	print_char_and_space
	j	if_end
if_else:
	move	$a0, $s3
	jal	print_int_and_space
if_end:
	add	$s1, $s1, 1
	j	for_row
for_row_end:
	add	$s0, $s0, 1
	jal	print_newline
	j	for_col
for_col_end:

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra
