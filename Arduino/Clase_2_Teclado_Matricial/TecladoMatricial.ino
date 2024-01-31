#include <Key.h>
#include <Keypad.h>

const byte filas = 4;
const byte columnas = 4;

char teclas[filas][columnas] = {
  {'7', '8', '9', '/'},
  {'4', '5', '6', '*'},
  {'1', '2', '3', '-'},
  {'C', '0', '=', '+'}
};

byte filasPines[filas] = {5, 4, 3, 2};
byte columnasPines[columnas] = {11, 10, 9, 8};

Keypad teclado = Keypad(makeKeymap(teclas), filasPines, columnasPines, filas, columnas);


void setup() {
  Serial.begin(9600);
}

void loop() {

  char teclaIngresada = teclado.getKey();

  if(teclaIngresada){
    Serial.print("Tecla Presionada: ");
    Serial.println(teclaIngresada);
  }
  

}
