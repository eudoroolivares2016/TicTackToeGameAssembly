##########################
#Eudoro Olivares	 #
#CSCI 370		 #
#Wen Chen Hu		 #
#Spring 2019		 #
#January 26 2019	 #
#Programming Assignment 1#
###########################

.data
welcomeMessage:	.asciiz		"\n  Hello, welcome to the premium MIPS tick-tac-toe game!"


board:    .ascii "\n\n  | . . . . | . . . . | . . . . | . . . . |   a b c d"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   e f g h"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   i j k l"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   m n o p"
          .asciiz  "\n  |   (0)   |   (1)   |   (2)   |   (3)   |   (index)\n"
          
blankBoard:.ascii "\n\n  | . . . . | . . . . | . . . . | . . . . |   a b c d"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   e f g h"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   i j k l"
          .ascii   "\n  | . . . . | . . . . | . . . . | . . . . |   m n o p"
          .asciiz  "\n  |   (0)   |   (1)   |   (2)   |   (3)   |   (index)\n"



offset:    .half   6,   8,  10,  12,  16,  18,  20,  22,  26,  28,  30,  32,  36,  38,  40,  42
           .half  60,  62,  64,  66,  70,  72,  74,  76,  80,  82,  84,  86,  90,  92,  94,  96
           .half 114, 116, 118, 120, 124, 126, 128, 130, 134, 136, 138, 140, 144, 146, 148, 150
           .half 168, 170, 172, 174, 178, 180, 182, 184, 188, 190, 192, 194, 198, 200, 202, 204
           
gridIdPrompt: .asciiz  "\n Which grid do you want to mark "
indexPrompt: .asciiz  "\n Which index do you want to mark "
continueGamePrompt: .asciiz  "\n Do you want to continue playing the game?(y/n)  "
newGamePrompt: .asciiz  "\n Would you like to start a new game ?(y/n)  "
pieceSelectionPrompt: .asciiz "\n Which piece do you want to play as x or o"
invalidPlacementPrompt: .asciiz "\n Sorry that is an invalid spot, only select unfilled positions try again "
userGamePiece: .word 0
grid:     .word  0
cell:     .byte  'a'

.text	##Assembly Language instructions go in text segment
main:

								#Inital setup of the game display blank board ask which piece loop back until valid answer
#############################################################################################################################################################################


li 	$v0, 4		#system call code for printing string = 4.
la	$a0,welcomeMessage #load address of string to be printed into $a0
syscall	

li 	$v0, 4		#system call code for printing string = 4.
la	$a0,board #load address of string to be printed into $a0
syscall			#call operating system to perform operation.
				#specified in $v0
				# syscall takes its arguements from $a0, $al,...


li 	$v0, 4		#system call code for printing string = 4.
la	$a0,pieceSelectionPrompt #load address of string to be printed into $a0
syscall	

				#get game peice type
#####################################################################################

#getPiece: 
li $v0,12 #get the game piece choice o or x 
beq $v0,'x',LoopX
beq $v0,'o',LoopX
syscall
#j getPiece
									#procedure if it is the X person's turn
####################################################################################################################################################################################
invalidMoveX:
li $v0, 4 
la $a0, invalidPlacementPrompt
syscall
jal LoopX

LoopX: 

li 	$v0, 4		#system call code for printing string = 4.
la	$a0,gridIdPrompt #load address of string to be printed into $a0
syscall			#call operating system to perform operation.
	
 li  $v0, 12           # service 5 is read integer
syscall
sub $v0, $v0, 48  # 48 is the acii value that differenciates between the character for a number and the actual value

move  $a0, $v0
li  $v0, 1           # print hte v0 value

syscall   
sw    $a0, grid
li 	$v0, 4		#system call code for printing string = 4.
la	$a0,indexPrompt #load address of string to be printed into $a0
syscall			#call operating system to perform operation.

li  $v0, 12           # service 12 is read character
syscall
    
move $a0, $v0
li $v0, 11
syscall

sub $a0,$a0,'a'
sb     $a0, cell

#$t0 = (cell÷4)×16 + grid×4 + cell%4,   

#------- $t1  ------ $t2----- $s0

lw $t1,cell  # load into t1 the value stored in the cell input varaible 
	
divu $t1, $t1, 4  # set t1 to t1/4
	 
mul $t1 , $t1, 16 #multiply into t1, t1 x 16

lw $t2, grid # load into t2 the value stored in the grid input varaible 
	
mul $t2, $t2 ,4 #multiply the value stored in $t2 which is the input value for the grid times 4 into $t2
	
add $t0, $t1,$t2 #sum the values stored in the $t1,$t2 registers which is the first 2/3 section of the equation
	
lw $s0, cell #load the value of cell into the $t3 register, this is done instead of reusing the $t1 register just for convenience and keeping the values straightfoward
	
divu $t3, $s0,4
mfhi $t3 
	
add $t0, $t0,$t3 #add the first half of the equation which is in 10 with t3 the last third of the equation



   # li     $t0, 22
    
    
    
mul  $t0, $t0, 2        # Each offset is two-byte long.
lh   $t1, offset($t0)   # Load $t1 with the offset of the index $t0.





lb $t9, board($t1)
bne $t9,'.',invalidMoveX








li   $t2, 'X'           # Put the piece ‘X’ in $t2.
sb   $t2, board($t1)    # Put the piece at the location, board+offset.

	


li 	$v0, 4		#system call code for printing string = 4.
la	$a0,board #load address of string to be printed into $a0
syscall	





# go back to o here 


li $v0,4
la $a0,continueGamePrompt 
syscall 




li $v0,12 	#take in the user input for the 
syscall
beq $v0,'n', endgame
jal LoopO
										#procedure if it is the O person's turn
########################################################################################################################################################################
invalidMoveO:
li $v0, 4 
la $a0, invalidPlacementPrompt
jal LoopO
syscall

LoopO: 
li 	$v0, 4		#system call code for printing string = 4.
la	$a0,gridIdPrompt #load address of string to be printed into $a0
syscall			#call operating system to perform operation.
	
 li  $v0, 12           # service 5 is read integer
syscall
sub $v0, $v0, 48 # 48 is the acii value that differenciates between the character for a number and the actual value
move  $a0, $v0
li  $v0, 1           # print hte v0 value
syscall   
sw    $a0, grid
li 	$v0, 4		#system call code for printing string = 4.
la	$a0,indexPrompt #load address of string to be printed into $a0
syscall			#call operating system to perform operation.
li  $v0, 12           # service 12 is read character
    syscall
    
    move   $a0, $v0
    li     $v0, 11
    syscall



	sub $a0,$a0,'a'

    sb     $a0, cell

#$t0 = (cell÷4)×16 + grid×4 + cell%4,   

#------- $t1  ------ $t2----- $s0

lw $t1,cell  # load into t1 the value stored in the cell input varaible 
	
divu $t1, $t1, 4  # set t1 to t1/4
	 
 mul $t1 , $t1, 16 #multiply into t1, t1 x 16
	 
	 
	 
lw $t2, grid # load into t2 the value stored in the grid input varaible 
	
	
mul $t2, $t2 ,4 #multiply the value stored in $t2 which is the input value for the grid times 4 into $t2
	
	
add $t0, $t1,$t2 #sum the values stored in the $t1,$t2 registers which is the first 2/3 section of the equation
	
lw $s0, cell #load the value of cell into the $t3 register, this is done instead of reusing the $t1 register just for convenience and keeping the values straightfoward
	
divu $t3, $s0,4
mfhi $t3 
	
add $t0, $t0,$t3 #add the first half of the equation which is in 10 with t3 the last third of the equation



   # li     $t0, 22
    
    
    
mul  $t0, $t0, 2        # Each offset is two-byte long.
lh   $t1, offset($t0)   # Load $t1 with the offset of the index $t0.

bne $t9,'.',invalidMoveO

li   $t2, 'O'           # Put the piece ‘O’ in $t2.
sb   $t2, board($t1)    # Put the piece at the location, board+offset.



#check if that byte has already been filled in



	


li 	$v0, 4		#system call code for printing string = 4.
la	$a0,board #load address of string to be printed into $a0
syscall	




# go back to o here 


li $v0,4
la $a0,continueGamePrompt 
syscall 




li $v0,12 	#take in the user input if they want to end the game
syscall


beq $v0,'n', endgame



li $v0,4
la $a0,newGamePrompt 
syscall 



li $v0,12 	#take in the user input if they want to end the game
syscall
beq $v0,'y', newGame



jal LoopX
	
	
		
newGame: #overrise the old game board with the new one
li $t0,0 #load immediadly into the t0 register the value 0
resetBoard: 
lb $t1, blankBoard($t0) #starting at the 0th byte of the blank board string 
sb $t1,board($t0)
add $t0, $t0,1
blt $t0, 256 resetBoard #until $t0 value is at 256 go up into the value
j main # go back to the top of the menu
	
	
	
	
endgame:	
li	$v0,10 #terminate program
syscall