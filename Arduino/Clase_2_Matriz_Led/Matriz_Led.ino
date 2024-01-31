#include <MD_Parola.h>
#include <MD_MAX72xx.h>
#include <SPI.h>

#define HARDWARE_TYPE MD_MAX72XX::FC16_HW
#define MAX_DEV 3
#define DATA 10
#define CS 9
#define CLK 8

String mensaje = "Hola Mundo !!!";

MD_Parola MATRICES = MD_Parola(HARDWARE_TYPE, DATA, CLK, CS, MAX_DEV);


void setup() {
  MATRICES.begin();
  MATRICES.setIntensity(5);
  MATRICES.displayClear();
  MATRICES.displayText(mensaje.c_str(), PA_LEFT, 100, 0, PA_SCROLL_LEFT, PA_SCROLL_LEFT);
}

void loop() {
  
  int velocidad = map(25, 1023, 0, 400, 15);
  MATRICES.setSpeed(velocidad);
  MATRICES.setTextEffect(PA_SCROLL_LEFT, PA_SCROLL_LEFT);

  if(MATRICES.displayAnimate()){
    MATRICES.displayClear();
    MATRICES.displayReset();
  }

  
}
