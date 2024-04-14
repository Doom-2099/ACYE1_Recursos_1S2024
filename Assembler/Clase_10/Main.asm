; * Cuando se ejecuta el macro de limpiar consola
; * Se limpian las 8 paginas del modo texto por lo que
; * Es necesario que despues de limpiar, se seleccione
; * La pagina que se va a utilizar
LimpiarConsola MACRO
    MOV AX, 03h 
    INT 10h        ; * Interrupcion para limpiar consola (LIMPIA TODAS LAS PAGINAS)

    MOV AH, 05h             ; * Seleccionamos la pagina que vamos a utilizar
    MOV AL, paginaActual    ; * El numero de pagina esta almacenado en la variable Pagina actual
    INT 10h
ENDM


; * MACRO que ejecuta un retardo a traves de la BIOS (VER DOCUMENTACION DE INTERRUPCIONES)
Retardo MACRO valor
    MOV AH, 86h
    MOV CX, valor
    INT 15h
ENDM

; * MACRO que revisa el estado del keyboard buffer (VER DOCUMENTACION DE INTERRUPCIONES)
LeerKeyboardBuffer MACRO
    LOCAL AlmacenarTecla, Continuar, TeclaDer, TeclaIzq, TeclaSpace
    MOV AH, 01h     ; * Interrupcion para observar el keyboard buffer
    INT 16h
    JNZ AlmacenarTecla  ; ! SI ZF ES 0 quiere decir que hay una tecla disponible en el buffer
    JMP Continuar       ; ! SI ZF ES 1 que continue con la animacion

    AlmacenarTecla:
        MOV CX, 0       ; ? Colocar CX = 0 Para terminar el ciclo de la animacion

        CMP AH, 4Dh  ; ? Compara si la tecla presionada es BIOS CODE = 4D(->)
        JE TeclaDer

        CMP AH, 4Bh   ; ? Compara si la tecla presionada es BIOS CODE = 4B(<-)
        JE TeclaIzq

        CMP AH, 39h   ; ? Compara si la tecla presionada es BIOS CODE = 4D([spacebar])
        JE TeclaSpace
        JMP Continuar    ; * Si no se presiono ninguna de estas teclas, se continua con la animacion

        TeclaDer:   ; * Si La Tecla Presionada Fue (->), Aumentar El Valor De Pagina En 1
            ADD paginaActual, 1
            JMP Continuar

        TeclaIzq:   ; * Si La Tecla Presionada Fue (<-), Disminuir El Valor De Pagina En 1
            SUB paginaActual, 1
            JMP Continuar

        TeclaSpace: ; * Si La Tecla Presionada Fue ([spacebar]), Terminar Animaciones
            MOV paginaActual, 8
            JMP Continuar

    Continuar:
        MOV AH, 0Ch ; * Limpiar El Keyboard Buffer
        MOV AL, 00h ; * Codigo para que no ejecute ninguna otra instruccion la interrupcion
        INT 21h
ENDM


; * MACRO para imprimir cadenas utilizando la interrupcion 10h
; * @params
; * Fila: Fila donde iniciara el print
; * Columna: Columna donde iniciara el print
; * Pagina: Pagina donde se hara el print
; * Longitud: Longitud de la cadena que se va a imprimir
; * Color: Atributo de color que se le aplicara a la cadena
PrintCadena MACRO fila, columna, pagina, longitud, cadena, color
    MOV AL, 1           ; ? PONER AL en 1 indica que se va a actualizar el cursor despues del print (VER DOCUMENTACION INTERRUPCIONES)
    MOV BH, pagina      ; ? Pagina en donde se hara el print de la cadena
    MOV BL, color       ; ? Color que tendran los caracteres impresos
    MOV CX, longitud    ; ? Longitud de la cadena a imprimir
    MOV DL, columna     ; ? Columna donde iniciara el print
    MOV DH, fila        ; ? Fila donde iniciara el print, EN MODO TEXTO SE TRABAJA CON UN ESPACIO DE 80 Columnas * 25 Filas
    MOV BP, cadena      ; ? Posicion en memoria de la cadena a imprimir (INICIO DE LA CADENA)
    MOV AH, 13h
    INT 10h
ENDM


; * MACRO para la animacion 1 | Direccion: ↓
Animacion1 MACRO
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 21 ; * Repetir el ciclo 21 veces (YO DEFINI ESTE NUMERO)

    Ciclo:
        PUSH CX ; * Guardo mi contador para la iteracion del ciclo en la pila
        MOV saltoCadena, OFFSET cadena1 ; * muevo a variable saltoCadena la posicion en memoria de la "cadena1"
                                        ; ! OJO: ESTOY MOVIENDO LA POSICION NO EL CONTENIDO DE LA CADENA
        
        MOV CX, 5 ; * Repetir el ciclo de impresion 5 veces (PORQUE EL TEXTO A IMPRIMIR TIENE 5 LINEAS)
        PrintArt:
            PUSH CX ; * Guardo mi contador para la iteracion del ciclo en la pila
            ; ! La variable "filaActual" lleva el control de las filas del mensaje
            PrintCadena filaActual, 11, 0, 57, saltoCadena, 2 ; ? llamo al macro de hacer el print con los parametros solicitados
            
            ; ? PARA ESTE CASO UTILIZO FILA ACTUAL COMO VARIABLE PARA HACER EL PRINT DE LAS 5 LINEAS DE MI MENSAJE
            INC DH  
            MOV filaActual, DH

            ; ? COMO CADA LINEA DE MI MENSAJE TIENE UNA LONGITUD DE 57 CARACTRES (57 BYTES) HAGO UNA SUMA EN AX, para
            ; ? POSTERIORMENTE ALMACENARLO EN MI VARIABLE "saltoCadena"
            ; ? Debo usar AX porque saltoCadena es una variable WORD, ya que se asignara al registro BP que es de 16 bits
            MOV AX, saltoCadena
            ADD AX, 57
            MOV saltoCadena, AX


            POP CX      ; * Saco mi contador para la etiqueta PrintArt de la pila
            LOOP PrintArt ; * Instruccion LOOP(VER DOCUMENTACION DE INSTRUCCIONES)

        Retardo 2 ; * Hago una llamada al macro de retardo y asi poder visualizar mejor el mensaje

        POP CX  ; * Saco mi contador para la etiqueta "Ciclo" de la pila
        DEC CX  ; * Decremento CX en una unidad

        LeerKeyboardBuffer

        ; * Ya que es un movimiento vertical hacia abajo. Mi variable fila almacena la siguiente posicion
        ; * En donde va a iniciar el siguiente print
        ; * Posteriormente este valor de fila, se asigna a "filaActual" que lleva el control de las filas del print
        ; * Se actualizan los valores y se almacenan en memoria en sus respectivas variables
        MOV AL, fila        
        INC AL
        MOV filaActual, AL
        MOV fila, AL

        ; ! DEBIDO A LA CANTIDAD DE INSTRUCCIONES UTILIZADAS DENTRO DE ESTA ETIQUETA
        ; ! SE HACE UN SALTO CORTO HACIA LA ETIQUETA "TerminarCiclo" con JE en caso CX == 0
        ; ! PARA NO TENER PROBLEMAS CON LA LONGITUD DE LOS SALTOS
        ; ! CASO CONTRARIO SE HACE UN SALTO ABSOLUTO HACIA LA ETIQUETA "Ciclo" EVITANDO ASI ERRORES CON EL TAMAÑO DE LOS SALTOS
        CMP CX, 0 ; * Verifico si el ciclo ya ha terminado haciendo la comparacion si CX ya ha llegado a 0
        JE TerminarCiclo ; * En caso CX sea 0, salta al fin del macro
        LimpiarConsola  ; * Limpiamos la consola para que de la "sensacion de movimiento"
        JMP Ciclo ; * Hacemos un salto absoluto a la etiqueta Ciclo para la proxima iteracion

    TerminarCiclo:  ; ? Etiqueta de fin del MACRO
ENDM

Animacion2 MACRO
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 24

    Ciclo:
        MOV filaActual, 8
        PUSH CX
        MOV saltoCadena, OFFSET cadena1

        MOV CX, 5
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, 1, 57, saltoCadena, 5
            INC DH
            MOV filaActual, DH
            MOV AX, saltoCadena
            ADD AX, 57
            MOV saltoCadena, AX
            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        MOV AL, columna
        INC AL
        MOV columna, AL
        
        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

Animacion3 MACRO
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 21

    MOV fila, 0
    MOV filaActual, 0
    MOV columna, 0

    Ciclo:
        PUSH CX
        MOV saltoCadena, OFFSET cadena1

        MOV CX, 5
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, 2, 57, saltoCadena, 14
            INC DH
            MOV filaActual, DH
            MOV AX, saltoCadena
            ADD AX, 57
            MOV saltoCadena, AX
            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        MOV AL, columna
        INC AL
        MOV columna, AL
        
        MOV AL, fila
        INC AL
        MOV fila, AL
        MOV filaActual, AL

        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

Animacion4 MACRO
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 21

    MOV fila, 24
    MOV filaActual, 24
    MOV columna, 0

    Ciclo:
        PUSH CX
        MOV saltoCadena, OFFSET cadena5

        MOV CX, 5
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, 3, 57, saltoCadena, 6
            DEC DH
            MOV filaActual, DH
            MOV AX, saltoCadena
            SUB AX, 57
            MOV saltoCadena, AX
            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        MOV AL, columna
        INC AL
        MOV columna, AL
        
        MOV AL, fila
        DEC AL
        MOV fila, AL
        MOV filaActual, AL

        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

.MODEL small

.STACK 100h

.DATA
    cadena1 db "    __  __      __          __  ___                __    "
    cadena2 db "   / / / /___  / /___ _    /  |/  /_  ______  ____/ /___ "
    cadena3 db "  / /_/ / __ \/ / __ `/   / /|_/ / / / / __ \/ __  / __ \"
    cadena4 db " / __  / /_/ / / /_/ /   / /  / / /_/ / / / / /_/ / /_/ /"
    cadena5 db "/_/ /_/\____/_/\__,_/   /_/  /_/\__,_/_/ /_/\__,_/\____/ "
    fila db 0
    filaActual db 0
    columna db 0
    saltoCadena dw ?
    paginaActual db 0
.CODE

    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    LimpiarConsola

    Main PROC

        Ciclo: ; ? -> Etiqueta que permite enciclar de manera indefinida las animaciones

            ; ! REINICIAR LAS VARIABLES DE LA ANIMACION
            MOV fila, 0
            MOV filaActual, 0
            MOV columna, 0
            
            CMP paginaActual, 0 ; * Salto A Pagina 1
            JZ EtAnimacion1Aux

            CMP paginaActual, 1 ; * Salto A Pagina 2
            JZ EtAnimacion2Aux

            CMP paginaActual, 2 ; * Salto A Pagina 3
            JZ EtAnimacion3Aux

            CMP paginaActual, 3 ; * Salto A Pagina 4
            JZ EtAnimacion4Aux
            JMP Salir   ; ! -> Si "paginaActual" Sobrepasa A Los Valores Definidos Que Salga Del Ciclo

            ; ? ETIQUETAS AUXILIARES PARA EVITAR ERRORES CON LA LONGITUD DE SALTOS
            EtAnimacion1Aux:    
                JMP EtAnimacion1
            EtAnimacion2Aux:
                JMP EtAnimacion2
            EtAnimacion3Aux:
                JMP EtAnimacion3
            EtAnimacion4Aux:
                JMP EtAnimacion4

            ; * Invocacion Animacion 1
            EtAnimacion1:
                Animacion1
                JMP Ciclo

            ; * Invocacion Animacion 2
            EtAnimacion2:
                Animacion2
                JMP Ciclo

            ; * Invocacion Animacion 3
            EtAnimacion3:
                Animacion3
                JMP Ciclo

            ; * Invocacion Animacion 4
            EtAnimacion4:
                Animacion4
                JMP Ciclo
                
        Salir:
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END