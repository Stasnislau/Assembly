    section .text 
    global  emphasize8
emphasize8: ; 32-bit version

    push    ebp
    mov     ebp, esp
    push    ebx 
    push    esi  
    push    edi

    mov     esi, [ebp + 8] ; image pointer 
    mov     eax, [ebp + 12] ; image width
    mov     ecx, [ebp + 16] ; image height
    mov     edx, [ebp + 20] ; image stride | offset to the next row
    sub     edx, eax ; stride - width, offset to next row
    xor     ebx, ebx ; upper part is darkest, lower part is lightest
    mov     bh, 0xff ; darkest shade, initially lightest possible
    mov     bl, 0x00 ; lightest shade, initially darkest possible

find_traverse: 
    test  eax, eax 
    jz    detect_end_of_row
    mov   dh, [esi] ; load pixel value
    cmp   dh, bh 
    jb    set_black
    cmp   dh, bl
    ja    set_white
    inc   esi 
    dec   eax 
    jmp   find_traverse


set_black:
    mov   bh, dh 
    jmp   find_traverse
    

set_white:
    mov   bl, dh
    jmp   find_traverse

detect_end_of_row:
    test  ecx, ecx 
    jz    finish_traverse
    xor   dh, dh
    dec   ecx 
    test  ecx, ecx 
    jz    finish_traverse
    add   esi, edx ; image pointer + offset to next row
    mov   eax, [ebp + 12] ; width
    jmp   find_traverse


finish_traverse:
    mov   esi, [ebp + 8] ; image pointer
    mov   edi, [ebp + 12] ; image width
    mov   ecx, [ebp + 16] ; image height


change_traverse: 
    test  edi, edi 
    jz    detect_end_of_row_change
    xor   eax, eax
    mov   al, [esi] 
    sub   al, bh ; al = pixel value - darkest shade
    mov   edx, 255 ; edx = 255
    mul   edx ; eax = (pixel value - darkest shade) * 255
    xor   edx, edx
    mov   dl, bl 
    sub   dl, bh 
    push  ebx  
    mov   ebx, edx  
    xor   edx, edx
    div   ebx ; eax = (pixel value - darkest shade) * 255 / (lightest shade - darkest shade)
    pop   ebx 
    mov   [esi], al 
    inc   esi  
    dec   edi 
    jmp   change_traverse


detect_end_of_row_change:
    test  ecx, ecx 
    jz    return
    dec   ecx 
    test  ecx, ecx 
    jz    return
    mov   edx, [ebp + 20] ; stride
    mov   edi, [ebp + 12] ; width
    sub   edx, edi ; stride - width, offset to next row
    add   esi, edx ; image pointer + offset to next row
    jmp   change_traverse

return:
    mov    eax, [ebp + 8]
    pop    edi
    pop    esi
    pop    ebx
    pop    ebp  
    ret