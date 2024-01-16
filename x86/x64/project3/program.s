section .text 
global  emphasize8

emphasize8: ; 64-bit version
    push r11
    push r12 
    push r13
    push r14
    push r15
    mov r10, rdi ; image pointer
    mov r11, rsi ; image width, saved as argument
    mov r12d, edx ; image height, saved as argument
    mov r13d, ecx ; image stride, saved as argument

    mov     eax, r11d ; image width
    mov     ecx, r12d ; image height
    mov     edx, r13d ; image stride
    sub     edx, eax ; stride - width, offset to next row
    xor     bx, bx ;  upper part is darkest, lower part is lightest
    mov     bh, 0xff ; darkest shade, initially lightest possible
    mov     bl, 0x00 ; lightest shade, initially darkest possible
    xor     r9, r9
    movzx   r9d, dl ; image stride

find_traverse: 
    mov   dl, [r10] ; load pixel value
    cmp   dl, bh 
    jae   skip_to_white
    mov   bh, dh

skip_to_white:
    cmp   dl, bl
    jbe   skip
    mov   bl, dl

skip: 
    inc   r10
    dec   eax
    jnz   find_traverse

detect_end_of_row:
    xor   dl, dl
    add   r10, r9 ; image pointer + offset to next row
    mov   eax, r11d ; image width
    dec   ecx
    jnz   find_traverse


finish_traverse:
    mov   r10, rdi ; image pointer
    mov   r14d, r11d ; image width
    mov   ecx, r12d ; image height


change_traverse: 
    xor   eax, eax
    mov   al, [r10] 
    sub   al, bh ; al = pixel value - darkest shade
    mov   edx, 255 ; edx = 255
    mul   edx ; eax = (pixel value - darkest shade) * 255
    xor   edx, edx
    mov   dl, bl
    sub   dl, bh 
    mov   r15d, edx ; r15d = lightest shade - darkest shade
    xor   edx, edx
    div   r15d ; eax = (pixel value - darkest shade) * 255 / (lightest shade - darkest shade) 
    mov   [r10], al ; store new pixel value
    inc   r10
    dec   r14d 
    jnz   change_traverse


detect_end_of_row_change:
    mov   r14d, r11d ; width
    add   r10, r9 ; image pointer + offset to next row
    dec   ecx 
    jnz   change_traverse

return:
    mov rax, rdi
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    ret