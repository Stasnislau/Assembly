    section .text 
    global  change_string
emphasize8: ; Enhance the dynamic range of 8 bpp grayscale image so that the darkest shade becomes black and the lightest – white. Change the intermediate shades proportionally.

    push    ebp
    mov     ebp, esp
    push    ebx 
    push    esi  

    xor     esi, esi

    mov     ebx, [ebp + 8]
    
    mov     eax, [ebp + 12]
    


return:
    mov    eax, [ebp + 8]
    pop    esi
    pop    ebx
    pop    ebp  
    ret

