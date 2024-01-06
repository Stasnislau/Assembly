    section .text 
    global  emphasize8
emphasize8: ; 64-bit version
    mov r10, rdi ; image pointer
    mov r11, rsi ; image width
    mov r12, rdx ; image height
    mov r13, rcx ; image stride
    sub r13, r11 ; stride - width, OFFSET to next row
    xor r14, r14 ; lightest shade, initially darkest possible
    xor r15, r15 ; darkest shade, initially lightest possible
    mov r14, 0
    mov r15, 255
    add r10, 1024 ; skip the first 1024 bytes of the image

find_traverse:
    test r11, r11 ; if width == 0
    jz detect_end_of_row
    xor rax, rax
    mov al, [r10] ; load pixel value
    cmp rax, r15
    jb set_black
    cmp rax, r14
    ja set_white
    inc r10
    dec r11
    jmp find_traverse

set_black:
    mov r15, rax
    cmp rax, r14 
    ja set_white
    dec r11
    test r11, r11
    jz detect_end_of_row
    inc r10
    jmp find_traverse

set_white:
    mov r14, rax
    dec r11
    test r11, r11
    jz detect_end_of_row
    inc r10
    jmp find_traverse

detect_end_of_row:
    test r12, r12
    jz finish_traverse
    xor rax, rax
    dec r12
    test r12, r12
    jz finish_traverse
    add r10, r13 ; image pointer + offset to next row
    mov r11, rsi ; image width
    jmp find_traverse

finish_traverse:
    mov r10, rdi ; image pointer
    add r10, 1024 ; skip the palette
    mov r11, rsi ; image width
    mov r12, rdx ; image height

change_traverse:
    test r11, r11
    jz detect_end_of_row_change
    xor rax, rax
    mov al, [r10]
    sub rax, r15 ; al = pixel value - darkest shade
    mov rdx, 255 ; edx = 255
    mul rdx ; eax = (pixel value - darkest shade) * 255
    xor rdx, rdx
    mov r8, r14 ; r8 = lightest shade
    sub r8, r15 ; r8 = lightest shade - darkest shade
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


; detect_end_of_row_change:
;     test  ecx, ecx 
;     jz    return
;     dec   ecx 
;     test  ecx, ecx 
;     jz    return
;     mov   edx, [ebp + 20] ; stride
;     mov   edi, [ebp + 12] ; width
;     sub   edx, edi ; stride - width, offset to next row
;     add   esi, edx ; image pointer + offset to next row
;     jmp   change_traverse

return:
    mov    rax, rdi
    ret