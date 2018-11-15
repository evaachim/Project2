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
  li $a1, 100
  syscall




li $v0, 4
la $a0, userInput
syscall

lb $s1, 1($a0)  #last digit
lb $s2 2($a0)   #third
lb $s3 3($a0)   #second digit
lb $s4, 4($a0)  #first digit
lb $t0, 0($a0) #checks for \n


addi $t1, $zero, 10 #takes in \n
addi $t7, $zero, 33   #gets value to multiply
addi $s0, $zero, 1089  #gets 33^2
addi $t5, $zero, 97  #gets 64, smaller than ascii code for 'A'
addi $t6, $zero 96  #gets 96, smaller than ascii code for 'a'
addi $t2, $zero, 65  #loads 65 into $t2, smaller than the ascii code for '0'
addi $s7, $zero, 119 #maximum
addi $t3, $zero, 87
addi $v0, $zero, 48

blt $s1, $v0, Tiu
Tiu: bne $t1, Prob
bgt $s1, $t3, Miu
Miu: blt $s1, $t5, Prob
bgt $s1, $s7, Prob

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