    section .text
    global  change_string
change_string:
    push    ebp             ; save caller's frame pointer
    mov     ebp, esp

    mov     ecx, [ebp + 8]
    push    ebx

    xor     ebx, ebx


traverse: 
    mov     al, [ecx]
    test    al, al
    jz      finish
    inc     ebx
    cmp     ebx, 3
    je      change
    inc     ecx
    jmp     traverse
change:
    mov     byte [ecx], 'x'
    xor     ebx, ebx 
    inc     ecx
    jmp     traverse

finish:
    pop     ebx
    mov     eax, [ebp + 8]    ; return the original arg
    pop     ebp             ; restore caller's frame pointer
    ret   