.data

.globl equals
.globl order
.globl reverse
.globl print

.globl red
.globl orange
.globl yellow
.globl green
.globl blue
.globl purple

green:    .word    1
blue:     .word 9999
purple:   .word  888
red:      .word 4444
orange:   .word  333
yellow:   .word   22

reverse:  .word 1
print:    .word 1
equals:   .word 0
order:    .word 0



.text

.globl main

main:
	jal studentMain


	# dump out the 6 values.
.data
TESTCASE_MSG:	.asciiz "\n\nTestcase Variable Dump:\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_MSG)
	la	$a0, TESTCASE_MSG
	syscall

	addi	$v0, $zero, 1		# print_int(red)
	la	$a0, red
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(orange)
	la	$a0, orange
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(yellow)
	la	$a0, yellow
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(green)
	la	$a0, green
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(blue)
	la	$a0, blue
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(purple)
	la	$a0, purple
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(equals)
	la	$a0, equals
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(order)
	la	$a0, order
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(reverse)
	la	$a0, reverse
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	addi	$v0, $zero, 1		# print_int(print)
	la	$a0, print
	lw	$a0, 0($a0)
	syscall
	
	addi	$v0, $zero,11		# print_char('\n')
	addi	$a0, $zero,'\n'
	syscall
	
	
	# terminate the program	
	addi	$v0, $zero, 10		# syscall_exit
	syscall


