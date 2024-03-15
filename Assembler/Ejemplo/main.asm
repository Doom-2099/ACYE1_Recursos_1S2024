LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h
ENDM

ImprimirCadenas MACRO registroPrint
    MOV AH, 09h
    LEA DX, registroPrint
    INT 21h
ENDM

obtenerOpcion MACRO regOpcion
    MOV AH, 01h
    INT 21h

    MOV regOpcion, AL
ENDM

ImprimirTableroJuego MACRO
    LOCAL fila, columna

    MOV BX, 0 ; Indice del indicador de filas -> Inicia en 0
    XOR SI, SI ; Indice para el tablero -> Inicia en 0

    ImprimirCadenas indicadorColumnas
    MOV CL, 0 ; Contador de columnas

    fila:
        ImprimirCadenas salto
        MOV AH, 02h ; Codigo Interrupcion para imprimir un caracter
        MOV DL, indicadorFilas[BX] ; Caracter a imprimir
        INT 21h ; Llamar Interrupcion

        MOV DL, 32 ; Caracter del espacio en blanco
        INT 21h

        columna:
            MOV DL, tablero[SI] ; Caracter del tablero
            INT 21h

            MOV DL, 124 ; Caracter |
            INT 21h

            INC CL ; Incrementamos CL en 1 -> CL++
            INC SI ; Incrementamos SI en 1 -> SI++

            CMP CL, 8 ; Si no ha pasado por las 8 columnas que regrese a la etiqueta 'columna'
            JB columna ; Salto a columna

            MOV CL, 0 ; Reiniciar Contador de columnas
            INC BX ; Incrementar indice indicador de filas -> BX++
            
            CMP BX, 8 ; Si no ha pasado por todas las filas que regrese a la etiqueta 'fila'
            JB fila
ENDM

LlenarTablero MACRO
    LOCAL llenarPeon1, llenarPeon2, Piezas1, Piezas2

    MOV SI, 0 ; Indice del tablero
    MOV CH, 0 ; Contador de peones

    Piezas1:
        MOV DX, 116 ; Caracter a guardar en el tablero
        MOV tablero[SI], DL ; Escribir caracter en el tablero
        PUSH DX ; Guardamos el registro en la pila
        INC SI ; Incrementamos indice de tablero -> SI++

        MOV DX, 99
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 97
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 114
        MOV tablero[SI], DL
        INC SI

        MOV DX, 35
        MOV tablero[SI], DL
        INC SI

        POP DX ; Extraemos registro de la pila y lo almacenamos en DX
        MOV tablero[SI], DL ; Escribimos caracter en el tablero
        INC SI ; Incrementamos indice de tablero -> SI++

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI
    
    llenarPeon1:
        MOV tablero[SI], 112 ; Escribir caracter en tablero
        INC SI ; Incrementamos indice del tablero
        INC CH ; Incrementamos contador de peones

        CMP CH, 8 ; Si es menor a 8 que regrese a la etiqueta 'llenarPeon1', caso contrario continua
        JB llenarPeon1

        MOV CH, 0
        MOV SI, 48

    llenarPeon2:
        MOV tablero[SI], 80
        INC SI
        INC CH

        CMP CH, 8
        JB llenarPeon2

    Piezas2:
        MOV DX, 84
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 67
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 65
        MOV tablero[SI], DL
        PUSH DX
        INC SI

        MOV DX, 82
        MOV tablero[SI], DL
        INC SI

        MOV DX, 42
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI
ENDM

CrearArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinCrearArchivo
    MOV AH, 3Ch ; Codigo interrupcion
    MOV CX, 00h ; Atributo del archivo
    LEA DX, nombreArchivo ; Nombre del archivo
    INT 21h

    MOV handler, AX ; capturar el handler asignado al archivo (16 bits)
    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCrearArchivo

    ManejarError:
        ImprimirCadenas salto
        ImprimirCadenas errorCrearArchivo
        obtenerOpcion opcion

    FinCrearArchivo:
ENDM

AbrirArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinAbrirArchivo
    MOV BL, 0

    MOV AH, 3Dh ; codigo de interrupcion
    MOV AL, 00h ; modo de apertura del archivo, 0 -> Lectura | 1 -> Escritura | 2 -> Lectura/Escritura
    LEA DX, nombreArchivo ; Nombre del archivo
    INT 21h

    MOV handler, AX ; Capturar el handler asignado al archivo (16 bits)
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinAbrirArchivo

    ManejarError:
        ImprimirCadenas salto
        ImprimirCadenas errorAbrirArchivo
        obtenerOpcion opcion

    FinAbrirArchivo:
ENDM

CerrarArchivo MACRO handler
    LOCAL ManejarError, FinCerrarArchivo

    MOV AH, 3Eh ; Codigo de interrupcion
    MOV BX, handler ; handler del archivo
    INT 21h

    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCerrarArchivo

    ManejarError:
        ImprimirCadenas salto
        ImprimirCadenas errorCerrarArchivo
        obtenerOpcion opcion

    FinCerrarArchivo:
ENDM

LeerArchivo MACRO buffer, handler
    LOCAL ManejarError, FinLeerArchivo

    MOV AH, 3Fh ; Codigo de interrupcion
    MOV BX, handler ; handler del archivo
    MOV CX, 300 ; Cantidad de bytes que se van a leer
    LEA DX, buffer ; Posicion en memoria del buffer donde se almacenara el texto leido
    INT 21h

    MOV BL, 0
    RCL BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinLeerArchivo

    ManejarError:
        ImprimirCadenas salto
        ImprimirCadenas errorLeerArchivo
        obtenerOpcion opcion
    
    FinLeerArchivo:
ENDM

EscribirArchivo MACRO cadena, handler
    LOCAL ManejarError, FinEscribirArchivo

    MOV AH, 40h ; Codigo de interrupcion
    MOV BX, handler ; Handler de archivo
    MOV CX, 120 ; Cantidad de bytes que se van a escribir
    LEA DX, cadena1 ; Direccion de la cadena a escribir
    INT 21h

    RCL BL, 1 ; Capturar el bit de CF en el registro BL
    AND BL, 1 ; Validar que en BL quede un 1 o 0
    CMP BL, 1 ; Verificar si no hay codigo de error
    JE ManejarError
    JMP FinEscribirArchivo

    ManejarError:
        ImprimirCadenas salto
        ImprimirCadenas errorEscribirArchivo
        obtenerOpcion opcion
    
    FinEscribirArchivo:
ENDM

PosicionarApuntador MACRO handler
    MOV AH, 42h ; Codigo Interrupcion
    MOV AL, 02h ; Modo de posicionamiento
    MOV BX, handler ; handler archivo
    MOV CX, 00h ; offset mas significativo
    MOV DX, 00h ; offset menos significativo
    INT 21h

    ; Capturar Error
ENDM

.MODEL small

.STACK 64h

.DATA
    salto db 10, 13, "$" ; \n
    mensajeInicio db " Universidad De San Carlos De Guatemala", 10, 13, " Facultad De Ingenieria", 10, 13, " ECYS", 10, 13, "$"
    mensajeMenu db " 1. Nuevo Juego", 10, 13, " 2. Puntajes", 10, 13, " 3. Reportes", 10, 13, " 4. Salir", 10, 13, " >> Ingrese Una Opcion: ", "$"
    opcion db 1 dup(32)
    indicadorColumnas db "  A B C D E F G H", "$"
    indicadorFilas db "12345678", "$"
    tablero db 64 dup(32) ; ROW-MAJOR O COLUMN-MAJOR
    handlerArchivo dw ? ; Handler o manejador del archivo de 16 bits
    nombreArchivo db "TestFile.txt", 00h ; Nombre del archivo, DEBE TERMINAR EN CARACTER NULO
    errorCrearArchivo db "Ocurrio Un Error Al Crear El Archivo", "$"
    errorAbrirArchivo db "Ocurrio Un Error Al Abrir El Archivo", "$"
    errorCerrarArchivo db "Ocurrio Un Error Al Cerrar Archivo", "$"
    errorLeerArchivo db "Ocurrio Un Error Al Leer Archivo", "$"
    errorEscribirArchivo db "Ocurrio Un Error Al Escribir Archivo", "$"
    contentArchivo db "Este es un texto de prueba para escribir en los archivos"
    archivoCreado db 10, 13, "El Archivo Se Creo Correctamente", "$"
    buffer db 300 dup("$") ; Buffer para almacenar el contenido leido de un archivo

.CODE
    MOV AX, @data
    MOV DS, AX

    ; Metodo Principal (Main)
    Main PROC
        LimpiarConsola
        ImprimirCadenas mensajeInicio

        Menu:
            ImprimirCadenas mensajeMenu
            obtenerOpcion opcion ; Obtener La Opcion Que El Usuario Elige

            CMP opcion, 49 ; Estimulando el registro de banderas
            JE ImprimirTablero

            CMP opcion, 51
            JE ImprimirAuxReportes

            CMP opcion, 52
            JE AuxSalir2
            JMP Menu

        AuxSalir2:
            JMP Salir

        ImprimirAuxReportes:
            JMP ImprimirReportes

        ImprimirTablero:
            LimpiarConsola
            LlenarTablero
            ImprimirTableroJuego
            obtenerOpcion opcion
            JMP Menu

        AuxSalir: ; Etiquetas auxiliar para los saltos cortos o relativos
            JMP Salir

        ImprimirReportes:
            CrearArchivo nombreArchivo, handlerArchivo
            CMP opcion, 13  ; Verificar que no hay ningun error
            JE AuxSalir

            PosicionarApuntador handler
            EscribirArchivo contentArchivo, handlerArchivo
            CMP opcion, 13  ; Verificar que no hay ningun error
            JE AuxSalir4

            CerrarArchivo handlerArchivo
            CMP opcion, 13  ; Verificar que no hay ningun error
            JE AuxSalir4
            JMP ContinuarArchivos
        
        AuxSalir4:
            JMP Salir

        ContinuarArchivos:
            ImprimirCadenas archivoCreado
            obtenerOpcion opcion

            AbrirArchivo nombreArchivo, handlerArchivo
            CMP opcion, 13  ; Verificar que no hay ningun error
            JE AuxSalir4

            LeerArchivo buffer, handlerArchivo
            CMP opcion, 13  ; Verificar que no hay ningun error
            JE Salir

            CerrarArchivo handlerArchivo
            CMP opcion, 13 ; Verificar que no hay ningun error
            JE Salir
        
        Salir:
            ImprimirCadenas buffer
            MOV AX, 4C00h ; Interrupcion Para Terminar Programa
            INT 21h
    Main ENDP
END