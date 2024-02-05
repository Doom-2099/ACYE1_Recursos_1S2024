// * Title: Comunicacion Serial
// * Auth: Jorge Castañeda
// * Date: 27.01.24

void setup() {
  /* 
  * Se inicializa el puerto serial a 9600 baudios
  * baudios -> bits/seg
  */
  Serial.begin(9600);
}

void loop() {
  // ! Serial.available() -> verificar si el buffer
  // ! contiene informacion disponible para ser leida 
  if(Serial.available()){ // * Existen bytes disponibles para leer?
    String cadena = Serial.readString(); // * Se leen los bytes disponibles y se almacenan en una variable tipo String

    Serial.print("Cadena Leida: "); // * Imprimir mensaje guia
    Serial.println(cadena); // * Imprimir cadena leida
  }

  delay(500); // * Se define una espera de medio segundo o 500 ms.
}
