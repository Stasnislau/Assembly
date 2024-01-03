    section .text
    global  change_string
change_string:
    push    ebp
    mov     ebp, esp

    push    ebx
    push    esi 
    mov     ecx, [ebp + 8]

    xor     esi, esi ; pointer to longest
    xor     ebx, ebx ; bh = longest
    xor     eax, eax ; ah = current length
    xor     edx, edx ; pointer to current

calculate_longest: 
    mov     al, [ecx]
    test    al, al
    jz      remove

    cmp     al, '0'
    jb      next_not_digit
    cmp     al, '9'
    ja      next_not_digit

    test    ah, ah
    jnz     update_current
    mov     edx, ecx

update_current:
    inc     ah
    cmp     ah, bh
    ja      update_longest

next:
    inc     ecx
    jmp     calculate_longest

next_not_digit:
    inc     ecx
    xor     ah, ah
    cmp     ah, bh
    jb      calculate_longest

update_longest: 
    mov     bh, ah
    mov     esi, edx
    jmp     next

remove:
    test    bh, bh
    jz      finish
    mov     ecx, esi
    test    bh, bh
    jz      finalise
    dec     bh

remove_loop:
    inc     ecx
    dec     bh
    test    bh, bh
    jnz     remove_loop


finalise: 
    mov     byte [ecx + 1], 0

finish: 
    mov     eax, esi
    pop     esi
    pop     ebx
    pop     ebp 
    ret