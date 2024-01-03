    section .text 
    global  change_string
change_string: ; we recieve a string and a number, need put all the numbers to this sctring as chars
    push    ebp
    mov     ebp, esp

    push    ebx ; stores pointer to string
    push    esi ; stores the sign

    xor     esi, esi

    mov     ebx, [ebp + 8]
    
    mov     eax, [ebp + 12]

    test    eax, eax
    js      negative

convert_loop:
    xor edx, edx
    mov ecx, 10 
    div ecx               
    add     edx, '0' 
    mov     byte [ebx], dl
    inc     ebx
    test    eax, eax
    jnz     convert_loop

    mov   byte [ebx], 0
    mov   ecx, [ebp + 8]
    test  ecx, ecx
    jz    return
    dec   ebx

reverse_string:
    cmp  ecx, ebx
    jb   swap

swap: 
    mov  al, [ecx]
    mov  dl, [ebx]
    mov  byte [ecx], dl
    mov  byte [ebx], al
    inc  ecx
    dec  ebx
    cmp  ecx, ebx
    jbe  swap

    test esi, esi
    jnz  add_minus

return:
    mov    eax, [ebp + 8]
    pop    esi
    pop    ebx
    pop    ebp  
    ret

negative:
    mov     esi, 1
    jmp     convert_loop

add_minus: 
    mov     ebx, [ebp + 8]
    mov     esi, [ebx]
    mov     byte [ebx], '-'

go_to_end:
    inc     ebx
    test    ebx, ebx
    jnz     go_to_end
    dec     ebx
    mov     al, [ebx]
    mov     byte [ebx + 1], al
    mov     byte [ebx], 0

shift_right: 
    mov  al, [ebx-1]
    cmp  al, '-'
    je   add_remaining_number
    mov  byte [ebx], al
    mov  byte [ebx-1], 0
    dec  ebx
    
add_remaining_number:
    mov     al, [esi]
    mov     byte [ebx], al
    jmp     return

