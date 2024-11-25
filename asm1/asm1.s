.data
nothingEqualsStr:  .asciiz "NOTHING EQUALS\n"
equalsStr:      .asciiz "EQUALS\n"
ascendingStr:   .asciiz "ASCENDING\n"
descendingStr:  .asciiz "DESCENDING\n"
allEqualsStr:   .asciiz "ALL EQUAL\n"
unorderedStr:   .asciiz "UNORDERED\n"
reverseStr:   .asciiz "REVERSE\n"
redStr: .asciiz "red: "
orangeStr: .asciiz "orange: "
yellowStr: .asciiz "yellow: "
greenStr: .asciiz "green: "
blueStr: .asciiz "blue: "
purpleStr: .asciiz "purple: "
newlineStr: .asciiz "\n"

.text
.globl studentMain
studentMain:
    addiu $sp, $sp, -24    # allocate stack space
    sw $fp, 0($sp)         # save caller’s frame pointer
    sw $ra, 4($sp)         # save return address
    addiu $fp, $sp, 20     # setup main’s frame pointer

    # Load values for comparison
    la $s0, equals # load address of equals into $t0
    lw $t0, 0($s0) # load word places value 
    la $s0, order # load address of order into $t1
    lw $t1, 0($s0) # load word assigns the value of order
    la $s0, reverse # load address of reverse into $t2
    lw $t2, 0($s0) # load word assigns the value of reverse
    la $s0, print # load address of print in $t3
    lw $t3, 0($s0) # load word assigns value of print
    la $s0, red # load address address of red in $t4
    lw $t4, 0($s0) # load word assigns value of red
    la $s0, orange # load address address of orange in $t5
    lw $t5, 0($s0) # load word assigns value of orange
    la $s0, yellow # load address address of yellow in $t6
    lw $t6, 0($s0) # load word assigns value of yellow
    la $s0, green # load address address of green in $t7
    lw $t7, 0($s0) # load word assigns value of green
    la $s0, blue # load address address of blue in $t8
    lw $t8, 0($s0) # load word assigns value of blue
    la $s0, purple # load address address of purple in $t9
    lw $t9, 0($s0) # load word assigns value of purple
    
    j allEquals

allEquals:
    beq $t0, $zero, ascending # checks equals is being checked if not launch to order
    bne $t4, $t5,nothingEquals  # if not equal just to no equals
    bne $t4, $t6,nothingEquals  # if not equal just to no equals
    bne $t4, $t7,nothingEquals  # if not equal just to no equals
    bne $t4, $t8,nothingEquals  # if not equal just to no equals
    bne $t4, $t9,nothingEquals  # if not equal just to no equals
    
    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, equalsStr   # load the address of equalsStr
    syscall
    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, allEqualsStr # load the address of allEqualsStr
    syscall
    bne $t3, $zero, printValues

    j exit  # Jump to exit after Task 2
nothingEquals:
    beq $t4, $t5,equalsFound    # if equal then lauch to equalsFound
    beq $t4, $t6,equalsFound    # if equal then lauch to equalsFound
    beq $t4, $t7,equalsFound    # if equal then lauch to equalsFound
    beq $t4, $t8,equalsFound    # if equal then lauch to equalsFound
    beq $t4, $t9,equalsFound    # if equal then lauch to equalsFound
    beq $t5, $t6,equalsFound    # if equal then lauch to equalsFound
    beq $t5, $t7,equalsFound    # if equal then lauch to equalsFound
    beq $t5, $t8,equalsFound    # if equal then lauch to equalsFound
    beq $t5, $t9,equalsFound    # if equal then lauch to equalsFound
    beq $t6, $t7,equalsFound    # if equal then lauch to equalsFound
    beq $t6, $t8,equalsFound    # if equal then lauch to equalsFound
    beq $t6, $t9,equalsFound    # if equal then lauch to equalsFound
    beq $t7, $t8,equalsFound    # if equal then lauch to equalsFound
    beq $t7, $t9,equalsFound    # if equal then lauch to equalsFound
    beq $t8, $t9,equalsFound    # if equal then lauch to equalsFound
    
    addi $v0, $zero, 4 # syscall code for printing a string
    la $a0, nothingEqualsStr # load the address of nothingEqualsStr
    syscall
    j ascending  # Jump to exit after Task 1

equalsFound:
    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, equalsStr # load the address of equalsStr
    syscall
    
    j ascending
    # just change it to add and subtract is the result is less than zero then just if equal to zero it's okay 
ascending: 

    beq $t1, $zero, reverseOrder
    slt $s0, $t4, $t5     # Check if t5 is less than t4
    slt $s1, $t5, $t6     # Check if t6 is less than t5
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, descending
    slt $s1, $t6, $t7     # Check if t7 is less than t6
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, descending
    slt $s1, $t7, $t8   # Check if t8 is less than t7
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, descending
    slt $s1, $t8, $t9     # Check if t9 is less than t8
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, descending




    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, ascendingStr # load the address of ascendingStr
    syscall
    bne $t2, $zero, reverseOrder

    bne $t3, $zero, printValues

    j exit  # Jump to exit after Task 2


descending:
    slt $s0, $t5, $t4     # Check if t5 is less than t4
    slt $s1, $t6, $t5     # Check if t6 is less than t5
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, unordered
    slt $s1, $t7, $t6     # Check if t7 is less than t6
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, unordered
    slt $s1, $t8, $t7     # Check if t8 is less than t7
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, unordered
    slt $s1, $t9, $t8     # Check if t9 is less than t8
    and $s0, $s0, $s1      # Combine the results with logical AND
    beq $s0, $zero, unordered

    addi $v0, $zero, 4 # syscall code for printing a string
    la $a0, descendingStr  # load the address of descendingStr
    syscall
    bne $t2, $zero, reverseOrder

    bne $t3, $zero, printValues

    j exit  # Jump to exit after Task 2

unordered:
    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, unorderedStr # load the address of unorderedStr
    syscall
    bne $t2, $zero, reverseOrder

    bne $t3, $zero, printValues

    j exit  # Jump to exit after Task 2


reverseOrder:
    
    
    add $s3, $t4, $zero  # Temporarily store t  he value of $t4 in $s3
    sub $t4, $t9, $zero    # Move the value of $t9 to $t4
    add $t9, $s3, $zero   # Move the original value of $t4 from $t10 to $t9

    # Swap $t5 and $t8 without using move
    add $s3, $t5, $zero  # Temporarily store the value of $t5 in $t10
    sub $t5, $t8, $zero    # Move the value of $t8 to $t5
    add $t8, $s3, $zero   # Move the original value of $t5 from $t10 to $t8

    # Swap $t6 and $t7 without using move
    add $s3, $t6, $zero  # Temporarily store the value of $t6 in $t10
    sub $t6, $t7, $zero    # Move the value of $t7 to $t6
    add $t7, $s3, $zero   # Move the original value of $t6 from $t10 to $t7    

   

    addi $v0, $zero, 4   # syscall code for printing a string
    la $a0, reverseStr  # load the address of reverseStr
    syscall
    bne $t3, $zero, printValues


    j exit

   
printValues:
    addi $v0, $zero, 4   # syscall code for printing a string
    la $a0, redStr       # load the address of redStr
    syscall

    add $a0, $t4, $zero   # Load the value of red color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall

    la $s0, red           # Load address of red variable into $s0
    sw $t4, 0($s0)

    addi $v0, $zero, 4
    la $a0, orangeStr
    syscall

    add $a0, $t5, $zero   # Load the value of orange color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall

    la $s0, orange           # Load address of orange variable into $s0
    sw $t5, 0($s0)

    addi $v0, $zero, 4
    la $a0, yellowStr
    syscall

    add $a0, $t6, $zero   # Load the value of yellow color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall

     la $s0, yellow           # Load address of yellow variable into $s0
    sw $t6, 0($s0)

    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, greenStr    # Load the address of the greenStr string
    syscall

    add $a0, $t7, $zero   # Load the value of green color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall

     la $s0, green           # Load address of green variable into $s0
    sw $t7, 0($s0)

    addi $v0, $zero, 4   # syscall code for printing a string
    la $a0, blueStr      # Load the address of the blueStr string
    syscall

    add $a0, $t8, $zero   # Load the value of blue color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall

    la $s0, blue           # Load address of blue variable into $s0
    sw $t8, 0($s0)

    addi $v0, $zero, 4  # syscall code for printing a string
    la $a0, purpleStr   # Load the address of the purpleStr string
    syscall

    add $a0, $t9, $zero   # Load the value of purple color into $a0
    addi $v0, $zero, 1    # syscall code for printing an integer
    syscall

    addi $v0, $zero, 4    # syscall code for printing a string
    la $a0, newlineStr    # Load the address of the newline string
    syscall
     
    la $s0, purple           # Load address of purple variable into $s0
    sw $t9, 0($s0)

    j exit

exit:

    lw $ra, 4($sp)         # get return address from the stack
    lw $fp, 0($sp)         # restore the caller’s frame pointer
    addiu $sp, $sp, 24     # restore the caller’s stack pointer
    jr $ra                 # return to the caller’s code
