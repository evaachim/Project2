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

blt $s2, $v0, Prob
bgt $s2, $t3, Miu
Miu: blt $s2, $t5, Prob
bgt $s2, $s7, Prob

blt $s3, $v0, Prob
bgt $s3, $t3, Miu
Miu: blt $s3, $t5, Prob
bgt $s3, $s7, Prob

blt $s4, $v0,Tiu
Tiu: bne $t1, Prob
bgt $s4, $t3, Miu
Miu: blt $s4, $t5, Prob
bgt $s1, $s7, Prob

bne $t0, $t1, Error
beq $t0, $t1, Label1

blt $s1, $t2, L1
bge $s1, $t2, Else
Else: blt $s1, $t5, L2
bgt $s1, $t6, L3

L1: 
    addi $s1, $s1, -48  #subtracts 48 from $s1 which is 48 to get int  from 0 to 9 
L2: 
    addi $s1, $s1, -55 #gets values from 10 to 33
L3: 
    addi $s1, $s1, -87  #gets values from 10 to 33 for small caps

blt $s2, $t2, L4
bge $s2, $t2, Other
Other: blt $s2, $t5, L5
bge $s2, $t6, L6

L4: 
    addi $s2, $s2, -48
L5: 
    addi $s2, $s2, -55
L6: 
    addi $s2, $s2, -87

blt $s3, $t2, L7
bge $s3, $t5, Nope
Nope: blt $s3, $t5, L8
bgt $s3, $t6, L9

L7: addi $s3, $s3, -48
L8: addi $s3, $s3, -55
L9: addi $s3, $s3, -87

blt $s4, $t2, L10
bge $s4, $t5,Nupe
Nupe: blt $s4, $t5, L11
blt $s4, $t5, L11
bgt $s4, $t6, L12

L10: 
    addi $s4, $s4, -48
L11: 
    addi $s4, $s4, -55
L12: 
    addi $s4, $s4 , -87

syscall

add $s5, $zero, 0
add $s5,$s5, $s1
mult $s2, $t7
mflo $s2
mult $s3, $s0
mflo $s3
add $s5, $s5, $s3
mult $s0, $t7
mflo $s0
mult $s4, $s0
mflo $s4
add $s5, $s5, $s4
syscall
#last system call of the program will be very last instruction
li $v0, 10
syscall  