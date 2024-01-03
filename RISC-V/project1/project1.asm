	.eqv SYS_OPEN_FILE, 1024
   	.eqv SYS_PRINT_STR, 4
   	.eqv SYS_PRINT_INT, 1
   	.eqv SYS_READ_FILE, 63
   	.eqv SYS_WRITE_TO_FILE, 64
   	.eqv SYS_CLOSE_FILE 57
   	.eqv SYS_EXIT, 93
	.data
image: .space 786486
trash_buffer: .space 4 # reading empty bytes and for writing into the file
header: .space 54 
file_name: .asciz "test512.bmp" 
error_text: .asciz "Failed to load the file"
space: .asciz "\n"     
         .text 	
     # s0 - file descriptor
     # s4 - width of the picture
     # s5 - heigh of the picture 
     # s6 - file size
     # s11 - file stride
main:

    li a7, SYS_OPEN_FILE  
    la a0, file_name
    li a1, 0                                         
    ecall
    mv s0, a0                           # Save file descriptor

    li t0, -1                           
    beq s0, t0, exit_with_error                    
    
    
    la t0, header
    li a7, SYS_READ_FILE 
    mv a0, s0       # File descriptor
    mv a1, t0       # Buffer for header
    li a2, 54       # Size of BMP header
    ecall
    
    li t0, -1                           
    beq a0, t0, exit_with_error 
    
    # getting the size of the file
    la t0, header      
    addi t0, t0, 2
    lbu t1, (t0)      
    lbu t2, 1(t0)     
    lbu t3, 2(t0)      
    lbu t4, 3(t0)      
    slli t2, t2, 8     
    slli t3, t3, 16    
    slli t4, t4, 24    
    or t1, t1, t2      
    or t1, t1, t3      
    or t1, t1, t4     
    mv s6, t1          
    


    # Load width from header
    la t0, header
    addi t0, t0, 18   
    lbu t1, 0(t0)      
    lbu t2, 1(t0)      
    lbu t3, 2(t0)      
    lbu t4, 3(t0)      
    slli t2, t2, 8     
    slli t3, t3, 16    
    slli t4, t4, 24    
    or t1, t1, t2      
    or t1, t1, t3     
    or t1, t1, t4      
    mv s4, t1 
           
    # load height
    la t0, header
    addi t0, t0, 22    
    lbu t1, 0(t0)      
    lbu t2, 1(t0)      
    lbu t3, 2(t0)      
    lbu t4, 3(t0)      
    slli t2, t2, 8     
    slli t3, t3, 16    
    slli t4, t4, 24    
    or t1, t1, t2      
    or t1, t1, t3      
    or t1, t1, t4      
    mv s5, t1          
    
    
    li t0, -1                           
    beq a0, t0, exit_with_error   

    # Calculate stride in s11
    mv s11, s4
    li t0, 24
    mul s11, s11, t0
    addi s11, s11, 31

    srai s11, s11, 5
    slli s11, s11, 2                   
    
    
    la t6, image
    mv t1, s11
    mul t1, t1, s5
    
    mv t4, s4
    slli t4, t4, 1
    add  t4, t4, s4
    
     # t0, - image
     # t1  - trash buffer
     # t2  - size of the align
     # s4  - width 
     # s5  - height 
     # t3  - current row
     # t4  - width without align in bytes
     # t5  - current read width in bytes left for a row
     # t6  - for checking if read correctly
     # s8  - length of a row if every pixel is 4 bytes | initial space at the beginning, so that the picture is not upside down
     # s9  - zero for adding as 4th byte
     
     li t6, -1
     li s9, 0
     mv t2, s11
     sub t2, t2, t4
     mv s8, s5
     addi s8,s8, -1
     mul s8, s8, s4
     slli s8, s8, 2
     la t0, image
     add t0, t0, s8
     mv t1, s5
     addi t1,t1, -1
     divu s8, s8, t1
     slli s8, s8, 1
    
     la t1, trash_buffer
     
accept_and_delete_align_loop: 
     beq t3, s5, exit_first_loop
     mv t5, t4
inner_loop: 
     li a7, SYS_READ_FILE 
     mv a0, s0       # File descriptor
     mv a1, t0       # Buffer for image
     li a2, 3       # 3 bytes of pixel colors
     ecall                          
     beq a0, t6, exit_with_error 
     
     addi t0, t0, 3
     sb s9, (t0)
     addi t0, t0, 1
     addi t5, t5, -3
     bnez t5, inner_loop
     
     sub t0, t0, s8
     addi t3, t3, 1
     
     beqz t2, accept_and_delete_align_loop
     
     li a7, SYS_READ_FILE 
     mv a0, s0       # File descriptor
     mv a1, t1       # Buffer for trash
     mv a2, t2       # Size of the align
     ecall                         
     beq a0, t6, exit_with_error
     
     
     b accept_and_delete_align_loop

exit_first_loop: 

    # t0 - image buffer
    # t1 - right boundary 
    # t2 - bottom boundary
    # t3 - left boundary
    # t4 - upper boundary
    # t5 - general purpose
    # t6 - constant to turn into (0)
    # s4 - width
    # s5 - height
    # s6 - number of bytes left to cover
    # s7 - current coordinate x
    # s8 - current coordinate y
    # s9 - direction 0 - right, 1 down, 2 - left, 3 - up
    # s10 - width in bytes
    
    mul s6, s5, s4
    slli s6, s6, 2
    la t0, image
    mv t1, s4
    mv t2, s5
    addi t1, t1, -1
    addi t2, t2, -1
    li t3, 0
    li t4, 1 # since it is gonna be the first one covered
    li t6, 0
    li s7, 0
    li s8, 0
    li s9, 0
    
    sb  t6, 0(t0)
    sb  t6, 1(t0)
    sb  t6, 2(t0)
    addi s6, s6, -4
    mv s10, s4
    slli s10,s10, 2
    
erasing_loop:
    beqz s6, finish
     
    li  t5, 0 
    beq s9, t5 check_down
    li  t5, 1 
    beq s9, t5 check_left
    li  t5, 2
    beq s9, t5 check_up
    li  t5, 3
    beq s9, t5 check_right   
    b finish


check_down:
    beq s7, t1, go_down
    
make_move_right:
    addi t0, t0, 4
    sb  t6, 0(t0)
    sb  t6, 1(t0)
    sb  t6, 2(t0)
    addi s7, s7, 1
    addi s6, s6, -4
    b erasing_loop
   
go_down:
    li s9, 1
    b erasing_loop
    
check_left: 
    beq s8, t2, go_left
    
make_move_down:
      
    add t0, t0, s10
    sb  t6, 0(t0)
    sb  t6, 1(t0)
    sb  t6, 2(t0)
    addi s8, s8, 1
    addi s6, s6, -4
    b erasing_loop

go_left:
    li s9, 2
    b erasing_loop


check_up: 
    beq s7, t3, go_up

make_move_left:
    addi t0, t0, -4
    sb  t6, 0(t0)
    sb  t6, 1(t0)
    sb  t6, 2(t0)
    addi s7, s7, -1
    addi s6, s6, -4
    b erasing_loop

go_up:
    li s9, 3
    b erasing_loop

check_right:
    beq s8, t4, go_right

make_move_up:
    sub t0, t0, s10
    sb  t6, 0(t0)
    sb  t6, 1(t0)
    sb  t6, 2(t0)
    addi s8, s8, -1
    addi s6, s6, -4
    b erasing_loop

go_right:
    addi t1,t1, -1
    addi t2, t2, -1
    addi t3, t3, 1
    addi t4, t4, 1
    li s9, 0
    b erasing_loop
                               		
finish: 

    
    #saving the file, optional
    #t0 - pointer to header/ trash buffer
    #t1 - number of operations left
    #t2 - for error handling
    #t6 - zero for putting into files
    #s0 - file descriptor
    #s5 - file height
    #s11 - stride as before
    
    
    
    #IF YOU WANT TO ACTUALLY ERASE THE PICTURE AND SAVE IT ERASED, UNCOMMENT EFERYTHING MARKED BELOW
    #-----------------------------------------------------------------------------------
    
    #la t0, header
    #mv a0, s0
    #li a7, SYS_CLOSE_FILE
    #ecall 
    
    #li a7, SYS_OPEN_FILE  
    #la a0, file_name
    #li a1, 1                                         
    #ecall
    
    #mv s0, a0                           # Save file descriptor
    #li t2, -1                           
    #beq s0, t0, exit_with_error
                        
   
    #la t0, header
    #li a7, SYS_WRITE_TO_FILE
    #mv a0, s0       # File descriptor
    #mv a1, t0       # Buffer for header
    #li a2, 54       # Size of BMP header
    #ecall
                               
    #beq a0, t6, exit_with_error
    
    #la t0, trash_buffer
    #mv t1, s11
    #mul t1, t1, s5
    #srli t1, t1, 2
    
    #sb t6, 0(t0)
    #sb t6, 1(t0)
    #sb t6, 2(t0)
    #sb t6, 3(t0)
    
write_file_loop:
     
    #beqz t1, exit
   
    #li a7, SYS_WRITE_TO_FILE
    #mv a0, s0       # File descriptor
    #mv a1, t0       # Buffer with 4 0 bytes
    #li a2, 4        # Size of 4 bytes
    #ecall                   
           
    #beq a0, t6, exit_with_error
    #addi t1, t1, -1
    #b write_file_loop
    #-------------------------------------------------------------------------------------
exit: 
    mv a0, s0
    li a7, SYS_CLOSE_FILE
    ecall  
        
    li a0, 0                             
    li a7, SYS_EXIT                      
    ecall                                                               
    
exit_with_error:
    la a0, error_text
    li a7, SYS_PRINT_STR
    ecall 
    
    mv a0, s0
    li a7, SYS_CLOSE_FILE
    ecall 
    
    li a0, 1
    li a7, SYS_EXIT
    ecall
