.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
error1:
    li a0 27
    j exit
error2:
	li a0 30
    j exit
error3:
	li a0 28
    j exit

write_matrix:

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
    
    addi s6 x0 4
    
    #mv s0 a0 #filename lowkey useless after fopen tho
    mv s0 a1 #p
    mv s1 a2 #r
    mv s2 a3 #c
    
    addi a1 x0 1
    jal ra fopen
    addi a1 x0 -1
    beq a0 a1 error1
    
    mv s3 a0 #d
    
    addi sp sp -8
    sw s1 0(sp)
    sw s2 4(sp)
    mv a1 sp
    addi sp sp 8
    mv a3 s6
    addi a2 x0 2
    jal ra fwrite
    addi t0 x0 2
    bne a0 t0 error2
    
    mv a0 s3
    mul a2 s1 s2
    mv a3 s6
    mv a1 s0
    jal ra fwrite
    mul a2 s1 s2
    bne a0 a2 error2
    
    mv a0 s3
    jal ra fclose
    bne a0 x0 error3
    
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
