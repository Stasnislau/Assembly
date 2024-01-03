	.eqv SYS_EXITO, 10
	.eqv SYS_PRINTSTR, 4
	.eqv SYS_READSTR, 8
    .eqv SYS_PRINTINT, 1
	.eqv MAXSIZE, 100
	.data

    hello: .asciz "Welcome to the lab 1!\n"
    prompt: .asciz "Please enter a string: "
    result: .asciz "Longest sequence: "
    buf: .space MAXSIZE
    longestString: .space MAXSIZE
	.text
main:
	la a0, hello
	li a7, SYS_PRINTSTR
	ecall
	la a0, prompt
	li a7, SYS_PRINTSTR
	ecall
	la a0, buf
	li a1, MAXSIZE
	li a7, SYS_READSTR
	ecall

	la t0, buf # current string pointer
	li t2, ' ' #reference to the end character
    la t1, longestString # longest string pointer
    li t3, 0 # current length
    li t4, 0 # longest length
    li t6, 0 # pointer to the beginning of the longest string

traverse:
    mv a0, t2
    li a7, SYS_PRINTINT
    ecall 
    bltu t0, t2, preFinish
    lb a0, (t0)
    li a7, SYS_PRINTINT
    ecall 
    li t5, '9'
    bgeu t0, t5, secondCondition
    bleu t0, t2 updateNotDigit
    b traverse

secondCondition:
	li t5, 57
    bleu t5, t0, updateNotDigit
    addi t3, t3, 1
	bleu t3, t1, change
    addi t0, t0, 1
    b traverse

updateNotDigit:
    bleu t4, t3, change
    mv t4, t3
    mv t1, t0
    addi t0, t0, 1
    b traverse



change:
    bleu t4, t3, changeLongest
    li t3, 0
    addi t0, t0, 1
    b traverse



changeLongest:
    mv t4, t3
    li t3, 0
    mv t6, t0 
    sub t6, t6, t4
    addi t0, t0, 1
    b traverse



preFinish:
    li t5, 0
    bleu t4, t5, finish
    addi t6, t6, 1
    addi t4, t4, -1
    b finish

finish:
	la a0, result
    li a7, SYS_PRINTSTR
    ecall 
    la a0, longestString
    li a7, SYS_PRINTSTR
    ecall 
