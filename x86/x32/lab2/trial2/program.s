    section .text 
    global  change_string
change_string: 
    push    ebp
    mov     ebp, esp

    mov     ecx, [ebp + 8]
    push    ebx ; stores the sign

    xor     ebx, ebx
    xor     eax, eax ; stores value to return
    xor     edx, edx ; stores the character

ordinary_traverse: 
    mov     dl, [ecx]
    test    dl, dl
    jz      finish
    cmp     dl, '-'
    je      consider_minus
    cmp     dl, '9'
    jbe     detect_digit
    inc     ecx
    jmp     ordinary_traverse

consider_minus: 
    mov     ebx, 1
    inc     ecx
    jmp    ordinary_traverse

detect_digit:
    inc   ecx
    cmp   dl, '0'
    jb   ordinary_traverse
    sub  edx , '0'
    mov eax, edx

traverse_digits:
    mov     dl, [ecx]
    test    dl, dl
    jz      finish
    cmp     dl, '9'
    ja      finish
    cmp     dl, '0'
    jb      finish
    inc     ecx
    sub     edx, '0'
    imul    eax, 10
    add     eax, edx ; segmantation fault here
    jmp     traverse_digits

finish: 
    test    ebx, ebx
    jz      return
    neg     eax

return:
    pop    ebx
    pop    ebp  
    ret



