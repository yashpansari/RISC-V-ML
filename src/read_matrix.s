.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
error1:
    li a0 27
    j exit
error2:
	li a0 29
    j exit
error3:
	li a0 26
    j exit
error4:
	li a0 28
    j exit
read_matrix:

	# Prologue
    addi sp sp -40
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp) #four
    sw s7 28(sp)
    sw s8 32(sp)
    sw ra 36(sp)
    
    mv s0 a0
    mv s1 a1
    mv a1 x0
    mv s2 a2
    
    addi s6 x0 4
    
    jal ra fopen
    
    addi s8 x0 -1
    beq s8 a0 error1
    
    mv s3 a0
    
    mv a1 s1
    add a2 x0 s6
    jal ra fread
    add a2 x0 s6
    bne a0 a2 error2
    
    mv a0 s3
    mv a1 s2
    jal ra fread
    bne a0 s6 error2
    
    lw s7 0(s1) #r
    lw s8 0(s2) #c
    
    mul s5 s7 s8 #totalentries
    mul a0 s5 s6
    jal ra malloc
    beq a0 x0 error3
    
	mv s4 a0
    mv a1 a0
    mv a0 s3
    mul a2 s5 s6
	jal ra fread
    mul a2 s5 s6
    bne a0 a2 error2
    
    mv a0 s3
    jal ra fclose
    bne a0 x0 error4
    
    mv a0 s4

	# Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp) #four
    lw s7 28(sp)
    lw s8 32(sp)
    lw ra 36(sp)
    addi sp sp 40


	ret
