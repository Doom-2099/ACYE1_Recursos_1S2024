
.MODEL small

.STACK 64h

.DATA

   cadena1 db "    __  __      __          __  ___                __    ", 10, 13, 32, 32, 32, 32, 32
   cadena2 db "   / / / /___  / /___ _    /  |/  /_  ______  ____/ /___ ", 10, 13, 32, 32, 32, 32, 32
   cadena3 db "  / /_/ / __ \/ / __ `/   / /|_/ / / / / __ \/ __  / __ \", 10, 13, 32, 32, 32, 32, 32
   cadena4 db " / __  / /_/ / / /_/ /   / /  / / /_/ / / / / /_/ / /_/ /", 10, 13, 32, 32, 32, 32, 32
   cadena5 db "/_/ /_/\____/_/\__,_/   /_/  /_/\__,_/_/ /_/\__,_/\____/ "

.CODE
   MOV AX, @data
   MOV DS, AX
   MOV ES, AX

   MOV AX, 03h
   INT 10h

   Main PROC
      MOV AH, 13h
      MOV AL, 1
      MOV BH, 0 ; Escribiendo mensaje en la pagina 0
      MOV BL, 0Eh ; Color Amarillo
      MOV CX, 313 ; Se escriben 313 caracteres
      MOV DL, 5
      MOV DH, 5
      LEA BP, cadena1
      INT 10h
      
      MOV AH, 13h
      MOV AL, 1   
      MOV BH, 1  ; Escribiendo mensaje en la pagina 1
      MOV BL, 02h ; Color verde
      MOV CX, 313 ; Se escribieron 313 caracteres
      MOV DL, 5
      MOV DH, 5
      LEA BP, cadena1
      INT 10h
      
      MOV CL, 50
      MOV AL, 0
      
      Ciclo:
         MOV AH, 05h
         INT 10h
         
         XOR AL, 1 ; Alternar entre pagina 0 y 1
         DEC CL
         
         CMP CL, 0
         JE Salir

         PUSH AX
         PUSH CX

         MOV AH, 86h ; Incluir delay (retardo)
         MOV CX, 5
         INT 15h

         POP CX
         POP AX

         JMP Ciclo
         
      Salir:
         MOV AX, 4C00h
         INT 21h
   Main ENDP
END