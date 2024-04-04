.MODEL small

.STACK 64h

.DATA
    msg db "Hola Mundo", "$"
.CODE
    MOV AX, @data
    MOV DX, AX
    MOV ES, AX

    MOV AX, 03h
    INT 10h
    
    Main PROC
        MOV AL, 1
        MOV BH, 0
        MOV BL, 02h
        
        ; Hola Mundo
        MOV CX, 10 ; Imprimir 10 caracteres
        MOV DL, 69  ; Columna
        MOV DH, 24 ; Fila
        LEA BP, msg ; offset msg
        MOV AH, 13h
        INT 10h 
        
        MOV AX, 4C00h
        INT 21h
    Main ENDP
END