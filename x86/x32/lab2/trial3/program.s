    section .text
    global  change_string
change_string:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ecx, [ebp + 8]

traverse: 
    mov     ebx, ecx
    mov     al, [ecx]
    test    al, al   
    jz      finish
    cmp     al, [ebp + 12]
    jb      next
    cmp     al, [ebp + 16]
    ja      next

shift_left:
    mov     dl, [ebx + 1]
    mov     byte [ebx], dl
    mov     al, [ebx]
    test    al, al
    jz      traverse
    inc     ebx
    jmp     shift_left

next: 
    inc     ecx
    jmp     traverse

finish: 
    mov     eax, [ebp + 8]
    pop     ebx
    pop     ebp 
    ret