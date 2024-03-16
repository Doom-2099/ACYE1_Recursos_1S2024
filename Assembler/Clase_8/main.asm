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
    
    
    

.MODEL small

.STACK 64h

.DATA
    salto db 10, 13, "$"
    msg1 db 10, 13, 10, 13, "Ingrese la fila: ", "$"
    msg2 db 10, 13, "Ingrese la columna: ", "$"
    matriz db 64 dup(32)
    columnas db "  A B C D E F G H","$"
    filas db "12345678","$"
    msgSalida db "Saliendo Del Programa...", "$"
    msgEFila db 10, 13, "La Fila Ingresada Es Incorrecta", "$"
    msgEColumna db 10, 13, "La Columna Ingresada Es Incorrecta", "$"
    opcion db 1 dup("$")
    row db 1 dup("$")
    col db 1 dup("$")
    
.CODE
    MOV AX, data
    MOV DS, AX
    
    Main PROC
        Menu:
            LimpiarConsola
            ImprimirTablero 
            
        PedirOpcionFila:
            Print msg1
            getOpcion row 
            
            CMP row, 49
            JB ErrorFila
            
            CMP row, 56
            JA ErrorFila
            JMP PedirOpcionColumna
            
        ErrorFila:
            Print msgEFila
            getOpcion opcion
            JMP PedirOpcionFila
        
        PedirOpcionColumna:
            Print msg2
            getOpcion col 
            
            CMP col, 65
            JB ErrorColumna
            
            CMP col, 72
            JA ErrorColumna
            JMP PosicionarMatriz

       ErrorColumna:
            Print msgEColumna
            getOpcion opcion
            JMP PedirOpcionColumna
       
       PosicionarMatriz:
            RowMajorMatriz
            JMP Menu
        
        Salir:
            Print salto
            Print msgSalida
            getOpcion row
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END