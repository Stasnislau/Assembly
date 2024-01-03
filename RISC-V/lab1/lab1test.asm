	.eqv SYS_EXITO, 10
	.eqv SYS_PRINTSTR, 4
	.eqv SYS_READSTR, 8
	.eqv MAXSIZE, 100
	.data

    hello: .asciz "Welcome to the lab 1!\n"
    prompt: .asciz "Please enter a string: "
    result: .asciz "String after: "
    buf: .space MAXSIZE
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
	la t0, buf
	mv t1, t0
	li t2, '0' #reference to the end of the string
	
# searchEnd:
	# lbu t3, (t0)
	# addi t0, t0, 1
	# bgeu t3, t2, search_end
	# addi t0, t0, - 2
	# we don't need to search for the end of the string, because we know that the last character is space
	
traverse:
	lbu t3, (t0)
	bgeu t3, t2, secondCondition
	addi t0, t0, 1
	bleu t3, t2, finish
    b traverse

secondCondition:
	li t1, '9'
	bleu t3, t1, replaceDigit
    addi t0, t0, 1
    b traverse

replaceDigit:
	addi t3, t3, -48
	li t1, 9
	sub t3, t1, t3
	addi t3, t3, 48
	sb t3, (t0)
    addi t0, t0, 1
    b traverse
finish:
	la a0, result
    li a7, SYS_PRINTSTR
    ecall 
    la a0, buf
    li a7, SYS_PRINTSTR
    ecall 
