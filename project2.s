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
addi $s0, $s0, -1 #decrement	
li $s4, 3  #load immediate puts values in registers to be used
li $s5, 2
li $s6, 1
li $s1, 0

translate:
lb $s7, 0($a0)   #loads digits
beqz $s7, final  #final conversion step
beq $s7, $t1, final #if branch statement is true, move to final conversion statement
slti $t3, $s7, 58  #checks for less than or equal to 58
bne $t3, $zero, Base  #OK to move forward if $t3 is not null
slti $t3, $s7, 88  #max for upper
bne $t3, $zero, Mari  #OK to go to conversion of upper characters if $t3 is not null
slti $t3, $s7, 120     #max for lower
bne $t3, $zero, Mici #OK to go to conversion of lower characters if $t3 is not null

Base: 
addi $s7, $s7, -48  #conversion for regular numbers
j row

Mari:
addi $s7, $s7, -55  #conversion for upper case
j row

Mici:
addi $s7, $s7, -87  #conversion for lowe case

row:  #determines which digit needs to be converted and goes to appropiate label
beq $s0, $s4, one  #sequential checks 
beq $s0, $s5, two
beq $s0, $s6, three
beq $s0, $s1, last

one:
li $t6, 35937   #values to multiply by for the power of 3
mult $s7, $t6
mflo $t7
add $t5, $t5, $t7
addi $s0, $s0, -1
addi $a0, $a0, 1
j translate
two:
li $t6, 1089   #values to multiply by for the power of 2
mult $s7, $t6
mflo $t7
add $t5, $t5, $t7
addi $s0, $s0, -1 #decrement
addi $a0, $a0, 1 #increment to move forward
j translatethree:
j translate

three:
li $t6, 33   #values to multiply by for the power of 1
mult $s7, $t6
mflo $t7
addi $s0, $s0, -1
addi $a0, $a0, 1
j translatelast:
li $t6, 1    #values to multiply by for the power of 0
mult $s7, $t6
mflo $t7
add $t5, $t5, $t7 
