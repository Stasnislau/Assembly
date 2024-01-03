    section .text 
    global  change_string
change_string: ; we recieve a string and a number, need put all the numbers to this sctring as chars
    push    ebp
    mov     ebp, esp

    push    ebx ; stores pointer to string
    xor     ebx, ebx

    mov     ebx, [ebp + 8]
    
    mov     eax, [ebp + 12]

convert_loop:
    xor edx, edx
    mov ecx, 10 
    div ecx               
    add     edx, '0' 
    mov     byte [ebx], dl
    inc     ebx
    test    eax, eax
    jnz     convert_loop

    mov    byte [ebx], 0


return:
    
    mov    eax, [ebp + 8]
    pop    ebx
    pop    ebp  
    ret



