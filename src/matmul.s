.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

	# Error checks
    bge x0 a1 done1
    bge x0 a2 done1
    bge x0 a4 done1
    bge x0 a5 done1
    
	# Prologue
    j save
    
save:
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw ra 44(sp)
    j set

set:
    add s0 x0 a0
    add s1 x0 a1
    add s2 x0 a2
    add s3 x0 a3
    add s4 x0 a4
    add s5 x0 a5
    add s9 x0 a5
    add s6 x0 a6
    add s7 x0 x0
    addi s10 x0 4
    j start
    
start:
    beq a2 a4 outer_loop_start
    j done1
    
done1:
    li a0 38
    j exit

outer_loop_start:
    beq s7 s1 outer_loop_end
    addi s8 x0 -1

inner_loop_start:
    addi s8 s8 1
    beq s8 s9 inner_loop_end
    
    mul t0 s10 s8
    add t0 t0 s3
    addi a1 t0 0
    
    mul t1 s10 s2
    mul t1 t1 s7
    add t1 t1 s0
    addi a0 t1 0
    
    addi a2 s2 0
    addi a3 x0 1
    addi a4 s5 0
    jal ra dot
    
    mul t0 s10 s5
    mul t0 t0 s7
    add t0 t0 s6
    mul t1 s10 s8
    add t0 t0 t1
    sw a0 0(t0)
    j inner_loop_start

inner_loop_end:
    addi s7 s7 1
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
    
    addi sp, sp, 48
    
    ret