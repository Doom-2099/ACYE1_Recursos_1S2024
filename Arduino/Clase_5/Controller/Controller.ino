#include <Wire.h>

const int pinHabitacion1 = 2;  // ? ID: 1
const int pinHabitacion2 = 3;  // ? ID: 2
const int pinSala = 4;         // ? ID: 3
const int pinCocina = 5;       // ? ID: 4
const int pinGarage = 6;       // ? ID: 5
const int pinJardin = 7;       // ? ID: 6

bool stateHabitacion1 = false;
bool stateHabitacion2 = false;
bool stateSala = false;
bool stateCocina = false;
bool stateGarage = false;
bool stateJardin = false;

void setup() {
  pinMode(pinHabitacion1, OUTPUT);
  pinMode(pinHabitacion2, OUTPUT);
  pinMode(pinSala, OUTPUT);
  pinMode(pinCocina, OUTPUT);
  pinMode(pinGarage, OUTPUT);
  pinMode(pinJardin, OUTPUT);

  digitalWrite(pinHabitacion1, LOW);
  digitalWrite(pinHabitacion2, LOW);
  digitalWrite(pinSala, LOW);
  digitalWrite(pinCocina, LOW);
  digitalWrite(pinGarage, LOW);
  digitalWrite(pinJardin, LOW);

  Wire.begin(9);
  Wire.onReceive(handleIlumination);
  delay(300);
}

void loop() {
  delay(100);
}

void handleIlumination() {
  if (Wire.available()) {
    int id = Wire.read();
    
    controlIlumination(id);
  }
}

void controlIlumination(int id) {
  switch (id) {
    case 49:
      stateHabitacion1 = !stateHabitacion1;
      digitalWrite(pinHabitacion1, stateHabitacion1);
      break;
    case 50:
      stateHabitacion2 = !stateHabitacion2;
      digitalWrite(pinHabitacion2, stateHabitacion2);
      break;
    case 51:
      stateSala = !stateSala;
      digitalWrite(pinSala, stateSala);
      break;
    case 52:
      stateCocina = !stateCocina;
      digitalWrite(pinCocina, stateCocina);
      break;
    case 53:
      stateGarage = !stateGarage;
      digitalWrite(pinGarage, stateGarage);
      break;
    case 54:
      stateJardin = !stateJardin;
      digitalWrite(pinJardin, stateJardin);
      break;
  }
}