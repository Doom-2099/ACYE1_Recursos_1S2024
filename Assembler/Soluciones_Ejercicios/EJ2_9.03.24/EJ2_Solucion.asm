; multi-segment executable file template.

data segment
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
    
    MOV BL, 11
    SHR BL, 1
    JC Impar
    
    Par: 
        MOV AL, 1
        JMP Salir
    
    Impar:
        MOV AL, 0
    
    Salir:
        mov ax, 4c00h ; exit to operating system.
        int 21h    
ends

end start ; set entry point and stop the assembler.
