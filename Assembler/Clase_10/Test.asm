LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h

    MOV AH, 05h             ; * Seleccionamos la pagina que vamos a utilizar
    MOV AL, paginaActual    ; * El numero de pagina esta almacenado en la variable Pagina actual
    INT 10h
ENDM

Retardo MACRO valor
    MOV AH, 86h
    MOV CX, valor
    MOV DX, 0
    INT 15h
ENDM

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

PrintSencillo MACRO cadena
    MOV AH, 09h
    LEA DX, cadena
    INT 21h
ENDM

OpenFile MACRO handlerFile
    LOCAL ErrorToOpen, ExitOpenFile
    MOV AL, 2
    LEA DX, filename
    MOV AH, 3Dh
    INT 21h

    JC ErrorToOpen

    MOV handlerFile, AX
    PrintSencillo salto
    PrintSencillo exitOpenFileMsg
    JMP ExitOpenFile

    ErrorToOpen:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintSencillo salto
        PrintSencillo errorOpenFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h

    ExitOpenFile:
ENDM

CloseFile MACRO handler
    LOCAL ErrorToClose, ExitCloseFile
    MOV AH, 3Eh
    MOV BX, handler
    INT 21h

    JC ErrorToClose

    PrintSencillo salto
    PrintSencillo exitCloseFileMsg
    JMP ExitCloseFile

    ErrorToClose:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintSencillo salto
        PrintSencillo errorCloseFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h
    
    ExitCloseFile:
ENDM

ReadAsciiFile MACRO bufferImagen, charsPerRow, cantRows
    LOCAL ReadChar, ErrorReadFile, SaveFirstLine, ReadPerRow, SaveChar, ExitReadFile, SaveLine, VerifyEnd, CopyLine, OffsetLine
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV CX, 1
    LEA DX, bufferTemporal
    MOV SI, 0

    ReadChar:
        MOV AH, 3Fh
        MOV BX, handler
        INT 21h

        JC ErrorReadFile

        CMP bufferTemporal[SI], 0Ah
        JE SaveFirstLine

        INC DX
        INC SI
        INC charsPerRow
        JMP ReadChar

        SaveFirstLine:
            MOV CX, charsPerRow
            MOV SI, 0

            SaveChar:
                MOV AL, bufferTemporal[SI]
                MOV bufferImagen[SI], AL
                MOV bufferTemporal[SI], 36
                INC SI
                LOOP SaveChar
            
            INC cantRows
            JMP ReadPerRow

    ErrorReadFile:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintSencillo salto
        PrintSencillo errorReadFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h
        JMP ExitReadFile

    ReadPerRow:
        MOV AH, 3Fh
        MOV BX, handler
        LEA DX, bufferTemporal
        MOV CX, charsPerRow
        INT 21h

        MOV AL, 01h
        MOV AH, 42h
        MOV BX, handler
        MOV DX, 1
        MOV CX, 0
        INT 21h

        MOV posApuntador, AX
        
        MOV SI, 0
        MOV CX, 25
        VerifyEnd:
            CMP CX, 0
            JZ ExitReadFile

            MOV AL, bufferTemporal[SI]
            INC SI
            DEC CX

            CMP AL, 45
            JE VerifyEnd

        MOV SI, 0
        XOR CX, CX
        SaveLine:
            MOV CX, cantRows
            OffsetLine:
                ADD SI, charsPerRow
                LOOP OffsetLine

            MOV CX, charsPerRow
            MOV DI, 0
            CopyLine:
                MOV AL, bufferTemporal[DI]
                MOV bufferImagen[SI], AL
                MOV bufferTemporal[DI], 36
                INC SI
                INC DI
                LOOP CopyLine

            INC cantRows
            JMP ReadPerRow

    ExitReadFile:
ENDM

GetSizeFile MACRO handler
    LOCAL ErrorGetSize, ExitGetSize
    MOV AH, 42h
    MOV AL, 2
    MOV BX, handler
    MOV CX, 0
    MOV DX, 0
    INT 21h

    JC ErrorGetSize

    MOV extensionArchivo, AX

    PrintSencillo salto
    PrintSencillo exitSizeFileMsg

    MOV AH, 42h
    MOV AL, 0
    MOV BX, handler
    MOV CX, 0
    MOV DX, 0
    INT 21h
    JMP ExitGetSize

    ErrorGetSize:
        MOV errorCode, AL
        ADD errorCode, 48

        PrintSencillo salto
        PrintSencillo errorSizeFile

        MOV AH, 02h
        MOV DL, errorCode
        INT 21h

    ExitGetSize:
ENDM

CargarFile MACRO
    LOCAL ExitCargarFile, Img2, Img3, Img4, Img5, Img6, Img7, Img8
    OpenFile handler
    GetSizeFile handler
    
    ReadAsciiFile bufferImagen1, charsPerRow1, cantRows1

    MOV AX, posApuntador
    MOV BX, extensionArchivo
    CMP AX, BX
    JB Img2
    JMP ExitCargarFile

    Img2:
        ReadAsciiFile bufferImagen2, charsPerRow2, cantRows2

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img3
        JMP ExitCargarFile

    Img3:
        ReadAsciiFile bufferImagen3, charsPerRow3, cantRows3

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img4
        JMP ExitCargarFile

    Img4:
        ReadAsciiFile bufferImagen4, charsPerRow4, cantRows4

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img5
        JMP ExitCargarFile

    Img5:
        ReadAsciiFile bufferImagen5, charsPerRow5, cantRows5

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img6
        JMP ExitCargarFile
    
    Img6:
        ReadAsciiFile bufferImagen6, charsPerRow6, cantRows6

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img7
        JMP ExitCargarFile
    
    Img7:
        ReadAsciiFile bufferImagen7, charsPerRow7, cantRows7

        MOV AX, posApuntador
        MOV BX, extensionArchivo
        CMP AX, BX
        JB Img8
        JMP ExitCargarFile

    Img8:
        ReadAsciiFile bufferImagen8, charsPerRow8, cantRows8
    
    ExitCargarFile:
        CloseFile handler
ENDM

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

Animacion1 MACRO charsPerRow, cantRows, bufferImagen
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 25
    SUB CX, cantRows

    Ciclo:
        PUSH CX
        MOV saltoCadena, OFFSET bufferImagen
        
        MOV CX, cantRows
        PrintArt:
            PUSH CX
            PrintCadena filaActual, 10, paginaActual, charsPerRow, saltoCadena, 2
            INC filaActual

            MOV AX, charsPerRow
            ADD saltoCadena, AX

            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        INC fila
        MOV AL, fila
        MOV filaActual, AL

        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

Animacion2 MACRO charsPerRow, cantRows, bufferImagen
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 80
    SUB CX, charsPerRow

    Ciclo:
        MOV filaActual, 8
        PUSH CX
        MOV saltoCadena, OFFSET bufferImagen

        MOV CX, cantRows
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, paginaActual, charsPerRow, saltoCadena, 5
            INC filaActual
            MOV AX, charsPerRow
            ADD saltoCadena, AX
            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        INC columna
        
        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

Animacion3 MACRO charsPerRow, cantRows, bufferImagen
    LOCAL Ciclo, PrintArt, TerminarCiclo
    MOV CX, 25
    SUB CX, cantRows

    MOV fila, 0
    MOV filaActual, 0
    MOV columna, 0

    Ciclo:
        PUSH CX
        MOV saltoCadena, OFFSET bufferImagen

        MOV CX, cantRows
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, paginaActual, charsPerRow, saltoCadena, 14
            INC filaActual

            MOV AX, charsPerRow
            ADD saltoCadena, AX
            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        INC columna
        
        INC fila
        MOV AL, fila
        MOV filaActual, AL

        CMP CX, 0
        JE TerminarCiclo
        LimpiarConsola
        JMP Ciclo

    TerminarCiclo:
ENDM

Animacion4 MACRO charsPerRow, cantRows, bufferImagen
    LOCAL Ciclo, PrintArt, TerminarCiclo, addOffset
    MOV CX, 25
    SUB CX, cantRows

    MOV fila, 24
    MOV filaActual, 24
    MOV columna, 0

    Ciclo:
        PUSH CX
        MOV saltoCadena, OFFSET bufferImagen
        
        MOV CX, cantRows
        DEC CX
        MOV AX, charsPerRow

        addOffset:
            ADD saltoCadena, AX
            LOOP addOffset

        XOR AX, AX
        MOV CX, cantRows
        PrintArt:
            PUSH CX
            PrintCadena filaActual, columna, paginaActual, charsPerRow, saltoCadena, 6
            DEC filaActual

            MOV AX, charsPerRow
            SUB saltoCadena, AX

            POP CX
            LOOP PrintArt

        Retardo 2

        POP CX
        DEC CX

        LeerKeyboardBuffer

        INC columna
        
        DEC fila
        MOV AL, fila
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
    handler             dw ?
    filename            db "Input1.txt", 0
    salto               db 10, 13, "$"
    errorCode           db ?
    errorOpenFile       db "Ocurrio Un Error Al Abrir El Archivo - ERRCODE: ", "$"
    errorCloseFile      db "Ocurrio Un Error Al Cerrar El Archivo - ERRCODE: ", "$"
    errorReadFile       db "Ocurrio Un Error Al Leer El Archivo - ERRCODE: ", "$"
    errorSizeFile       db "Ocurrio Un Error Obteniendo El Size Del Archivo - ERRCODE: ", "$"
    exitOpenFileMsg     db "El Archivo Se Abrio Correctamente", "$"
    exitCloseFileMsg    db "El Archivo Se Cerro Correctamente", "$"
    exitSizeFileMsg     db "Se Obtuvo La Longitud Correctamente", "$"
    bufferTemporal      db 80 dup("$")
    bufferImagen1       db 900 dup("$")
    bufferImagen2       db 900 dup("$")
    bufferImagen3       db 900 dup("$")
    bufferImagen4       db 900 dup("$")
    bufferImagen5       db 900 dup("$")
    bufferImagen6       db 900 dup("$")
    bufferImagen7       db 900 dup("$")
    bufferImagen8       db 900 dup("$")
    charsPerRow1        dw ?
    cantRows1           dw ?
    charsPerRow2        dw ?
    cantRows2           dw ?
    charsPerRow3        dw ?
    cantRows3           dw ?
    charsPerRow4        dw ?
    cantRows4           dw ?
    charsPerRow5        dw ?
    cantRows5           dw ?
    charsPerRow6        dw ?
    cantRows6           dw ?
    charsPerRow7        dw ?
    cantRows7           dw ?
    charsPerRow8        dw ?
    cantRows8           dw ?
    saltoCadena         dw ?
    extensionArchivo    dw 0
    posApuntador        dw 0
    filaActual          db 0
    fila                db 0
    columna             db 5
    paginaActual        db 0
.CODE
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX

    Main PROC

        CargarFile

        MOV AH, 10h
        INT 16h

        MOV AX, 03h
        INT 10h

        CicloAnimaciones:
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

            CMP paginaActual, 4 ; * Salto A Pagina 5
            JZ EtAnimacion5Aux

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
            EtAnimacion5Aux:
                JMP EtAnimacion5

            ; * Invocacion Animacion 1
            EtAnimacion1:
                Animacion1 charsPerRow1, cantRows1, bufferImagen1
                JMP CicloAnimaciones

            ; * Invocacion Animacion 2
            EtAnimacion2:
                Animacion2 charsPerRow2, cantRows2, bufferImagen2
                JMP CicloAnimaciones

            ; * Invocacion Animacion 3
            EtAnimacion3:
                Animacion3 charsPerRow3, cantRows3, bufferImagen3
                JMP CicloAnimaciones

            ; * Invocacion Animacion 4
            EtAnimacion4:
                Animacion4 charsPerRow4, cantRows4, bufferImagen4
                JMP CicloAnimaciones

            EtAnimacion5:
                Animacion1 charsPerRow5, cantRows5, bufferImagen5
                JMP CicloAnimaciones
                
        Salir:
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END
