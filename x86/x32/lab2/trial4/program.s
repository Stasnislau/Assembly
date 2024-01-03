    section .text
    global  change_string
change_string:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ecx, [ebp + 8]
    xor     edx, edx

traverse:
    mov     ebx, ecx
    mov     al, [ecx]
    test    al, al
    jz      finish
    cmp     al, '0'
    jl      next 
    cmp     al, '9'
    jg      next
    mov     dl, [ecx + 1]
    cmp     dl, '9'
    jbe     put_char
    mov     dl,  [ebp + 12]
    mov     byte [ecx], dl
    jmp     next

shift_left:
    mov     dl, [ebx + 1]
    mov     byte [ebx], dl
    mov     al, [ebx]
    test    al, al
    jz      traverse
    inc     ebx
    jmp     shift_left

put_char:
    cmp     dl,  '0'
    jae     shift_left
    mov     dl,  [ebp + 12]
    mov     byte [ecx], dl

next: 
    inc     ecx
    jmp     traverse


finish: 
    mov     eax, [ebp + 8]
    pop     ebx
    pop     ebp 
    ret