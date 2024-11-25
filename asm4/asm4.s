.data   

newline:    .asciiz "\n"
turtle:     .asciiz "Turtle \""
apostrophe: .asciiz "\"\n"
position:        .asciiz "  pos "
comma:      .asciiz ","
direction:        .asciiz "  dir "
north:      .asciiz "North"
east:       .asciiz "East"
south:      .asciiz "South"
west:       .asciiz "West"
odometer:       .asciiz "  odometer "

.text   
            .globl  turtle_init
            .globl  turtle_debug
            .globl  turtle_turnLeft
            .globl  turtle_turnRight
            .globl  turtle_move
            .globl  turtle_searchName
            .globl  turtle_sortByX_indirect

    #	turtle_init constructs a new turtle by settings it's
    #	x and y placeement, it's direction and it's name and it's odometer
    # 	with fetching all this data from a0
turtle_init:

    addiu   $sp,                $sp,        -24             # create stack space
    sw      $ra,                4($sp)                      # save frame pointer
    sw      $fp,                0($sp)                      # save return address
    addiu   $fp,                $sp,        20              # change frame pointer

    sb      $zero,              0($a0)                      # x = 0
    sb      $zero,              1($a0)                      # y = 0
    sb      $zero,              2($a0)                      # dir = 0
    sw      $a1,                4($a0)                      # name = param name
    sw      $zero,              8($a0)                      # odom = 0

    lw      $fp,                0($sp)                      # load old return address
    lw      $ra,                4($sp)                      # load old frame pointer
    addiu   $sp,                $sp,        24              # change stack pointer
    jr      $ra



    # turtle_debug ensure that the setup of each turtle is correct
    # so that users can debug if the order it not corret by printing
    # out seach part of the value each trutle holds and pritns a new line
    # to ensure ever data is setup correctly
turtle_debug:
    addiu   $sp,                $sp,        -24             # create stack space
    sw      $ra,                4($sp)                      # save frame pointer
    sw      $fp,                0($sp)                      # save return address
    addiu   $fp,                $sp,        20              # change frame pointer

    addiu   $sp,                $sp,        -4              # allocate stack space
    sw      $s0,                0($sp)                      # store s0 onto stack

    add     $s0,                $zero,      $a0             # s0 = Turtle *obj

    lb      $t0,                0($s0)                      # t0 = x

    addi    $s0,                $s0,        1               # s0 = 1
    lb      $t1,                0($s0)                      # t1 = y

    addi    $s0,                $s0,        1               # s0 = 2
    lb      $t2,                0($s0)                      # t2 = dir

    addi    $s0,                $s0,        2               # s0 = 4
    lw      $t3,                0($s0)                      # t3 = name

    addi    $s0,                $s0,        4               # s0 = 8
    lw      $t4,                0($s0)                      # t4 = odom

    # print turtle name
    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                turtle                      # print_str(Turtle ")
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    add     $a0,                $zero,      $t3             # print_str(name)
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                apostrophe                  # print_str("\"\n")
    syscall 


    # print position
    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                position                         # print_str("pos ")
    syscall 

    addi    $v0,                $zero,      1               # print_int()
    add     $a0,                $zero,      $t0             # print_int(x)
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                comma                       # print_str(",")
    syscall 

    addi    $v0,                $zero,      1               # print_int()
    add     $a0,                $zero,      $t1             # print_int(y)
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                newline                     # print_str("\n")
    syscall 


    # print direction
    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                direction                         # print_str(" dir ")
    syscall 

    add     $a0,                $zero,      $t2             # param int
    jal     get_Direction                                   # getDirection(int), returns String
    add     $t2,                $zero,      $v0             # t2 = getDirection(int)

    addi    $v0,                $zero,      4               # print_str()
    add     $a0,                $zero,      $t2             # print_str(dir)
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                newline                     # print_str("\n")
    syscall 


    # print odometer
    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                odometer                        # print_str("  odometer ")
    syscall 

    addi    $v0,                $zero,      1               # print_int()
    add     $a0,                $zero,      $t4             # print_int(odom)
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                newline                     # print_str("\n")
    syscall 

    addi    $v0,                $zero,      4               # print_str()
    la      $a0,                newline                     # print_str("\n")
    syscall 

    lw      $s0,                0($sp)                      # load s0 back from stack
    addiu   $sp,                $sp,        4               # fix stack pointer


    lw      $fp,                0($sp)                      # load old return address
    lw      $ra,                4($sp)                      # load old frame pointer
    addiu   $sp,                $sp,        24              # change stack pointer
    jr      $ra


    #get_Direction: is a helped function inorder to accuratly return teh correct direction of the turtle
    # dir = 0 = North, dir = 1 = East, dir = 2 = South, dir = 3 = West and will return the direction

    # return String direciton.
get_Direction:

    add     $t1,                $zero,      $zero           # t1 = 0

tryNorth:   
    bne     $a0,                $t1,        tryEast         # if (dir != 0), tryEast
    la      $t0,                north                       # retval  = "North"
    j       returnDirection

tryEast:    
    addi    $t1,                $t1,        1               # t1 ++
    bne     $a0,                $t1,        trySouth        # if (dir != 1), trySouth
    la      $t0,                east                        # retval  = "East"
    j       returnDirection

trySouth:   
    addi    $t1,                $t1,        1               # t1 ++
    bne     $a0,                $t1,        tryWest         # if (dir != 2), tryWest
    la      $t0,                south                       # retval  = "South"
    j       returnDirection

tryWest:    
    la      $t0,                west                        # retval  = "West"

returnDirection:
    add     $v0,                $zero,      $t0             # return retVal
    jr      $ra




    # tutrle_turnLeft enables the turtle to turn left 90 degress
    # by first ensuring that the dir != 0 and it will --1 to so left, however
    # if the dir is north then you add three so that it's facing west
turtle_turnLeft:
    lb      $t0,                2($a0)                      # t0 = Turtle -> dir

tryLeftNorth:
    bne     $t0,                $zero,      tryLeftRest     # if (dir != 0), tryRest
    addi    $t0,                $t0,        3               # t0 = t0 + 3
    sb      $t0,                2($a0)                      # dir = t0
    j       endTurnLeft

tryLeftRest:
    addiu   $t0,                $t0,        -1              # t0 --
    sb      $t0,                2($a0)                      # dir = t0

endTurnLeft:
    jr      $ra



    # turtle_turnRight enabels the turtle to turn right 90 degrees
    # by first ensurign that the dir != 3 and ti will ++1 to go right, however
    # if the dir is west then you rest the dir to 0 to face North
turtle_turnRight:
    lb      $t0,                2($a0)                      # t0 = Turtle -> dir
    addi    $t1,                $zero,      3               # t1 = 3

tryRightWest:
    bne     $t0,                $t1,        tryRightRest    # if (dir != 3), tryRest
    add     $t0,                $zero,      $zero           # t0 = 0 (North)
    sb      $t0,                2($a0)                      # dir = t0
    j       endTurnRight

tryRightRest:
    addi    $t0,                $t0,        1               # t0 ++
    sb      $t0,                2($a0)                      # dir = t0

endTurnRight:
    jr      $ra


    # turtle_move function moves the turtle foward by a specific distance.
    # which is depenedent on which direction it's facing, where it can travel
    # either postiive or zero. Additionally, if the distance traveled is greater
    # that the turtlres distant they can travel on teh board(-10, 10) we can't
    # move the turtle because it will do out of bounds
turtle_move:

    #clamp the value
    lw      $t0,                8($a0)                      # t0 = Turtle -> odom
    sra     $t1,                $a1,        31              # t1 = a1 >> 31
    xor     $t2,                $a1,        $t1             # t2 = XOR (t1 distance)
    sub     $t2,                $t2,        $t1
    add     $t0,                $t2,        $t0             # t0 = t0 + absVal[distance]
    sw      $t0,                8($a0)                      # Turtle -> odom = t0


    lb      $t0,                0($a0)                      # t0 = x
    lb      $t1,                1($a0)                      # t1 = y
    lb      $t2,                2($a0)                      # t2 = dir
    add     $t3,                $zero,      $zero           # t3 = 0

moveN:      
    bne     $t2,                $t3,        moveE           # if (dir != 0) try East
    slti    $t4,                $a1,        0               # t4 = (distance < 0)
    beq     $t4,                $zero,      addN            # if (distance > 0), add to North
    j       subN                                            # else subtract from North

moveE:      
    addi    $t3,                $t3,        1               # t3 = 1
    bne     $t2,                $t3,        moveS           # if (dir != 1) try South
    slti    $t4,                $a1,        0               # t4 = (distance < 0)
    beq     $t4,                $zero,      addE            # if (distance > 0), add to East
    j       subE                                            # else subtract from East

moveS:      
    addi    $t3,                $t3,        1               # t3 = 2
    bne     $t2,                $t3,        moveW           # if (dir != 2) try West
    slti    $t4,                $a1,        0               # t4 = (distance < 0)
    beq     $t4,                $zero,      addS            # if (distance > 0), add to South
    j       subS                                            # else sub from South

moveW:      
    slti    $t4,                $a1,        0               # t4 = (distance < 0)
    beq     $t4,                $zero,      addW            # if (distance > 0), add to West
    j       subW                                            # else sub from West


    # Methods that get called depending on the distance
    # that is being traveled is positive.
addN:       
addNLoop:   
    beq     $a1,                $zero,      AFTER           # if (dis == 0) quit loop
    addi    $t7,                $zero,      10              # t7 = MAX_Y
    beq     $t1,                $t7,        AFTER           # if (y == 10) quit loop
    addi    $t1,                $t1,        1               # y ++
    addiu   $a1,                $a1,        -1              # dis --;
    j       addNLoop
    j       AFTER
addE:       
addELoop:   
    beq     $a1,                $zero,      AFTER           # if (dis == 0) quit loop
    addi    $t7,                $zero,      10              # t7 = MAX_Y
    beq     $t0,                $t7,        AFTER           # if (x == 10) quit loop
    addi    $t0,                $t0,        1               # x ++
    addiu   $a1,                $a1,        -1              # dis --;
    j       addELoop
    j       AFTER
addS:       
addSLoop:   
    beq     $a1,                $zero,      AFTER           # if (dis == 0) quit loop
    addiu   $t7,                $zero,      -10             # t7 = MIN_Y
    beq     $t1,                $t7,        AFTER           # if (y == -10) quit loop
    addiu   $t1,                $t1,        -1              # y --;
    addiu   $a1,                $a1,        -1              # dis --;
    j       addSLoop
    j       AFTER
addW:       
addWLoop:   
    beq     $a1,                $zero,      AFTER           # if (dis == 0) quit loop
    addiu   $t7,                $zero,      -10             # t7 = MIN_Y
    beq     $t0,                $t7,        AFTER           # if (x == -10) quit loop
    addiu   $t0,                $t0,        -1              # x --;
    addiu   $a1,                $a1,        -1              # dis --;
    j       addWLoop
    j       AFTER


subN:       
subNLoop:   
    beq     $a1,                $zero,      AFTER           # if (dist == 0) break
    addiu   $t7,                $zero,      -10             # t7 = -10
    beq     $t1,                $t7,        AFTER           # if (y == -10) break
    addiu   $t1,                $t1,        -1              # y --;
    addi    $a1,                $a1,        1               # dist ++;
    j       subNLoop
    j       AFTER
subE:       
subELoop:   
    beq     $a1,                $zero,      AFTER           # if (dist == 0) break
    addiu   $t7,                $zero,      -10             # t7 = -10
    beq     $t0,                $t7,        AFTER           # if (x == -10) break
    addiu   $t0,                $t0,        -1              # x --;
    addi    $a1,                $a1,        1               # dist ++;
    j       subELoop
    j       AFTER
subS:       
subSLoop:   
    beq     $a1,                $zero,      AFTER           # if (dist == 0) break
    addi    $t7,                $zero,      10              # t7 = 10
    beq     $t1,                $t7,        AFTER           # if (y == 10) break
    addi    $t1,                $t1,        1               # y ++;
    addi    $a1,                $a1,        1               # dist ++;
    j       subSLoop
    j       AFTER
subW:       
subWLoop:   
    beq     $a1,                $zero,      AFTER           # if (dist == 0) break
    addi    $t7,                $zero,      10              # t7 = 10
    beq     $t0,                $t7,        AFTER           # if (x == 10) break
    addi    $t0,                $t0,        1               # x ++;
    addi    $a1,                $a1,        1               # dist ++;
    j       subWLoop
    j       AFTER

AFTER:      
    # Place all saved values back in to Turtle
    # just in case we updated anything.
    sb      $t0,                0($a0)                      # x = t0
    sb      $t1,                1($a0)                      # y = t1
    sb      $t2,                2($a0)                      # dir = t2
    jr      $ra

    # turtle_searchName function searchs through an array of different turtle
    # objects and will find the wanted turtleName

turtle_searchName:
    addiu   $sp,                $sp,        -24             # create stack space
    sw      $ra,                4($sp)                      # save frame pointer
    sw      $fp,                0($sp)                      # save return address
    addiu   $fp,                $sp,        20              # change frame pointer

    # Save all sX Regsiters that might be used
    addiu   $sp,                $sp,        -20
    sw      $s0,                0($sp)
    sw      $s1,                4($sp)
    sw      $s2,                8($sp)
    sw      $s3,                12($sp)
    sw      $s4,                16($sp)

    add     $s0,                $zero,      $zero           # i = 0
    add     $s1,                $zero,      $a0             # name = *TurtleArray
    add     $s2,                $zero,      $a1             # t2 = arrayLen

whileLoop:  
    slt     $s3,                $s0,        $s2             # t3 = (i < arrayLen)
    beq     $s3,                $zero,      False           # if   (i > arrayLen) return -1

    lw      $a0,                4($s1)                      # a0 = Turtle[i]
    add     $a1,                $zero,      $a2             # a1 = needle
    jal     strcmp

    beq     $v0,                $zero,      True            # if(name == needle) return i
    addi    $s1,                $s1,        12              # name += 12
    addi    $s0,                $s0,        1               # i ++

    j       whileLoop

False:      
    addiu   $v0,                $zero,      -1              # retVal = -1
    j       returnVal

True:       
    add     $v0,                $zero,      $s0             # Retval = i
    j       returnVal

returnVal:  

    # return all registers that might've been used.
    lw      $s0,                0($sp)
    lw      $s1,                4($sp)
    lw      $s2,                8($sp)
    lw      $s3,                12($sp)
    lw      $s4,                16($sp)
    addi    $sp,                $sp,        20

    lw      $ra,                4($sp)                      # load back	return address
    lw      $fp,                0($sp)                      # load back frame pointer
    addiu   $sp,                $sp,        24              # reset stack pointer
    jr      $ra

    # turtle_sortByX_indirect functions sorts the turtle objects in the array
    # using the x value, in this function bubble sort is being used
turtle_sortByX_indirect:

    addiu   $sp,                $sp,        -24             # create stack space
    sw      $ra,                4($sp)                      # save frame pointer
    sw      $fp,                0($sp)                      # save return address
    addiu   $fp,                $sp,        20              # change frame pointer

    addiu   $sp,                $sp,        -20
    sw      $s0,                0($sp)
    sw      $s1,                4($sp)
    sw      $s2,                8($sp)
    sw      $s3,                12($sp)
    sw      $s4,                16($sp)

    add     $s0,                $zero,      $a0             # s0 = Turtle**


    add     $t7,                $zero,      $s0             # t7 = a0
    add     $t0,                $zero,      $zero           # t0 = i = 0
    addi    $s4,                $zero,      4               # s4 = 4
    mult    $a1,                $s4                         # arrayLen * 4
    mflo    $a1                                             # arrayLen = arrayLen * 4

    addiu   $a1,                $a1,        -4              # arrayLen --

outerLoop:  
    slt     $t1,                $t0,        $a1             # t1 = (i < arrayLen - 1)
    beq     $t1,                $zero,      endLoop         # if (i > arrLen) exit loop
    add     $t1,                $zero,      $zero           # t1 = j = 0
    addi    $s1,                $zero,      4               # s1 = j + 1

innerLoop:  

    add     $t5,                $t7,        $s1             # t5 = &Turtle[j + 1]
    add     $t6,                $t7,        $t1             # t6 = &Turtle[j]
    sub     $t4,                $a1,        $t0
    slt     $t2,                $t1,        $t4             # t2 = (j < arrayLen)
    beq     $t2,                $zero,      addI            # if ( j > arrayLen) exit inner loop

    lw      $s2,                0($t5)                      # t5 = Turtle[i]
    lw      $s3,                0($t6)                      # t6 = Turtle[j]

    lb      $t3,                0($s2)                      # t3 = j + 1.x
    lb      $t2,                0($s3)                      # t2 = j.x

    slt     $s4,                $t3,        $t2             # s4 = arr[j + 1] < arr[j]
    beq     $s4,                $zero,      skip            # if s4 != true dont check

    sw      $s2,                0($t6)                      # Turtle[j+1]   = temp
    sw      $s3,                0($t5)                      # Turtle[j]     = Turtle[j+1]

skip:       
    addi    $t1,                $t1,        4               # j ++
    addi    $s1,                $s1,        4               # j + 1 ++
    j       innerLoop

addI:       
    addi    $t0,                $t0,        4               # i ++;
    j       outerLoop


endLoop:    
    lw      $s0,                0($sp)
    lw      $s1,                4($sp)
    lw      $s2,                8($sp)
    lw      $s3,                12($sp)
    lw      $s4,                16($sp)
    addi    $sp,                $sp,        20

    lw      $ra,                4($sp)                      # load back	return address
    lw      $fp,                0($sp)                      # load back frame pointer
    addiu   $sp,                $sp,        24              # reset stack pointer
    jr      $ra