; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    MOV AL, 1
    MOV AH, 11
    AND AH, 1
    XOR AL, AH
    
                   
    Salir:
        mov ax, 4c00h ; exit to operating system.
        int 21h    
ends

end start ; set entry point and stop the assembler.
