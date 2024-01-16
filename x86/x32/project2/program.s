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
    mov   dh, [esi] ; load pixel value
    cmp   dh, bh 
    jae   skip_to_white
    mov   bh, dh
    
skip_to_white:
    cmp   dh, bl
    jbe   skip
    mov   bl, dh

skip: 
    inc   esi 
    dec   eax
    jnz   find_traverse

detect_end_of_row:
    xor   dh, dh
    add   esi, edx ; image pointer + offset to next row
    mov   eax, [ebp + 12] ; width
    dec   ecx
    jnz   find_traverse


finish_traverse:
    mov   esi, [ebp + 8] ; image pointer
    mov   edi, [ebp + 12] ; image width
    mov   ecx, [ebp + 16] ; image height


change_traverse: 
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
    jnz   change_traverse


detect_end_of_row_change:
    mov   edx, [ebp + 20] ; stride
    mov   edi, [ebp + 12] ; width
    sub   edx, edi ; stride - width, offset to next row
    add   esi, edx ; image pointer + offset to next row
    dec   ecx 
    jnz   change_traverse

return:
    mov    eax, [ebp + 8]
    pop    edi
    pop    esi
    pop    ebx
    pop    ebp  
    ret