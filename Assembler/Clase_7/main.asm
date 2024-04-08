LimpiarConsola MACRO
    MOV AX, 03h
    INT 10h
ENDM

Print MACRO registro
    LEA DX, registro
    MOV AH, 09h
    INT 21h
ENDM

GetOpcion MACRO
    MOV AH, 01h
    INT 21h

    MOV op, AL
ENDM

ImprimirTablero MACRO
    LOCAL fila, columna
    XOR BX, BX
    XOR SI, SI

    Print columnas
    MOV CL, 0

    fila:
        Print salto
        MOV AH, 02h
        MOV DL, filas[BX]
        INT 21h

        MOV DL, 32
        INT 21h

        columna:
            MOV DL, tablero[SI]
            INT 21h

            MOV DL, 124
            INT 21h

            INC CL
            INC SI

            CMP CL, 8
            JB columna

            MOV CL, 0
            INC BX
            CMP BX, 8
            JB fila
ENDM

LlenarTablero MACRO
    LOCAL llenarPeon1, llenarPeon2, Piezas1, Piezas2
    MOV SI, 0
    MOV CH, 0 ; Contador para los peones

    Piezas1:
        MOV SI, 0

        MOV DX, 116
        MOV tablero[SI], DL
        PUSH DX
        INC SI

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

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

        POP DX
        MOV tablero[SI], DL
        INC SI

    llenarPeon1:
        MOV tablero[SI], 112
        INC SI
        INC CH

        CMP CH, 8
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

AbrirArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinAbrirArchivo
    MOV AH, 3Dh
    MOV AL, 00h
    LEA DX, nombreArchivo
    INT 21h

    MOV handler, AX
    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinAbrirArchivo

    ManejarError:
        Print salto
        Print errorAbrirArchivo
        GetOpcion
    
    FinAbrirArchivo:
ENDM

CrearArchivo MACRO nombreArchivo, handler
    LOCAL ManejarError, FinCrearArchivo
    MOV AH, 3Ch
    MOV CX, 00h
    LEA DX, nombreArchivo
    INT 21h

    MOV handler, AX
    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCrearArchivo

    ManejarError:
        Print salto
        Print errorCrearArchivo
        GetOpcion
    
    FinCrearArchivo:
ENDM

EscribirArchivo MACRO cadena, handler
    LOCAL ManejarError, FinEscribirArchivo
    MOV AH, 40h
    MOV BX, handler
    MOV CX, 56
    LEA DX, cadena
    INT 21h

    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinEscribirArchivo

    ManejarError:
        Print salto
        Print errorEscribirArchivo
        GetOpcion

    FinEscribirArchivo:
ENDM

LeerArchivo MACRO buffer, handler
    LOCAL ManejarError, FinLeerArchivo
    MOV AH, 3Fh
    MOV BX, handler
    MOV CX, 40
    LEA DX, buffer
    INT 21h

    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    Print salto
    Print buffer
    GetOpcion
    JMP FinLeerArchivo

    ManejarError:
        Print salto
        Print errorLeerArchivo
        GetOpcion

    FinLeerArchivo:
ENDM

CerrarArchivo MACRO handler
    LOCAL ManejarError, FinCerrarArchivo
    MOV AH, 3Eh
    MOV BX, handler
    INT 21h

    RCL BL, 1
    AND BL, 1
    CMP BL, 1
    JE ManejarError
    JMP FinCerrarArchivo

    ManejarError:
        Print salto
        Print errorCerrarArchivo
        GetOpcion

    FinCerrarArchivo:
ENDM

.MODEL small

.STACK 64h

.DATA
    salto db 10, 13, "$"
    mensajeInicial db "Universidad De San Carlos De Guatemala", 10, 13, "Facultad De Ingenieria", 10, 13, "Jorge Casta", 164, "eda", 10, 13, "$"
    mensajeSalida db "Saliendo Del Programa...", "$"
    menuPrincipal db "1. Nuevo Juego", 10, 13, "2. Puntajes", 10, 13, "3. Reportes", 10, 13, "4. Salir", 10, 13, ">> Ingrese Una Opcion Valida: ", "$"
    Jugador1 db "Jorge", "$"
    Jugador2 db "IA", "$"
    TurnoJugador db "Turno: "
    turno db 1
    op db 1 dup("$")
    filaJugador db 1 dup("$")
    columnaJugador db 1 dup("$")
    tablero db 64 dup(32) ; sustituir por 40h
    columnas db "  A B C D E F G H","$"
    filas db "12345678","$"
    handlerArchivo dw ?
    nombreArchivo db "TestFile.txt", 00h
    errorAbrirArchivo db "Ocurrio Un Error Al Abrir Archivo", "$"
    errorCrearArchivo db "Ocurrio Un Error Al Crear Archivo", "$"
    errorEscribirArchivo db "Ocurrio Un Error Al Escribir Archivo", "$"
    errorLeerArchivo db "Ocurrio Un Error Al Cerrar Archivo", "$"
    errorCerrarArchivo db "Ocurrio Un Error Al Cerrar Archivo", "$"
    contentArchivo db "Este es un texto de prueba para escribir en los archivos"
    archivoSuccesful db "El Archivo Se Creo Correctamente", "$"
    buffer db 300 dup("$")

.CODE
    ;Metodo Main(Principal) del programa
    MOV AX, @data
    MOV DS, AX

    Main PROC
        Menu:
            LimpiarConsola
            Print mensajeInicial
            Print menuPrincipal
            GetOpcion

            CMP op, 31h
            JE PrintTablero

            CMP op, 32h
            JE MostarPuntajes

            CMP op, 33h
            JE AuxGenerarReportes

            CMP op, 34h
            JE AuxSalir
            JMP Menu

        AuxGenerarReportes:
            JMP GenerarReportes

        AuxSalir:
            JMP Salir
        
        MostarPuntajes:
            JMP Menu

        PrintTablero:
            LimpiarConsola
            LlenarTablero
            ImprimirTablero
            Print salto
            GetOpcion
            JMP Menu

        AuxMenu3:
            JMP Menu

        GenerarReportes:
            MOV op, 0

            CrearArchivo nombreArchivo, handlerArchivo
            CMP op, 13
            JE AuxMenu3

            EscribirArchivo contentArchivo, handlerArchivo
            CMP op, 13
            JE AuxMenu2

            CerrarArchivo handlerArchivo
            CMP op, 13
            JE AuxMenu2
            JMP ContinuarArchivos

            ; CREAR/ABRIR
            ; ESCRIBIR/LEER
            ; CERRAR
        
        AuxMenu2:
            JMP Menu

        ContinuarArchivos:
            Print salto
            Print archivoSuccesful
            GetOpcion
            AbrirArchivo nombreArchivo, handlerArchivo
            CMP op, 13
            JE AuxMenu2

            LeerArchivo buffer, handlerArchivo
            CMP op, 13
            JE AuxMenu

            CerrarArchivo handlerArchivo
            CMP op, 13
            JE AuxMenu

        AuxMenu:
            JMP Menu

        Salir:
            Print salto
            Print mensajeSalida
            MOV AX, 4C00h
            INT 21h
    Main ENDP
END