# AUthor: Ming Wang
.data   
NEWLINE:    .asciiz "\n"
SPACE:      .asciiz " "

FIB:        .asciiz "Fibonacci Numbers:\n"
FIB_ZERO:   .asciiz "  0: 1\n"
FIB_ONE:    .asciiz "  1: 1\n"
FIB_SPACE:  .asciiz "  "
FIB_COLON:    .asciiz ": "

ASCENDING:  .asciiz "Run Check: ASCENDING\n"
DESCENDING: .asciiz "Run Check: DESCENDING\n"
NEITHER:    .asciiz "Run Check: NEITHER\n"

SWAP:       .asciiz "String successfully swapped!"

.text   
            .globl  studentMain
studentMain:
    addiu   $sp,                $sp,            -24                 # allocate stack space -- default of 24 here
    sw      $fp,                0($sp)                              # save caller<92>s frame pointer
    sw      $ra,                4($sp)                              # save return address
    addiu   $fp,                $sp,            20                  # setup main<92>s frame pointer

    la      $s0,                fib                                 # s0 = &fib
    lw      $s0,                0($s0)                              # s0 = fib
    la      $s1,                square                              # s1 = &square
    lw      $s1,                0($s1)                              # s1 = square
    la      $s2,                runCheck                            # s2 = &runCheck
    lw      $s2,                0($s2)                              # s2 = runCheck
    la      $s3,                countWords                          # s3 = &countWords
    lw      $s3,                0($s3)                              # s3 = countWords
    la      $s4,                revString                           # s4 = &revString
    lw      $s4,                0($s4)                              # s4 = revString


    beq     $s0,                $zero,          END_FIB             # if (fib == 0), skip to end.

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                FIB                                 # print_str("Fibonacci numbers:\n")
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                FIB_ZERO                            # print_str("  0: 1\n")
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                FIB_ONE                             # print_str("  1: 1\n")
    syscall 

    addi    $t0,                $zero,          1                   # t0 = prev (1)
    addi    $t1,                $zero,          1                   # t1 = beforeThat (1)
    addi    $t2,                $zero,          2                   # t2 = n (2)

FIB_WHILE:  

    slt     $t3,                $s0,            $t2                 # t3 = (n > fib)
    addi    $t5,                $zero,          1                   # t5 = 1
    beq     $t3,                $t5,            FIB_PRINT_NL         # if (n <= fib)

    add     $t4,                $t0,            $t1                 # cur = prev + beforeThat

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                FIB_SPACE                           # print_str("  ")
    syscall 

    addi    $v0,                $zero,          1                   # print_int
    add     $a0,                $zero,          $t2                 # print_int(n)
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                FIB_COLON                             # print_str(":")
    syscall 

    addi    $v0,                $zero,          1                   # print_int
    add     $a0,                $zero,          $t4                 # print_int(n)
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

    addi    $t2,                $t2,            1                   # n ++
    add     $t1,                $zero,          $t0                 # beforeThat = prev
    add     $t0,                $zero,          $t4                 # prev = cur

    j       FIB_WHILE


FIB_PRINT_NL:
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

END_FIB:                                                            # End of Task 1

    beq     $s1,                $zero,          END_SQUARE          # if (square == 0), skip code

    add     $t0,                $zero,          $zero               # t0 =  row(0)

    la      $s5,                square_size                         # s5 = &square_size
    lw      $s5,                0($s5)                              # s5 = square_size
    la      $s6,                square_fill                         # s6 = &square_fill
    lb      $s6,                0($s6)                              # s6 = square_fill

SQUARE_OUTER_FOR:

    slt     $t1,                $t0,            $s5                 # t1 = (row < square_size)

    beq     $t1,                $zero,          SQUARE_PRINT        # if (row >= square_size), skip to "\n"

    beq     $t0,                $zero,          SET1                # if (row == 0)

    addi    $t7,                $zero,          1                   # t7 = 1
    sub     $t7,                $zero,          $t7                 # t7 = -1

    add     $t2,                $s5,            $t7                 # t2 = square_size - 1
    beq     $t0,                $t2,            SET1                # if (row == square_size - 1)

    j       SET2

SET1:       
    addi    $t8,                $zero,          0x2B                # (t8) lr = '+'
    addi    $t9,                $zero,          0x2D                # (t9) mid = '-'

    j       PRINT_LAYER

SET2:       
    addi    $t8,                $zero,          0x7C                # (t8) lr = '|'
    add     $t9,                $zero,          $s6                 # (t9) mid = square_fill

    j       PRINT_LAYER

PRINT_LAYER: 

    addi    $v0,                $zero,          11                  # print_char
    add     $a0,                $zero,          $t8                 # print_char(lr)
    syscall 

    addi    $t7,                $zero,          1                   # i ++

    addi    $t6,                $zero,          1                   # t9 = 1
    sub     $t6,                $zero,          $t6                 # t9 = -1

    add     $t2,                $s5,            $t6                 # t2 = square_size - 1

SQUARE_INNER_FOR:

    slt     $t6,                $t7,            $t2                 # t6 = (i < square_size - 1)
    beq     $t6,                $zero,          PRINT_LAYER_TWO         # if (i >= square_size - 1), PRINT_LAYER_TWO

    addi    $v0,                $zero,          11                  # print_char
    add     $a0,                $zero,          $t9                 # print_char(mid)
    syscall 

    addi    $t7,                $t7,            1                   # t7 ++

    j       SQUARE_INNER_FOR

PRINT_LAYER_TWO:
    addi    $v0,                $zero,          11                  # print_char
    add     $a0,                $zero,          $t8                 # print_char(lr)
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

    addi    $t0,                $t0,            1                   # row ++
    j       SQUARE_OUTER_FOR

SQUARE_PRINT:
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

END_SQUARE: 

    addi    $t1,                $zero,          1
    bne     $s2,                $t1,            END_RUNCHECK

    la      $t1,                intArray                            # t1 = &intArray

    la      $t2,                intArray_len                        # t2 = &intArray_len
    lw      $t2,                0($t2)                              # t2 = intArray_len

    beq     $t2,                $zero,          PRINT_BOTH          # if (length = 0), print both out.
    addi    $t0,                $zero,          1                   # t0 = 1
    beq     $t2,                $t0,            PRINT_BOTH          # if (length = 1), print both out.


    add     $t0,                $zero,          $zero               # i = 0

RUN_ASCENDING:
    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    addi    $t9,                $zero,          4                   # t9 = 4
    sub     $t9,                $zero,          $t9                 # t9 = -4
    add     $t6,                $t6,            $t9

    beq     $t0,                $t6,            PRINT_ASCENDING     # if (i == intArray_len), exit while.

    add     $t6,                $t0,            $zero               # t6 = i
    addi    $t7,                $t0,            4                   # t7 = i + 1

    add     $t8,                $t1,            $t6                 # t8 = &intArray[i]
    lw      $s6,                0($t8)                              # s6 = intArray[i]

    add     $t9,                $t1,            $t7                 # t9 = &intArray[i + 1]
    lw      $s7,                0($t9)                              # s7 = intArray[i + 1]

    slt     $t5,                $s7,            $s6                 # t5 = intArray[i + 1] < intArray[i]
    addi    $t7,                $zero,          1                   # t7 = 1

    beq     $t5,                $t7,            RESET_DESCENDING      # if (intArray[i] > intArray[i + 1])

    addi    $t0,                $t0,            4                   # i += 4

    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    beq     $t0,                $t6,            PRINT_ASCENDING     # if true, print out Run Check.

    j       RUN_ASCENDING                                           # jump back to for loop.

RESET_DESCENDING:
    add     $t0,                $zero,          $zero               # i = 0

RUN_DESCENDING:
    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    addi    $t9,                $zero,          4                   # t9 = 4
    sub     $t9,                $zero,          $t9                 # t9 = -4

    add     $t6,                $t6,            $t9                 # t6 = (arrayLength - 1)
    beq     $t0,                $t6,            PRINT_DESCENDING    # if (i == intArray_len), exit while.

    add     $t6,                $t0,            $zero               # t6 = i
    addi    $t5,                $t6,            4                   # t5 = (i + 1)

    add     $t6,                $t1,            $t6                 # t6 = &intArray[i]
    lw      $s6,                0($t6)                              # s6 = intArray[i]

    add     $t5,                $t1,            $t5                 # t5 = &intArray[i + 1]
    lw      $s7,                0($t5)                              # t4 = intArray[i + 1]

    slt     $t5,                $s6,            $s7                 # t5 = intArray[i] < intArray[i + 1]
    addi    $t7,                $zero,          1                   # t7 = 1

    beq     $t5,                $t7,            PRINT_NEITHER       # if (false), PRINT_NEITHER

    addi    $t0,                $t0,            4                   # i += 4

    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    beq     $t0,                $zero,          PRINT_DESCENDING    # if true, print out Run Check.

    j       RUN_DESCENDING                                          # jump back to for loop.

REST_BOTH:   
    add     $t0,                $zero,          $zero

RUN_BOTH:   
    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    addi    $t9,                $zero,          4                   # t9 = 4
    sub     $t9,                $zero,          $t9                 # t9 = -4

    add     $t6,                $t6,            $t9                 # t6 = (arrayLength - 1)
    beq     $t0,                $t6,            PRINT_DESCENDING    # if (i == intArray_len), PRINT_DESCENDING

    add     $t6,                $t0,            $zero               # t6 = i
    addi    $t5,                $t6,            4                   # t5 = (i + 1)

    add     $t6,                $t1,            $t6                 # t6 = &intArray[i]
    lw      $s6,                0($t6)                              # s6 = intArray[i]

    add     $t5,                $t1,            $t5                 # t5 = &intArray[i + 1]
    lw      $s7,                0($t5)                              # t4 = intArray[i + 1]

    sub     $t5,                $s6,            $s7					# t5 = intArray[i] < intArray[i + 1]
    bne     $t5,                $zero,          RUNCHECK_PRINTNT	# if(t5 == 0), RUNCHECK_PRINTNT

    addi    $t0,                $t0,            4                   # i += 4

    add     $t6,                $t2,            $t2                 # t6 = arrayLength * 2
    add     $t6,                $t6,            $t6                 # t6 = arrayLength * 4

    beq     $t0,                $zero,          PRINT_BOTH          # if true, PRINT_BOTH

    j       RUN_BOTH
    # Printing Statements
PRINT_ASCENDING:
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                ASCENDING                           # print_str("Run Check: ASCENDING\n")
    syscall 

    j       REST_BOTH                                                # Once you get here jump back to check for special cases.

PRINT_DESCENDING:
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                DESCENDING                          # print_str("Run Check: DESCENDING\n")
    syscall 

    j       RUNCHECK_PRINTNT                                        # Once you get here skip to last print.

PRINT_NEITHER:

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEITHER                             # print_str("Run Check: NEITHER\n")
    syscall 

    j       RUNCHECK_PRINTNT

PRINT_BOTH: 
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                ASCENDING                           # print_str("Run Check: ASCENDING\n")
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                DESCENDING                          # print_str("Run Check: DESCENDING\n")
    syscall 

RUNCHECK_PRINTNT:
    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 


END_RUNCHECK:                                                       # End of Task 3 runCheck

    addi    $t0,                $zero,          1                   # t0 = 1
    beq     $s3,                $t0,            START_COUNTWORDS    # Start countWords if countWords == 1
    j       END_COUNTWORDS

START_COUNTWORDS:
    la      $s7,                str                                 # s7 = &str
    add     $t0,                $zero,          $zero               # t0 = 0 (word count)

    addi    $t1,                $zero,          0                   # i = 0

LOOP_COUNTWORDS:

    add     $t2,                $s7,            $t1                 # t2 = pointer to access array at.
    lb      $t3,                0($t2)                              # t3 = str[i]
    beq     $t3,                $zero,          COUNTWORDS_PRINTNT  # if (str[i] = null), last print.

    addi    $t4,                $t1,            1                   # t4 = i + 1
    add     $t4,                $s7,            $t4                 # t4 = &str[i + 1]
    lb      $t4,                0($t4)                              # t4 = str[i + 1]



    addi    $t5,                $zero,          0x20                # t5 = " "
    addi    $t6,                $zero,          0xA                 # t5 = "\n"
    beq     $t3,                $t5,            INCREMENT_INDEX           # if str[i] = " " continue with loop.
    beq     $t3,                $t6,            INCREMENT_INDEX           # if str[i] = "\n" continue with loop.

    beq     $t4,                $zero,          ADD_COUNT            # if str[i + 1] = " " then count ++
    beq     $t4,                $t5,            ADD_COUNT            # if str[i + 1] = " " then count ++
    beq     $t4,                $t6,            ADD_COUNT            # if str[i + 1] = "/n" then count ++

    j       INCREMENT_INDEX

ADD_COUNT:   
    addi    $t0,                $t0,            1                   # count ++

INCREMENT_INDEX:  
    addi    $t1,                $t1,            1                   # i ++

    j       LOOP_COUNTWORDS

COUNTWORDS_PRINTNT:

    addi    $v0,                $zero,          1                   # print_int
    add     $a0,                $zero,          $t0                 # print_int(count)
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

    addi    $v0,                $zero,          4                   # print_str
    la      $a0,                NEWLINE                             # print_str("\n")
    syscall 

END_COUNTWORDS:

    # End of Task 4 countWords

    beq     $s4,                $zero,          exit                # if (revString == 0), skip ahead to DONE
    la      $t0,                str                                 # t0 = &str

REVSTRING_TAIL:
    lb      $t1,                0($t0)                              # t0 = str[i]
    beq     $t1,                $zero,          BREAK_TAIL      # if (t1 == null), skip ahead to BREAK_SET_TAIL
    addi    $t0,                $t0,            1                   # t0++
    j       REVSTRING_TAIL

BREAK_TAIL:
    addi    $t0,                $t0,            -1                  # str[str.length - 1]
    la      $t2,                str                                 # t2 = str[0]

WHILE_FRONT_L_BACK:
    slt     $t4,                $t2,            $t0                 # t4 = (head < tail)
    beq     $t4,                $zero,          FINISH_REVSTRING  # if (head >= tail), skip ahead to done
    lb      $t1,                0($t0)                              # t1 = str[t0]
    lb      $t3,                0($t2)                              # t3 = str[t2]

    sb      $t3,                0($t0)                              # str[t0] = t3
    sb      $t1,                0($t2)                              # str[t2] = t2

    addi    $t0,                $t0,            -1                  # t0--
    addi    $t2,                $t2,            1                   # t2++

    j       WHILE_FRONT_L_BACK


FINISH_REVSTRING:
    addi    $v0,                $zero,          4                   # print_str();
    la      $a0,                SWAP
    syscall 

    addi    $v0,                $zero,          4                   # print_str();
    la      $a0,                NEWLINE
    syscall 

    addi    $v0,                $zero,          4                   # print_str();
    la      $a0,                NEWLINE
    syscall 

    la      $t0,                str                                 # t0 = &str
End_RS:     


exit:       
    lw      $ra,                4($sp)                              # get return address from stack
    lw      $fp,                0($sp)                              # restore the caller's frane pointer
    addiu   $sp,                $sp,            24                  # restore the caller's stack pointer
    jr      $ra