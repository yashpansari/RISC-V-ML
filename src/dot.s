.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
	bge x0 a2 done1
    bge x0 a3 done2
    bge x0 a4 done2
	# Prologue
    slli a3 a3 2
    slli a4 a4 2
    addi a5 x0 0
    j loop_start
    
done1:
	li a0 36
    j exit

done2:
	li a0 37
    j exit

loop_start:
	beq a2 x0 loop_end
    lw t0 0(a0)
    lw t1 0(a1)
    
    mul t2 t0 t1
    add a5 a5 t2
    
    add a0 a0 a3
    add a1 a1 a4
    addi a2 a2 -1
    j loop_start

loop_end:
	add a0 a5 x0
	# Epilogue
	ret
