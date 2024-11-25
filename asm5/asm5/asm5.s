.data   
DASHES:     .asciiz "----------------"
NEWLINE:    .asciiz "\n"
COLON:      .asciiz ": "
OTHER:      .asciiz "<other>: "
.text   
            .globl  countLetters
            .globl  subsCipher
            .globl  strlen

countLetters:
    addiu   $sp,                    $sp,        -24
    sw      $fp,                    0($sp)
    sw      $ra,                    4($sp)
    addiu   $fp,                    $sp,        20

    add     $t0,                    $zero,      $a0                 # Store the address of *str into t0
    add     $t1,                    $zero,      $sp                 # t1 = stack pointer
    addiu   $sp,                    $sp,        -112                # Reserve space for 28 int variables
    add     $t2,                    $zero,      $sp                 # t2 = frame pointer, initialize i = 0

initializeZeroes:      
    beq     $t2,                    $t1,        zerosDone           # Exit loop if frame pointer reaches stack pointer
    sw      $zero,                  0($t2)                          # Initialize str[i] to 0
    addi    $t2,                    $t2,        4                   # Increment t2 by 4 to move to the next int in the array
    j       initializeZeroes
zerosDone:  
    add     $t1,                    $zero,      $zero               # Initialize other counter to 0

    # Print dashes
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    DASHES
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    NEWLINE
    syscall 

    add     $t2,                    $zero,      $t0                 # t2 = address of *str

printString:
    lb      $t3,                    0($t2)                          # t3 = *cur
    beq     $t3,                    $zero,      printStringDone     # Exit loop if *cur == '\0'
    addi    $v0,                    $zero,      11                  # System call code for print character
    add     $a0,                    $zero,      $t3
    syscall 
    addi    $t2,                    $t2,        1                   # Move to the next character in the string
    j       printString
printStringDone:

    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    NEWLINE
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    DASHES
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    NEWLINE
    syscall 

    add     $t2,                    $zero,      $t0                 # t2 = address of *str

whileLoop:  
    lb      $t3,                    0($t2)                          # t3 = *cur
    beq     $t3,                    $zero,      whileLoopDone       # Exit loop if *cur == '\0'

    slti    $t4,                    $t3,        97                  # Check if *cur < 'a'
    bne     $t4,                    $zero,      checkUpper          # Branch if *cur < 'a'
    slti    $t5,                    $t3,        123                 # Check if *cur < 'z' + 1
    bne     $t5,                    $zero,      processLowerCase

checkUpper: 
    slti    $t4,                    $t3,        65                  # Check if *cur < 'A'
    bne     $t4,                    $zero,      checkOther          # Branch if *cur < 'A'
    slti    $t5,                    $t3,        91                  # Check if *cur < 'Z' + 1
    bne     $t5,                    $zero,      processUpperCase

checkOther: 
    addi    $t1,                    $t1,        1                   # Increment the 'other' counter

processLowerCase:
    addi     $t5,                    $t3,        -97                  # t5 = (*cur - 'a')
    sll     $t5,                    $t5,        2                   # Multiply by 4
    add     $t5,                    $t5,        $sp                 # t5 = address of letters[(*cur - 'a') * 4]
    lw      $t6,                    0($t5)
    addi    $t6,                    $t6,        1                   # Increment letters[(*cur - 'a') * 4]
    sw      $t6,                    0($t5)
    j       incrementPointer

processUpperCase:
    addi     $t5,                    $t3,        -65                  # t5 = (*cur - 'A')
    sll     $t5,                    $t5,        2                   # Multiply by 4
    add     $t5,                    $t5,        $sp                 # t5 = address of letters[(*cur - 'A') * 4]
    lw      $t6,                    0($t5)
    addi    $t6,                    $t6,        1                   # Increment letters[(*cur - 'A') * 4]
    sw      $t6,                    0($t5)
    j       incrementPointer

incrementPointer:
    addi    $t2,                    $t2,        1                   # Move to the next character in the string
    j       whileLoop

whileLoopDone:
    add     $t2,                    $zero,      $zero               # Reset i to 0
    addi    $t3,                    $zero,      97                  # t3 = 'a' (97)

lettersForLoop:
    slti    $t4,                    $t2,        26                  # Check if i < 26
    beq     $t4,                    $zero,      lettersForLoopDone  # Exit loop if i >= 26

    addi    $v0,                    $zero,      11                  # System call code for print character
    add     $a0,                    $t2,        $t3                 # Calculate ASCII value
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    COLON
    syscall 
    addi    $v0,                    $zero,      1                   # System call code for print integer
    sll     $t4,                    $t2,        2                   # Multiply i by 4
    add     $t4,                    $t4,        $sp                 # t4 = address of letters[i]
    lw      $a0,                    0($t4)                          # Load letters[i]
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    NEWLINE
    syscall 

    addi    $t2,                    $t2,        1                   # Increment i
    j       lettersForLoop

lettersForLoopDone:
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    OTHER
    syscall 
    addi    $v0,                    $zero,      1                   # System call code for print integer
    add     $a0,                    $zero,      $t1                 # Load the value of 'other'
    syscall 
    addi    $v0,                    $zero,      4                   # System call code for print string
    la      $a0,                    NEWLINE
    syscall 

    addiu   $sp,                    $sp,        112                 # Restore stack pointer
    lw      $fp,                    0($sp)                          # Restore frame pointer
    lw      $ra,                    4($sp)                          # Restore return address
    addiu   $sp,                    $sp,        24                  # Restore stack pointer
    jr      $ra                                                     # Return to caller

subsCipher: 

    addiu   $sp,                    $sp,        -24
    sw      $fp,                    0($sp)
    sw      $ra,                    4($sp)
    addiu   $fp,                    $sp,        20

    addiu   $sp,                    $sp,        -12
    sw      $s0,                    0($sp)
    sw      $s1,                    4($sp)
    sw      $s2,                    8($sp)
    add     $s0,                    $zero,      $a0                 # s0 = arg0 (pointer to str)
    add     $s1,                    $zero,      $a1                 # s1 = arg1 (pointer to map)

    jal     strlen
    add     $t0,                    $zero,      $v0                 # t0 = len = strlen(*str)
    addi    $t0,                    $t0,        1                   # Increment length to include the null terminator

    addi    $s2,                    $t0,        3                   # s2 = len_roundUp = (len + 3)
    addi    $t1,                    $zero,      0x03                # t1 = 0000 0011
    nor     $t1,                    $t1,        $zero               # t1 = ~0x03 or 1111 1100
    and     $s2,                    $t1,        $s2                 # s2 = (len + 3) & ~0x03
    subu    $sp,                    $sp,        $s2                 # sp = sp - len

    add     $t1,                    $zero,      $zero               # i = 0
    addi    $t2,                    $t0,        -1                  # t2 = len - 1

subsLoop:   
    slt     $t3,                    $t1,        $t2                 # Check if i < len - 1
    beq     $t3,                    $zero,      subsLoopDone        # Exit loop if i >= len - 1
    add     $t3,                    $s0,        $t1                 # t3 = str + i
    lb      $t3,                    0($t3)                          # t3 = str[i]
    add     $t3,                    $t3,        $s1                 # t3 = str[i] + map
    lb      $t3,                    0($t3)                          # t3 = map[str[i]]
    add     $t4,                    $t1,        $sp                 # t4 = dup + i
    sb      $t3,                    0($t4)                          # dup[i] = map[str[i]]
    addi    $t1,                    $t1,        1                   # Increment i
    j       subsLoop

subsLoopDone:
    add     $t3,                    $sp,        $t2                 # t3 = dup + len - 1
    sb      $zero,                  0($t3)                          # dup[len-1] = '\0'

    add     $a0,                    $zero,      $sp                 # arg0 = dup
    jal     printSubstitutedString

    addu    $sp,                    $sp,        $s2                 # Free space for dup array
    lw      $s0,                    0($sp)                          # Restore s0
    lw      $s1,                    4($sp)                          # Restore s1
    lw      $s2,                    8($sp)                          # Restore s2
    addiu   $sp,                    $sp,        12                  # Restore stack pointer for s-registers

    lw      $fp,                    0($sp)                          # Restore frame pointer
    lw      $ra,                    4($sp)                          # Restore return address
    addiu   $sp,                    $sp,        24                  # Restore stack pointer
    jr      $ra                                                     # Return to caller

strlen:     

    addiu   $sp,                    $sp,        -24
    sw      $fp,                    0($sp)
    sw      $ra,                    4($sp)
    addiu   $fp,                    $sp,        20

    add     $t0,                    $zero,      $zero               # Initialize count = 0
strlenWhileNotEmpty:
    lb      $t1,                    0($a0)                          # t1 = *str
    beq     $t1,                    $zero,      BREAK               # Exit loop if *str == '\0'
    addi    $t0,                    $t0,        1                   # Increment count
    addi    $a0,                    $a0,        1                   # Move to the next character in the string
    j       strlenWhileNotEmpty
BREAK:      
    add     $v0,                    $zero,      $t0                 # Return count

    lw      $fp,                    0($sp)                          # Restore frame pointer
    lw      $ra,                    4($sp)                          # Restore return address
    addiu   $sp,                    $sp,        24                  # Restore stack pointer
    jr      $ra                                                     # Return to caller
