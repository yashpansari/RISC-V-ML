.import ../src/utils.s
.import ../src/../coverage-src/zero_one_loss.s

.data
m0: .word -1 0 1
m1: .word 1 0 -1
m2: .word -1 -1 -1
m3: .word 0 1 0
msg0: .asciiz "expected m2 to be:\n0 1 0\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 3 into a2
    li a2 3

    # load address to array m2 into a3
    la a3 m2

    # call zero_one_loss function
    jal ra zero_one_loss

    ##################################
    # check that m2 == [0, 1, 0]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m3
    # a2: actual data
    la a2, m2
    # a3: length
    li a3, 3
    # a4: error message
    la a4, msg0
    jal compare_int_array

    # exit normally
    li a0 0
    jal exit
