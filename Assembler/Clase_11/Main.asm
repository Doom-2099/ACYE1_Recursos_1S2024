CrearCadena MACRO valor
    LOCAL CICLO, DIVBASE, SALIR, ADDZERO
    
    CICLO:
        MOV DX, 0
        MOV CX, valor
        CMP CX, base
        JB DIVBASE

        MOV BX, base
        MOV AX, valor
        DIV BX
        MOV cadena[SI], AL
        ADD cadena[SI], 48
        INC SI

        MUL BX
        SUB valor, AX

        CMP base, 1
        JE SALIR
        
        DIVBASE:
            CMP valor, 0
            JE ADDZERO

            MOV AX, base
            MOV BX, 10
            DIV BX
            MOV base, AX
            JMP CICLO
            
            ADDZERO:
                MOV cadena[SI], 48
                INC SI
    SALIR:
ENDM

.MODEL small

.STACK 64h

.DATA
    cadena db 20 dup("$")
    valor dw ?
    base dw 10000
    entero dw ?
    decimal dw ?
    cantDecimal db 0
    divisor dw 90

.CODE
    MOV AX, @data
    MOV DS, AX

    MOV SI, 0

    Main PROC
        MOV AX, 425
        MOV BX, divisor
        MOV DX, 0
        DIV BX
        MOV entero, AX
        MOV decimal, DX

        CrearCadena entero

        MOV cadena[SI], 46
        INC SI

        CMP decimal, 0
        JNE CicloDecimal

        MOV cadena[SI], 48
        INC SI
        MOV cadena[SI], 48
        JMP Continuar

        CicloDecimal:
            MOV AX, decimal
            MOV BX, 10
            MOV DX, 0
            MUL BX

            MOV BX, divisor
            MOV DX, 0
            DIV BX
            
            MOV decimal, DX
            MOV entero, AX
            CrearCadena entero
            MOV AL, cantDecimal
            INC AL
            MOV cantDecimal, AL
            CMP AL, 2
            JNE CicloDecimal
                
        Continuar:
            MOV AH, 09h
            LEA DX, cadena
            INT 21h
                
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END