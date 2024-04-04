.MODEL small

.STACK 100h

.DATA

.CODE
    MOV AX, 03h
    INT 10h

    Main PROC
        MOV AL, 13h     ; Cambiamos Al Modo Video
        MOV AH, 00H
        INT 10h
        
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
            MOV AL, 09h
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
            MOV AL, 09h
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
            MOV AL, 09h
            MOV DX, 125

        Barra4:
            INT 10h

            INC CX

            CMP CX, 320
            JB Barra4

            INC DX

            CMP DX, 130
            JA Salir
            MOV CX, 0
            JMP Barra4

        Salir:
            MOV AH, 86h
            MOV CX, 200
            INT 15h

            MOV AL, 03h
            MOV AH, 00h
            INT 10h

            MOV AX, 03h
            INT 10h

            MOV AX, 4C00H
            INT 21h 
    Main ENDP
END