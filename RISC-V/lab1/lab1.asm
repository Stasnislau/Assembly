	.eqv SYS_EXITO, 10
	.eqv SYS_PRINTSTR, 4
	.eqv SYS_READSTR, 8
    .eqv SYS_READCHAR, 12
        .eqv SYS_PRINTINT, 1
    .eqv READ_INT, 5
	.eqv MAXSIZE, 100
	.data
    # t0 we walk through the string
    # t1 we save the char 
    # t2 we save the N
    # t3 current counter to compare with N
    # t4 some random
    # t6 finish char 
    hello: .asciz "Welcome to the lab 1!\n"
    prompt1: .asciz "Please enter a string: "
    prompt2: .asciz "Please enter a character: "
    prompt3: .asciz "Please enter an integer: "
    result: .asciz "Result: "
    buf1: .space MAXSIZE
    buf2: .space MAXSIZE
    buf3: .space MAXSIZE
	.text
main:
	la a0, hello
	li a7, SYS_PRINTSTR
	ecall
	la a0, prompt1
	li a7, SYS_PRINTSTR
	ecall
    
	la a0, buf1 
	li a1, MAXSIZE
	li a7, SYS_READSTR
	ecall

    # read int begin 
    la a0, prompt3
    li a7, SYS_PRINTSTR
    ecall

    la a0, buf3
    li a1, MAXSIZE
    li a7, READ_INT
    ecall # read int end

        # read char end
    la a0, prompt2
    li a7, SYS_PRINTSTR
    ecall

    la a0, buf2
    li a1, MAXSIZE
    li a7, SYS_READCHAR
    ecall # read char end
    
    la t0, buf1
    la t1, buf2
    la t2, buf3
    li t6, ' '

traverse: 
    lbu t4, (t0)
    li t5, 0
    beq t2, t5, finish
    bltu t4, t6, finish
    beq t2, t3, replace
    addi t3 t3 1
    addi t0 t0 1
    b traverse

replace: 
    sb t0, (t1)
    addi t0 t0 1
    li t3, 0
    b traverse

finish:
	la a0, result
    li a7, SYS_PRINTSTR
    ecall 
    la a0, buf1
    li a7, SYS_PRINTSTR
    ecall 
