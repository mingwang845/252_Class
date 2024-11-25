.data   
NEWLINE:        .asciiz "\n"
SPACE:          .asciiz " "
EXCLAMATION:    .asciiz "!\n"
PERIOD:         .asciiz ".\n"

bottlesFirst:   .asciiz " bottles of "
bottlesSecond:  .asciiz " on the wall, "
bottlesThird:   .asciiz "Take one down, pass it around, "
bottlesFourth:  .asciiz " on the wall"
bottlesLast:    .asciiz "No more bottles of "
b:              .asciiz "b is equal to: "

.text   
                .globl  strlen
                .globl  gcf
                .globl  bottles
                .globl  longestSorted
                .globl  rotate




longestSorted:  
    addiu   $sp,                        $sp,            -24                     # create stack space
    sw      $ra,                        4($sp)                                  # save frame pointer
    sw      $fp,                        0($sp)                                  # save return address
    addiu   $fp,                        $sp,            20                      # change frame pointer

    addiu   $sp,                        $sp,            -32						# create stack space
    sw      $s0,                        0($sp)                                  # save s0
    sw      $s1,                        4($sp)                                  # save s1
    sw      $s2,                        8($sp)                                  # save s2
    sw      $s3,                        12($sp)                                 # save s3
    sw      $s4,                        16($sp)                                 # save s4
    sw      $s5,                        20($sp)                                 # save s5
    sw      $s6,                        24($sp)                                 # save s6
    sw      $s7,                        28($sp)                                 # save s7

    add     $t0,                        $zero,          $a0
    add     $s0,                        $zero,          $a0                     # s0 = int[] array
    add     $s1,                        $a1,            $zero                   # s1 = array.length()

FIRST_CHECK:    
    bne     $s1,                        $zero,          SECOND_CHECK            # if (length != 0) jump to first
    add     $v0,                        $zero,          $zero                   # retval = 0
    j       LONGEST_SORTED_EPILOGUE

SECOND_CHECK:   
    addi    $t2,                        $zero,          1                       # t2 = 1
    bne     $s1,                        $t2,            START_LOOP              # if (length != 1) go to algorithm
    addi    $v0,                        $zero,          1                       # retval = 1
    j       LONGEST_SORTED_EPILOGUE

START_LOOP:     
    addi    $s2,                        $zero,          1                       # s2 = count = 1
    addi    $s3,                        $zero,          1                       # s3 = longest = 1

    add     $s4,                        $zero,          $zero                   # s4 = i = 0

FOR_LOOP_ITERATION:

    addi    $t1,                        $s1,            -1                      # t1 = length - 1
    slt     $t0,                        $s4,            $t1                     # t0 = (i < length - 1)
    beq     $t0,                        $zero,          RETURN_LONGEST_SEQUENCE # if (false) return longest

    addi    $t0,                        $s4,            1                       # t0 = i + 1
    addi    $t2,                        $zero,          4                       # t2 = 4

    mult    $t0,                        $t2                                     # (i + 1) * 4
    mflo    $t0                                                                 # t0 = (i - 1) * 4

    mult    $s4,                        $t2                                     # (i) * 4
    mflo    $t1                                                                 # t1 = (i) * 4

    add     $t0,                        $s0,            $t0                     # t0 = &a[i+1]
    add     $t1,                        $s0,            $t1                     # t1 = &a[i]

    lw      $t2,                        0($t0)                                  # t2 = array[i + 1]
    lw      $t3,                        0($t1)                                  # t3 = array[i]

    slt     $t4,                        $t2,            $t3                     # t4 = (a[i + 1]) < a[i])
    addi    $t5,                        $zero,          1                       # t5 = 1
    beq     $t4,                        $t5,            CONTINUE_LOOP           # if (true)

    addi    $s2,                        $s2,            1                       # count ++

    slt     $t4,                        $s3,            $s2                     # t4 = (max < count)
    beq     $t4,                        $zero,          ELSE_ITERATION          # if (false)
    add     $s3,                        $s2,            $zero                   # longest = count

    j       CONTINUE_LOOP

ELSE_ITERATION: 
    addi    $s2,                        $zero,          1                       # count = 1

CONTINUE_LOOP:  
    addi    $s4,                        $s4,            1                       # i ++
    j       FOR_LOOP_ITERATION

RETURN_LONGEST_SEQUENCE:
    add     $v0,                        $zero,          $s3
    j       LONGEST_SORTED_EPILOGUE


LONGEST_SORTED_EPILOGUE:
    lw      $s7,                        28($sp)                                 # load pointer address 28
    lw      $s6,                        24($sp)                                 # load pointer address 24
    lw      $s5,                        20($sp)                                 # load pointer address 20
    lw      $s4,                        16($sp)                                 # load pointer address 16
    lw      $s3,                        12($sp)                                 # load pointer address 12
    lw      $s2,                        8($sp)                                  # load pointer address 8
    lw      $s1,                        4($sp)                                  # load pointer address 4
    lw      $s0,                        0($sp)                                  # load pointer address 0
    addiu   $sp,                        $sp,            32

    lw      $fp,                        0($sp)                                  # load old return address
    lw      $ra,                        4($sp)                                  # load old frame pointer
    addiu   $sp,                        $sp,            24                      # change stack pointer
    jr      $ra

    # rotate takes seven different parameters and then calls the util() function
    # that is given within the testcases. And returns a integer value that is given from the util()
    # printing out the rotation
    # s0 = retVal
    # s1 = a
    # s2 = b
    # s3 = c
    # s4 = d
    # s5 = e
    # s6 = f
    # s7 = count

rotate:         
    addiu   $sp,                        $sp,            -28                     # create stack space
    sw      $ra,                        4($sp)                                  # save frame pointer
    sw      $fp,                        0($sp)                                  # save return address
    addiu   $fp,                        $sp,            24                      # change frame pointer

    lw      $t4,                        16($sp)                                 # t4 = d
    lw      $t5,                        20($sp)                                 # t5 = e
    lw      $t6,                        24($sp)                                 # t6 = f

    addiu   $sp,                        $sp,            -32						# create stack space
    sw      $s0,                        0($sp)                                  # save s0
    sw      $s1,                        4($sp)                                  # save s1
    sw      $s2,                        8($sp)                                  # save s2
    sw      $s3,                        12($sp)                                 # save s3
    sw      $s4,                        16($sp)                                 # save s4
    sw      $s5,                        20($sp)                                 # save s5
    sw      $s6,                        24($sp)                                 # save s6
    sw      $s7,                        28($sp)                                 # save s7

    add     $s1,                        $zero,          $a1                     # s1 = a
    add     $s2,                        $zero,          $a2                     # s2 = b
    add     $s3,                        $zero,          $a3                     # s3 = c
    add     $s4,                        $zero,          $t4                     # s4 = d
    add     $s5,                        $zero,          $t5                     # s5 = e
    add     $s6,                        $zero,          $t6                     # s6 = f

    add     $s0,                        $zero,          $zero                   # s0 = retVal
    add     $t0,                        $zero,          $zero                   # i = 0
    add     $s7,                        $zero,          $a0                     # s7 = count

ROTATE_LOOP:    
    addi    $t1,                        $zero,          1                       # t1 = 1
    slt     $t3,                        $t0,            $s7                     # t3 = (i < count)
    bne     $t3,                        $t1,            ROTATE_EPILOGUE         # if (i > count) exit for

    add     $a0,                        $zero,          $s1                     # a0 = a
    add     $a1,                        $zero,          $s2                     # a1 = b
    add     $a2,                        $zero,          $s3                     # a2 = c
    add     $a3,                        $zero,          $s4                     # a3 = d

    sw      $s5,                        -8($sp)                                 # param e
    sw      $s6,                        -4($sp)                                 # param f

    add     $s5,                        $zero,          $t0                     # s5 = $t0

    jal     util
    add     $s0,                        $s0,            $v0                     # retval += util(a, b, c, d, e, f)

    add     $t0,                        $zero,          $s5

    lw      $s6,                        -4($sp)                                 # s6 = f
    lw      $s5,                        -8($sp)                                 # s5 = e

    add     $t1,                        $zero,          $s1                     # t1 = a
    add     $s1,                        $zero,          $s2                     # a = b
    add     $s2,                        $zero,          $s3                     # b = c
    add     $s3,                        $zero,          $s4                     # c = d
    add     $s4,                        $zero,          $s5                     # d = e
    add     $s5,                        $zero,          $s6                     # e = f
    add     $s6,                        $zero,          $t1                     # f = temp

    addi    $t0,                        $t0,            1                       # i ++
    j       ROTATE_LOOP

ROTATE_EPILOGUE:
    add     $v0,                        $zero,          $s0                     # v0 = retVal

    lw      $s3,                        16($sp)                                 # load pointer address 16
    lw      $s2,                        20($sp)                                 # load pointer address 20
    lw      $s1,                        24($sp)                                 # load pointer address 24

    lw      $s7,                        28($sp)                                 # load pointer address 28
    lw      $s6,                        24($sp)                                 # load pointer address 24
    lw      $s5,                        20($sp)                                 # load pointer address 20
    lw      $s4,                        16($sp)                                 # load pointer address 16
    lw      $s3,                        12($sp)                                 # load pointer address 12
    lw      $s2,                        8($sp)                                  # load pointer address 8
    lw      $s1,                        4($sp)                                  # load pointer address 4
    lw      $s0,                        0($sp)                                  # load pointer address 0
    addiu   $sp,                        $sp,            32

    lw      $ra,                        4($sp)
    lw      $fp,                        0($sp)
    addiu   $sp,                        $sp,            28
    jr      $ra

    #	Bottles takes two parameters, with the first parameter being the count
    # 	and the second paramter is the string that is what the user that's the bottle to contain
    # t4 = count
    # t5 = drink
    # t7 = i


bottles:        
    addiu   $sp,                        $sp,            -24                     # create stack space
    sw      $ra,                        4($sp)                                  # save frame pointer
    sw      $fp,                        0($sp)                                  # save return address
    addiu   $fp,                        $sp,            20                      # change frame pointer

    add     $t4,                        $zero,          $a0                     # t4 = count
    add     $t5,                        $zero,          $a1                     # t5 = drink
    add     $t0,                        $zero,          $a0                     # i = count

BOTTLES_LOOP:   
    slt     $t1,                        $zero,          $t0                     # 0 < i
    addi    $t2,                        $zero,          1                       # t2 = 1
    bne     $t1,                        $t2,            BOTTLES_AFTER           # if ( i < 0 ) exit for loop

    addi    $v0,                        $zero,          1                       # print_int
    add     $a0,                        $zero,          $t0                     # print_int(i)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesFirst                            # print_str(bottlesFirst)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    add     $a0,                        $zero,          $t5                     # print_str(drink)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesSecond                           # print_str(bottlesSecond)
    syscall 

    addi    $v0,                        $zero,          1                       # print_int
    add     $a0,                        $zero,          $t0                     # print_int(i)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesFirst                            # print_str(bottlesFirst)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    add     $a0,                        $zero,          $t5                     # print_str(drink)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        EXCLAMATION                             # print_str("!\n")
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesThird                            # print_str(bottlesThird)
    syscall 

    sub     $t0,                        $t0,            $t2                     # i --

    addi    $v0,                        $zero,          1                       # print_int
    add     $a0,                        $zero,          $t0                     # print_int(i)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesFirst                            # print_str(bottlesFirst)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    add     $a0,                        $zero,          $t5                     # print_str(drink)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        bottlesFourth                           # print_str(bottlesFouth)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        PERIOD                                  # print_str(".\n")
    syscall 

    addi    $v0,                        $zero,          4                       # print_str
    la      $a0,                        NEWLINE                                 # print_str("\n")
    syscall 

    beq     $t0,                        $zero,          BOTTLES_AFTER           # if i = 0, exit loop
    j       BOTTLES_LOOP

BOTTLES_AFTER:  
    addi    $v0,                        $zero,          4                       # print_str()
    la      $a0,                        bottlesLast                             # print_str(No more..)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str()
    add     $a0,                        $zero,          $t5                     # print_str(drink)
    syscall 

    addi    $v0,                        $zero,          4                       # print_str()
    la      $a0,                        bottlesFourth                           # print_str(" on the wall")
    syscall 

    addi    $v0,                        $zero,          4                       # print_str()
    la      $a0,                        EXCLAMATION                             # print_str("!\n")
    syscall 

    addi    $v0,                        $zero,          4                       # print_str()
    la      $a0,                        NEWLINE                                 # print_str("\n")
    syscall 


    lw      $fp,                        0($sp)                                  # load old return address
    lw      $ra,                        4($sp)                                  # load old frame pointer
    addiu   $sp,                        $sp,            24                      # change stack pointer
    jr      $ra                                                                 # END BOTTLES

    #	strlen counts the amount of characters in a string
    #	which returns the length of the string that is inputted
    #	which is load in through t1
    #   v0 = count
    #   t1 = string
    #   t0 = str[i]
strlen:         
    addiu   $sp,                        $sp,            -24                     #   allocat4e stack space of 32
    sw      $fp,                        0($sp)                                  #   save caller's frame pointer
    sw      $ra,                        4($sp)                                  #   save return address
    addiu   $fp,                        $sp,            20                      #   stup main's frame pointer

    addiu   $v0,                        $zero,          0                       # initalizes t0 as counter to zero
    add     $t1,                        $zero,          $a0                     # t1 = string

STR_LOOP:       
    lb      $t0,                        0($t1)                                  # t0 = str[i]
    beq     $t0,                        $zero,          STR_LOOP_EPILOGUE       # if(str[i] == null) j STR_LOOP_DONE

    addi    $t1,                        $t1,            1                       # add one to pointer str
    addi    $v0,                        $v0,            1                       # count ++

    j       STR_LOOP                                                            # j STR_LOOP

STR_LOOP_EPILOGUE:
    lw      $ra,                        4($sp)                                  # get return address from stack
    lw      $fp,                        0($sp)                                  # restore the caller's framer pointer
    addiu   $sp,                        $sp,            24                      # restore the caller's stack pointer
    jr      $ra                                                                 # return to caller's code

    # 	GCF is a function that takes two parameters a and b
    #	and then calcultes the greatest common factor between
    #	paramters a and b.
    #   a0 = int a
    #   b0 = int b
    #   t0 = int a
    #   t1 = int b

gcf:            
    addiu   $sp,                        $sp,            -24                     #   allocat4e stack space of 32
    sw      $fp,                        0($sp)                                  #   save caller's frame pointer
    sw      $ra,                        4($sp)                                  #   save return address
    addiu   $fp,                        $sp,            20                      #   stup main's frame pointer

    add     $t0,                        $zero,          $a0                     # t0 = a
    add     $t1,                        $zero,          $a1                     # t1 = b

GCF_FIRST_IF:   

    slt     $t2,                        $t0,            $t1                     # t2 = a< b
    beq     $t2,                        $zero,          GCF_SECOND_IF           # if(t2 == 0) j GCF_SECOND_IF

    add     $t2,                        $zero,          $t1                     # t2 = b
    add     $t1,                        $zero,          $t0                     # t1 = a
    add     $t0,                        $zero,          $t2                     # t0 = b

GCF_SECOND_IF:  
    addi    $t2,                        $zero,          1                       # t2 = 1
    bne     $t1,                        $t2,            GCF_THIRD_IF            # if (b != 1) try third ii
    addi    $v0,                        $zero,          1                       # retVal = 1
    j       GCF_EPILOGUE

GCF_THIRD_IF:   
    div     $t0,                        $t1                                     # hi/lo a/b
    mfhi    $t2                                                                 # t2 = a % b
    bne     $t2,                        $zero,          GCF_ELSE                # if (a % b != 0) do else

    add     $v0,                        $zero,          $t1                     # retVal = b
    j       GCF_EPILOGUE                                                        # return b

GCF_ELSE:       
    div     $t0,                        $t1                                     # hi/lo a/b
    mfhi    $t2                                                                 # t0 = a % b

    add     $a0,                        $zero,          $t1                     # a = b
    add     $a1,                        $zero,          $t2                     # b = a % b
    jal     gcf


GCF_EPILOGUE:   
    lw      $ra,                        4($sp)                                  # get return address from stack
    lw      $fp,                        0($sp)                                  # restore the caller's framer pointer
    addiu   $sp,                        $sp,            24                      # restore the caller's stack pointer
    jr      $ra                                                                 # return to caller's code


