    section .text 
    global  emphasize8
emphasize8: ; 64-bit version
    push r11
    push r12
    push r13
    push r14
    push r15
    mov r10, rdi ; image pointer
    mov r11, rsi ; image width
    mov r12, rdx ; image height
    mov r13, rcx ; image stride
    sub r13, r11 ; stride - width, OFFSET to next row
    xor r14, r14 ; lightest shade, initially darkest possible
    xor r15, r15 ; darkest shade, initially lightest possible
    mov r14, 0
    mov r15, 255

find_traverse:
    test r11, r11 
    jz detect_end_of_row
    xor rax, rax
    mov al, [r10]
    cmp rax, r15
    jb set_black
    cmp rax, r14
    ja set_white
    inc r10
    dec r11
    jmp find_traverse

set_black:
    mov r15, rax
    jmp find_traverse

set_white:
    mov r14, rax
    jmp find_traverse

detect_end_of_row:
    test r12, r12
    jz finish_traverse
    xor rax, rax
    dec r12
    test r12, r12
    jz finish_traverse
    add r10, r13 ; image pointer + offset to next row
    mov r11, rsi
    jmp find_traverse

finish_traverse:
    mov r10, rdi ; image pointer
    mov r11, rsi ; image width
    mov r12, rdx ; image height

change_traverse:
    test r11, r11
    jz detect_end_of_row_change
    xor rax, rax
    mov al, [r10]
    sub rax, r15 ; al = pixel value - darkest shade
    mov rdx, 255
    mul rdx ; eax = (pixel value - darkest shade) * 255
    xor rdx, rdx
    mov r8, r14 ;
    sub r8, r15 ;
    div r8 ; eax = (pixel value - darkest shade) * 255 / (lightest shade - darkest shade)
    mov [r10], al
    inc r10
    dec r11
    jmp change_traverse


detect_end_of_row_change:
    test r12, r12
    jz return
    dec r12
    test r12, r12
    jz return
    add r10, r13 ; image pointer + offset to next row
    mov r11, rsi ; image width
    jmp change_traverse

return:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    mov    rax, rdi
    ret