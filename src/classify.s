.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
error2:
    li a0 26
    j exit
error1:
    li a0 31
    j exit
classify:

	# error case
    li t0 5
    bne t0 a0 error1
    
    # Prologue
    addi sp sp -48
    sw s0 0(sp)  #dimensions
    sw s1 4(sp)  #a1
    sw s2 8(sp)  #silent
    sw s3 12(sp) #m0
    sw s4 16(sp) #m1
    sw s5 20(sp) #input
    sw s6 24(sp) #four
    sw s7 28(sp) #no of elements of h
    sw s8 32(sp) #ptr to h
    sw ra 36(sp)
    sw s9 40(sp) #no of elements of o
    sw s10 44(sp) #ptr to o
    addi s6 x0 4
    mv s0 a0
    mv s1 a1
    mv s2 a2
    
    addi a0 x0 24
    call malloc
    beq a0 x0 error2
    mv s0 a0
    
	# Read pretrained m0
    lw a0 4(s1)
    addi a1 s0 0 #rm0
    add a2 a1 s6 #cm0
    call read_matrix
    mv s3 a0

	# Read pretrained m1
    lw a0 8(s1)
    addi a1 s0 8 #rm1
    add a2 a1 s6 #cm1
    call read_matrix
    mv s4 a0

	# Read input matrix
    lw a0 12(s1)
    addi a1 s0 16 #rinp
    add a2 a1 s6 #cinp
    call read_matrix
    mv s5 a0

	# Compute h = matmul(m0, input)
    # rm0 x cinp
   
    lw a0 0(s0)
    lw t0 20(s0)
    mul a0 a0 t0
    mv s7 a0
    mul a0 a0 s6
    call malloc
    beq a0 x0 error2
    mv s8 a0
    
    mv a0 s3
    lw a1 0(s0)
    lw a2 4(s0)
    lw a4 16(s0)
    lw a5 20(s0)
    mv a3 s5
    mv a6 s8
    call matmul

	# Compute h = relu(h)
    mv a0 s8
    mv a1 s7
    call relu

	# Compute o = matmul(m1, h)
    # rm1 x cinp
    
    lw a0 8(s0)
    lw t0 20(s0)
    mul a0 a0 t0
    mv s9 a0
    mul a0 a0 s6
    call malloc
    beq a0 x0 error2
    mv s10 a0
    
    mv a0 s4
    lw a1 8(s0)
    lw a2 12(s0)
    lw a4 0(s0)
    lw a5 20(s0)
    mv a3 s8
    mv a6 s10
    call matmul
    
	# Write output matrix o
    
    lw a0 16(s1)
    mv a1 s10
    lw a2 8(s0)
    lw a3 20(s0)
    call write_matrix

	# Compute and return argmax(o)
    mv a0 s10
    mv a1 s9
    call argmax
    
	# If enabled, print argmax(o) and newline
    beq x0 s2 loud
    mv s9 a0
    j done
    
loud:
	mv s9 a0
	jal ra print_int
    li a0 '\n'
    jal ra print_char
    mv a0 s9
    j done
    
done:
    mv a0 s0
    call free
    mv a0 s3
    call free
    mv a0 s4
    call free
    mv a0 s5
    call free
    mv a0 s8
    call free
    mv a0 s10
    call free
    mv a0 s9
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
    lw s9 40(sp)
    lw s10 44(sp)
    addi sp sp 48

	ret
