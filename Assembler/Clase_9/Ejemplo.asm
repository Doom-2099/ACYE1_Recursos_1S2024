LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h
ENDM

PosicionarCursor MACRO
    MOV AH, 02h
    MOV BH, 00h
    INT 10h
ENDM

PrintCadena MACRO registro
    MOV AH, 09h
    LEA DX, registro
    INT 21h
ENDM

; TODO: HACER ANIMACION EN 4 DE LOS 8 SENTIDOS
Animacion MACRO
    LOCAL Ciclo, Salir, AuxCiclo

    MOV DL, 0
    MOV CX, 15

    Ciclo:
        MOV DH, linea
        PUSH CX
        PosicionarCursor
        PUSH DX

        MOV AH, 09h
        LEA DX, cadena1
        INT 21h

        POP DX
        INC DH
        PosicionarCursor
        PUSH DX

        MOV AH, 09h
        LEA DX, cadena2
        INT 21h

        POP DX
        INC DH
        PosicionarCursor
        PUSH DX

        MOV AH, 09h
        LEA DX, cadena3
        INT 21h

        POP DX
        INC DH
        PosicionarCursor
        PUSH DX

        MOV AH, 09h
        LEA DX, cadena4
        INT 21h

        POP DX
        INC DH
        PosicionarCursor
        PUSH DX

        MOV AH, 09h
        LEA DX, cadena5
        INT 21h

        POP DX
        INC DH
        PosicionarCursor

        MOV AH, 86h ; Incluir delay (retardo)
        MOV CX, 5
        INT 15h

        POP CX

        LimpiarConsola
        ; INC DL
        MOV DH, linea
        INC DH
        MOV linea, DH
        DEC CX
        CMP CX, 0
        JNZ AuxCiclo
        JMP Salir

    AuxCiclo:
        JMP Ciclo

    Salir:
ENDM

.MODEL small

.STACK 64h

.DATA
    cadena1 db "    __  __      __          __  ___                __    ", "$"
    cadena2 db "   / / / /___  / /___ _    /  |/  /_  ______  ____/ /___ ", "$"
    cadena3 db "  / /_/ / __ \/ / __ `/   / /|_/ / / / / __ \/ __  / __ \", "$"
    cadena4 db " / __  / /_/ / / /_/ /   / /  / / /_/ / / / / /_/ / /_/ /", "$"
    cadena5 db "/_/ /_/\____/_/\__,_/   /_/  /_/\__,_/_/ /_/\__,_/\____/ ", "$"
    linea db 0

.CODE
    MOV AX, @data
    MOV DS, AX

    Main PROC
        LimpiarConsola
        Animacion

        MOV AX, 4C00h
        INT 21h
    Main ENDP
END