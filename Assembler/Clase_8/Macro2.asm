ImprimirTablero MACRO
    LOCAL fila, columna
    XOR BX, BX
    XOR SI, SI

    Print columnas
    MOV CL, 0

    fila:
        Print salto
        MOV AH, 02h
        MOV DL, filas[BX]
        INT 21h

        MOV DL, 32
        INT 21h

        columna:
            MOV DL, matriz[SI]
            INT 21h

            MOV DL, 124
            INT 21h

            INC CL
            INC SI

            CMP CL, 8
            JB columna

            MOV CL, 0
            INC BX
            CMP BX, 8
            JB fila
ENDM

RowMajorMatriz MACRO
    MOV AL, row
    MOV BL, col
    
    SUB AL, 49
    SUB BL, 65
    
    MOV BH, 8
    
    MUL BH
    ADD AL, BL
    
    MOV SI, AX
    MOV matriz[SI], 64
ENDM