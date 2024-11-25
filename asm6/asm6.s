#The game below is known as a Guessing game where the user has the option to select a easy or 
#hard mode, with the easy mode being in a range of 1-100 and the hard mode being the range of 
#1-1000, additionally I've implemented a scoring system where the fewer guess you take the high the score
# you'll recieve. 
.data

goodbye_text:       .asciiz "Thank you for playing, goodbye"
youLose_text:       .asciiz "Maximum guesses of 10 reached, you lose \n"
congrat_text:       .asciiz "Congratulations, you’ve guessed the secret number \n"
guess_prompt:       .asciiz "Please enter a guess: "
tooHigh_text:       .asciiz "Guess is too high \n"
tooLow_text:        .asciiz "Guess is too low \n"
secretNumber_text:  .asciiz "Secret Number: "
guesses_text:       .asciiz "Guesses: "
score_text:         .asciiz "Score: "
new_line:           .asciiz "\n"
difficulty_prompt:  .asciiz "Choose difficulty level (0 for Easy, 1 for Hard): "
easy_range:         .asciiz "Enter a guess (1-100): "
hard_range:         .asciiz "Enter a guess (1-1000): "

.text

main:
        # Ask the player for difficulty level
        addi $v0, $0, 4               # code for print_string
        la   $a0, difficulty_prompt   # point $a0 to difficulty_prompt string
        syscall                       # print the string

        addi $v0, $0, 5               # code for read_int
        syscall                       # get an int from user --> returned in $v0
        move $s1, $v0                 # move the difficulty level to $s1

        # Determine the secret number range based on difficulty level
        beq  $s1, $0, EASY            # If difficulty level is 0, set the range to 1-100
        beq  $s1, $1, HARD            # If difficulty level is 1, set the range to 1-1000
        j    EASY                     # Default to EASY difficulty if input is invalid

EASY:
        addi $t3, $0, 100             # Set the range to 1-100
        la   $a0, easy_range          # Load easy range string
        j    GENERATE_SECRET_NUMBER

HARD:
        addi $t3, $0, 1000            # Set the range to 1-1000
        la   $a0, hard_range          # Load hard range string
        j GENERATE_SECRET_NUMBER

GENERATE_SECRET_NUMBER:
        # Generate a random secret number within the specified range
        li $v0, 42                     # code for random integer
        addi $a0, $zero, 1             # load 1 into $a0 (minimum value)
        move $a1, $t3                  # load $t3 (maximum value) into $a1
        syscall                        # generate random number
        move $t4, $v0                  # store the random number in $t4

        # Initialize the loop counter
        addi $t0, $0, 0                # load constant into t0 (i = 0)
        li   $t6, 1000 
LOOP:
        slti $t1, $t0, 10              # t1 = 1 if i < 10, t1 = 0 if i >= 10
        beq  $t1, $0, LOSE             # if i >= 10, goto LOSE

        # Display guess prompt
        addi $v0, $0, 4                # code for print_string
        la   $a0, guess_prompt         # point $a0 to guess_prompt string
        syscall                        # print the string

        # Display range of values to guess
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string
        beq  $s1, $0, EASY_RANGE       # If difficulty level is 0, load easy range string
        la   $a0, hard_range           # Load hard range string
        j    RANGE_LOADED
EASY_RANGE:
        la   $a0, easy_range           # Load easy range string
RANGE_LOADED:
        syscall                        # print the string

        # Get an integer from the user
        addi $v0, $0, 5                # code for read_int
        syscall                        # get an int from user --> returned in $v0
        move $s0, $v0                  # move the resulting int to $s0    

        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

        addi $t0, $t0, 1               # i++    

        beq  $s0, $t4, WIN             # if (user input == secretNum) goto WIN

        slt  $t3, $t4, $s0             # t3 = 0 if userinput < secretNum, t3 = 1 if userinput >= secretNum
        beq  $t3, $0, LOW              # if t3 = 0 go to LOW
        j    HIGH                      # else jump to HIGH    

LOW:
        # Print tooLow_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, tooLow_text          # point $a0 to tooLow_text string
        syscall                        # print the string
        j    LOOP                      # jump to LOOP

HIGH:
        # Print tooHigh_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, tooHigh_text         # point $a0 to tooHigh_text string
        syscall                        # print the string
        j    LOOP                      # jump to LOOP

LOSE:
        # Print youLose_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, youLose_text         # point $a0 to youLose_text string
        syscall                        # print the string
        
        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

        # Print secretNumber_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, secretNumber_text    # point $a0 to secretNumber_text string
        syscall                        # print the string 
        
        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

        # Print secretNumber
        addi $v0, $0, 1                # code for print_int
        move $a0, $t4                  # move secretNum($t4) into $a0
        syscall                        # print the string
        j    END                       # jump to END

WIN:
        # Calculate score
        sub $t6, $t6, $t0              # Subtract guesses from maximum score
        # Print congrat_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, congrat_text         # point $a0 to congrat_text string
        syscall                        # print the string 

        # Print secretNumber_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, secretNumber_text    # point $a0 to secretNumber_text string
        syscall                        # print the string 

        # Print secretNumber
        addi $v0, $0, 1                # code for print_int
        move $a0, $t4                  # move secretNum($t4) into $a0
        syscall                        # print the string    

        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

        # Print guesses_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, guesses_text         # point $a0 to guesses_text string
        syscall                        # print the string 

        # Print numGuesses
        addi $v0, $0, 1                # code for print_int
        move $a0, $t0                  # move $t0 (i) into $a0
        syscall                        # print the string

        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

        # Print score_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, score_text           # point $a0 to score_text string
        syscall                        # print the string 

        # Print score
        addi $v0, $0, 1                # code for print_int
        move $a0, $t6                  # move score($t6) into $a0
        syscall                        # print the string 

        # Print new line
        addi $v0, $0, 4                # code for print_string
        la   $a0, new_line             # point $a0 to new_line string
        syscall                        # print the string

END:
        # Print goodbye_text
        addi $v0, $0, 4                # code for print_string
        la   $a0, goodbye_text         # point $a0 to goodbye_text string
        syscall                        # print the string

        # Exit the program
        addi $v0, $0, 10               # code for exit
        syscall                        # exit program
