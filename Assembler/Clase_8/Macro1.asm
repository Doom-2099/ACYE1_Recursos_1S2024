LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h
ENDM

Print MACRO registro
    LEA DX, registro
    MOV AH, 09h
    INT 21h
ENDM

getOpcion MACRO memoria
    MOV AH, 01h
    INT 21h
    
    MOV memoria, AL
ENDM