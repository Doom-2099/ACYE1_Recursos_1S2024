// * Title: Pines Digitales y Analogicos
// * Auth: Jorge Castañeda
// * Date: 27.01.24

void setup() {
  pinMode(2, INPUT); // * Definir pin 2 como entrada
  pinMode(3, OUTPUT); // * Definir pin 3 como salida

  Serial.begin(9600); // * Inicializar el puerto serial
}

void loop() {
  // ! digitalRead(2) -> leer el estado del pin digital 2
  if(digitalRead(2) == 1) { // * El pin digital 2 tiene un estado alto?
    digitalWrite(3, LOW); // * escribir estado bajo en el pin digital 3
  } else {
    digitalWrite(3, HIGH); // * escribir estado alto en el pin digital 3
  }

  int lectura = analogRead(A0); // * realizar lectura del pin analogico A0

  Serial.print("Lectura Potenciometro: "); // * mensaje guia 
  Serial.println(lectura); // * imprimir valor de la lectura del pin analogico A0

  delay(500); // * definimos una espera de medio segundo o  500 ms
}
