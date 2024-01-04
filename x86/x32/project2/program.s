    section .text 
    global  emphasize8
emphasize8: ; Enhance the dynamic range of 8 bpp grayscale image so that the darkest shade becomes black and the lightest – white. Change the intermediate shades proportionally.

    push    ebp
    push    ebx 
    push    esi  
    push    edi

    mov     esi, [ebp + 8] ; image pointer 
    mov     eax, [ebp + 12] ; image width
    mov     ecx, [ebp + 16] ; image height
    mov     edx, [ebp + 20] ; image stride | offset to next row
    sub     edx, eax ; stride - width, offset to next row
    xor     ebx, ebx ; upper part is darkest, lower part is lightest
    mov     bl, 0x00 ; darkest shade
    mov     bh, 0xFF ; lightest shade

find_traverse: 
    test  eax, eax ; if width == 0
    jz    detect_end_of_row
    mov   dh, [esi] ; load pixel value
    cmp   dh, bl 
    ja    set_black
    cmp   dh, bh
    jb    set_white
    inc   esi ; advance to next pixel
    dec   eax ; width--
    jmp   find_traverse


set_black:
    mov   bh, dh ; lightest shade = pixel value
    cmp   bl, dh 
    jb    set_white
    inc   esi ; advance to next pixel
    dec   eax ; width--
    jmp   find_traverse
    

set_white:
    mov   bl, dh
    inc   esi ; advance to next pixel
    dec   eax ; width--
    jmp   find_traverse

detect_end_of_row:
    test  ecx, ecx ; if height == 0
    jz    finish_traverse
    mov   dh, 0
    add   esi, edx ; image pointer + offset to next row
    dec   ecx ; height--
    mov   eax, [ebp + 12] ; width
    jmp   find_traverse


finish_traverse:
    mov     esi, [ebp + 8] ; image pointer 
    mov     eax, [ebp + 12] ; image width
    mov     ecx, [ebp + 16] ; image height


return:
    mov    eax, [ebp + 20]
    pop    edi
    pop    esi
    pop    ebx
    pop    ebp  
    ret

