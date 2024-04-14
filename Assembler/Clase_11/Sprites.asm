TableroTotito MACRO
    LOCAL Barra1, Barra2, Barra3, Barra4, SalirTablero
    XOR AX, AX
    XOR CX, CX
    XOR DX, DX

    MOV AL, 09h
    MOV CX, 105
    MOV DX, 0
    MOV AH, 0Ch
    
    Barra1:
        INT 10h
        
        INC DX
        
        CMP DX, 200
        JB Barra1
        
        INC CX
        
        CMP CX, 110
        JA ContinuarBarra2
        MOV DX, 0
        JMP Barra1
        
    ContinuarBarra2:
        MOV CX, 210
        MOV DX, 0
        
    Barra2:
        INT 10h
        
        INC DX
        
        CMP DX, 200
        JB Barra2
        
        INC CX
        
        CMP CX, 215
        JA ContinuarBarra3
        MOV DX, 0
        JMP Barra2

    ContinuarBarra3:
        MOV CX, 0
        MOV DX, 60

    Barra3:
        INT 10h

        INC CX

        CMP CX, 320
        JB Barra3

        INC DX

        CMP DX, 65
        JA ContinuarBarra4
        MOV CX, 0
        JMP Barra3


    ContinuarBarra4:
        MOV CX, 0
        MOV DX, 125

    Barra4:
        INT 10h

        INC CX

        CMP CX, 320
        JB Barra4

        INC DX

        CMP DX, 130
        JA SalirTablero
        MOV CX, 0
        JMP Barra4

    SalirTablero:
ENDM

SpriteX MACRO
    LOCAL Ciclo1, Ciclo2
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]

    MOV BL, filaMov
    MOV DL, posicionesFila[BX]

    MOV AL, 6
    MOV AH, 0Ch
    MOV BL, 0

    Ciclo1:
        INT 10h

        INC CX
        INC DX
        INC BL
        CMP BL, 30
        JNE Ciclo1

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]
    ADD CL, 30

    MOV BL, filaMov
    MOV DL, posicionesFila[BX]

    MOV BL, 0

    Ciclo2:
        INT 10h

        DEC CX
        INC DX
        INC BL
        CMP BL, 30
        JNE Ciclo2
ENDM

SpriteO MACRO
    LOCAL Part1, Part2, Part3, Part4
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV AL, 10
    MOV AH, 0Ch

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]
    
    MOV BL, filaMov
    MOV DL, posicionesFila[BX]

    MOV BL, 0

    Part1:
        INT 10h

        INC CX
        INC BL
        CMP BL, 31
        JNE Part1

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]

    MOV BL, 0

    Part2:
        INT 10h

        INC DX
        INC BL
        CMP BL, 31
        JNE Part2

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]
    ADD CL, 30
    
    MOV BL, filaMov
    MOV DL, posicionesFila[BX]
    ADD DL, 30

    MOV BL, 0

    Part3:
        INT 10h

        DEC CX
        INC BL
        CMP BL, 31
        JNE Part3

    MOV BL, colMov
    MOV CL, posicionesColumna[BX]
    ADD CL, 30

    MOV BL, 0

    Part4:
        INT 10h

        DEC DX
        INC BL
        CMP BL, 31
        JNE Part4
ENDM

PedirMovimiento MACRO
    MOV AX, 03h
    INT 10h

    MOV Ah, 09h
    LEA DX, pedirFila
    INT 21h

    MOV AH, 1
    INT 21h

    SUB AL, 49
    MOV filaMov, AL

    MOV Ah, 09h
    LEA DX, salto
    INT 21h

    MOV Ah, 09h
    LEA DX, pedirColumna
    INT 21h

    MOV AH, 1
    INT 21h

    SUB AL, 49
    MOV colMov, AL
ENDM

.MODEL small

.STACK 100h

.DATA
    posicionesColumna db 35, 145, 250
    posicionesFila db 15, 80, 150

    filaMov db 0
    colMov db 0

    salto db 10, 13, "$"
    pedirFila db "Ingrese La Fila: ", "$"
    pedirColumna db "Ingrese La Columna: ", "$"
    turno db 0
.CODE
    MOV AX, @data
    MOV DS, AX

    Main PROC
        ; TODO: TERMINAR EJEMPLO
        Tablero:
            PedirMovimiento

            MOV AL, 13h
            MOV AH, 00h
            INT 10h

            TableroTotito

            CMP turno, 0
            JE PintarSpriteX

            CMP turno, 1
            JE PintarSpriteO

            PintarSpriteX:
                SpriteX
                MOV AL, turno
                INC AL
                MOV turno, AL
                JMP ContinuarModoVideo

            PintarSpriteO:
                SpriteO
                MOV AL, turno
                DEC AL
                MOV turno, AL

            ContinuarModoVideo:
                MOV AH, 10h
                INT 16h

                MOV AL, 03h
                MOV AH, 00h
                INT 10h

            JMP Tablero

        Salir:
            MOV AX, 4C00H
            INT 21h 
    Main ENDP
END