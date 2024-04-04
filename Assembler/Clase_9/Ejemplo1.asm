.MODEL small

.STACK 64h

.DATA

    msg1 db "Hola Iniciando Modo Video...", "$"
    msg2 db "Ha Terminado Modo Video...", "$"

.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    MOV AX, 03h ; Definimos el modo video AH = 0h | AL = 03h
    INT 10h

    Main PROC
        MOV AH, 09h     ; Imprimir Mensaje En Pantalla
        LEA DX, msg1 
        INT 21h
        
        MOV AH, 86h     ; Aplicar Un Delay
        MOV CX, 25
        INT 15h
        
        MOV AL, 13h     ; Cambiar A Modo Video
        MOV AH, 00H
        INT 10h 

        ; Pintar 50 Pixeles De Un Color
        MOV BL, 50      ; BL -> Contador 50 iteraciones
        MOV AL, 0Ch     ; Color codigo C (se puede usar un numero entre 0 y 255)
        MOV CX, 10      ; Empiecen en la columna 10
        MOV DX, 20      ; Empiece en la fila 20
        MOV AH, 0Ch     ; Codigo De la Interrupcion

        Ciclo:
            INT 10h
            
            INC CX
            DEC BL
            CMP BL, 0
            JNE Ciclo

        MOV AH, 86h     ; Aplicar Un Delay
        MOV CX, 25
        INT 15h

        MOV AL, 03h       ; Cambiar A Modo Texto
        MOV AH, 00h
        INT 10h
        
        ; Imprimimos Cadena Personalizada
        MOV AH, 13h  ; Codigo Interrupcion
        MOV AL, 1    ; 00000011 -> MOV AL, 2 Modo Escritura
        MOV BH, 0    ; Pagina a Utilizar
        MOV BL, 04h  ; Atributos 4 bits altos color black => 0000
                     ; Atributos 4 bits bajos color red => 0100
                     ; MOV BL, 00000100b (Opcion Alterna)
        MOV CX, 26   ; Cantidad De Caracteres De La Cadena
        MOV DL, 10   ; Columna Donde se va a empezar a escribir
        MOV DH, 7    ; Fila Donde se va a empezar a escribir
        LEA BP, msg2 ; Offset de la segunda cadena 2 en B
        INT 10h      ; Invocar la interrupcion

        ; Aplicamos Un Delay
        MOV AH, 86h       
        MOV CX, 5
        INT 15h

        Salir:
            MOV AX, 4C00h            ; Terminamos El Programa
            INT 21h
    Main ENDP
END