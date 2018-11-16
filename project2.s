.data
  userInput:    .space  700
  empty:   .asciiz "Input is empty."
   long:    .asciiz "Input is too long."
  invalid: .asciiz "Invalid base-33 number."


.text
ErrorEmpty:
  la $a0, empty
  li $v0, 4
  syscall
  j end

ErrorInvalid:
  la $a0, invalid
  li $v0, 4
  syscall
  j end


ErrorEmpty:
  la $a0, empty
  li $v0, 4
  syscall
  j end

main:
  li $v0, 8
  la $a0, userInput
  li $a1, 200
  syscall

Rid:
li $t9, 32 # space
lb $t8, 0($a0)
beq $t9, $t8, Character
move $t8, $a0
j length

Character:
addi $a0, $a0, 1
j Rid

#takes care of length
length:
addi $t0, $t0, 0
addi $t1, $t1, 10
add $t2, $t2, $a0

#itertates through the array
traverse:
lb $s2, 0($a0)
beqz $s2, discovered
beq $s2, $t1, discovered
addi $a0, $a0, 1
addi $t0, $t0, 1
j traverse

discovered: #busted empty space or input that violates limit
beqz $t0, ErrorEmpty  #if it's empty go to case for empty which outputs error message
slti $t4, $t0, 5
beqz $t4, ErrorLong #if it's too long, go to case for too long and print message
move $a0, $t2
j verify  #go to next verification process

#checks inputs
verify:
lb $s3, 0($a0) #loads address here
beqz $s3, initial  #go to initial step for conversion
beq $s3, $t1, initial  #go to initial step for conversion
slti $t3, $s3, 48                 #invalid for anything below 0
bne $t3, $zero, ErrorInvalid
slti $t3, $s3, 58                 #legal input for everything less than or equal to 9
bne $t3, $zero, Move
slti $t3, $s3, 65                 #legal input for everything less than or equal to 65,  'a'
bne $t3, $zero, Move
slti $t3, $s3, 88                 #legal input for anything less than or equal to the acii code 88
bne $t3, $zero, Move
slti $t3, $s3, 97                 # invalid input, not numerical nor alphabetical
bne $t3, $zero, ErrorInvalid
slti $t3, $s3, 120                #legal input for lower case characters
bne $t3, $zero, Move
bgt $s3, 119, ErrorInvalid   # illegal input, out of range

Move:  #now we iterate again, this time to check for invalid input
addi $a0, $a0, 1 #iterates
j verify #goes to verification point


initial:  #first step of conversion, does the prerequisite work for translation into base 10
move $a0, $t2  #moves content
addi $t5, $t5, 0  #$t5 has 0 now
add $s0, $s0, $t0  