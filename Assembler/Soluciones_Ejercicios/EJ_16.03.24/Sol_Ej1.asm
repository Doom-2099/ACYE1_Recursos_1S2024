.MODEL small
.STACK 64h
.DATA
.CODE
   Main PROC
   	   ;Numero En BL
	   MOV AL, BL
	   MOV CL, 10 ; Preparar Registro Para Dividir Entre CL
	   DIV CL
	   
	   MOV CL, 2
	   MUL CL
	   
	   MOV DX, AX
   
   Main ENDP
END
