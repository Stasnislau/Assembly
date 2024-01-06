    section .text 
    global  emphasize8
emphasize8: ; 64-bit version

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
    add     esi, 1024 ; skip the first 1024 bytes of the image

find_traverse: 
    test  eax, eax ; if width == 0
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
    cmp   dh, bl 
    ja    set_white
    dec   eax 
    test  eax, eax
    jz    detect_end_of_row
    inc   esi 
    jmp   find_traverse
    

set_white:
    mov   bl, dh
    dec   eax 
    test  eax, eax 
    jz    detect_end_of_row
    inc   esi 
    jmp   find_traverse

detect_end_of_row:
    test  ecx, ecx 
    jz    finish_traverse
    mov   dh, 0
    dec   ecx 
    test  ecx, ecx 
    jz    finish_traverse
    add   esi, edx ; image pointer + offset to next row
    mov   eax, [ebp + 12] ; width
    jmp   find_traverse


finish_traverse:
    mov   esi, [ebp + 8] ; image pointer
    add   esi, 1024 ; skip the palette
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
    div   ebx
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