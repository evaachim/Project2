.data
Ask:

.asciiz "\n Please Enter 4 Characters\n" 

userInput:  .space 20

Answer:

.asciiz "\n You Entered : \n"

.text 

main:
  
li $v0, 4
la $a0, Ask #display question
syscall

li $v0, 8 #get input
la $a0, userInput
li $a1, 20
syscall

li $v0, 4
la $a0, Answer
syscall

li $v0, 4
la $a0, userInput
syscall

#last system call of the program will be very last instruction
li $v0, 10
syscall  