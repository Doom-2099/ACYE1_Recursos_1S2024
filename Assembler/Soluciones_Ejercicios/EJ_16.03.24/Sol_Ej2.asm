.MODEL small
.STACK 64h
.DATA
	numero db ?
	cadena db 3 dup(0)
	msg db "El Numero Procesado Es: ", "$"
.CODE
	MOV AX, data
	MOV DS, AX
	XOR AX, AX
	
   Main PROC
   	
   	MOV BH, 240
   	
   	CMP BH, 100
   	JB Decena
   	
   	Centena:
   		CALL CalcularCentena
   	
	    MUL BL
	    
	    MOV AH, BH
	    SUB AH, AL
	    MOV AL, AH
	    MOV BH, AL
	    MOV AH, 0
    
    Decena:
    	CMP BH, 10
    	JB Unidad
    	
    	CALL CalcularDecena
    	MUL BL
    
    Unidad:
    	CALL CalcularUnidad
	    
    
    MOV AH, 09h
    LEA DX, msg
    INT 21h
    
    MOV CL, 3
    MOV SI, 0
    
    Ciclo:
    	MOV AH, 02h
    	MOV DL, cadena[SI]
    	ADD DL, 48
    	INT 21h     
    	INC SI
    	LOOP Ciclo

   	MOV AX, 4C00h
   	INT 21h
   Main ENDP
   
   CalcularCentena PROC
	MOV BL, 100
	MOV AL, BH
	DIV BL
	MOV cadena[0], AL
	RET
	CalcularCentena ENDP
	   
	CalcularDecena PROC
	   	MOV BL, 10
	   	MOV AL, BH
	    DIV BL
	    MOV cadena[1], AL
	    RET	
	CalcularDecena ENDP
	
	CalcularUnidad PROC
		MOV AH, BH
	    SUB AH, AL
	    MOV AL, AH
	    MOV cadena[2], AL
	    RET
	CalcularUnidad ENDP	
END