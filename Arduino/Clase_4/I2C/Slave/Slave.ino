#include <Wire.h>


char message[25];
String buffer;

const int selectHumedad = 5;    // * A1
const int selectFotocelda = 6;  // * A0
bool flagSensor = true;         // * => TRUE: HUMEDAD | FALSE: FOTOCELDA


void setup() {
  pinMode(selectHumedad, INPUT);
  pinMode(selectFotocelda, INPUT);

  Wire.begin(9);
  Wire.onRequest(requestEvent);
  Wire.onReceive(receiveData);

  Serial.begin(9600);
  Serial.println("USING BUS I2C");

  delay(200);
}

void loop() {
  if (digitalRead(selectHumedad)) {
    flagSensor = true;
  }

  if (digitalRead(selectFotocelda)) {
    flagSensor = false;
  }

  delay(100);
}

void requestEvent() {
  if (flagSensor) {
    int humedad = map(analogRead(A0), 0, 1023, 0, 100);
    buffer = "HUMEDAD: ";
    buffer += humedad;
    buffer += "%";
  } else {
    int fotocelda = map(analogRead(A1), 0, 1023, 0, 100);
    buffer = "LUMINOSIDAD: ";
    buffer += fotocelda;
    buffer += "%";
  }

  Wire.print(buffer);
  Serial.print("=> RESPUESTA A LA PETICION: ");
  Serial.println(buffer);
  Serial.println("----- FIN RESPUESTA ------");
}

void receiveData() {
  Serial.println("--------------\n=> RECIBIENDO DATOS\n-------------");
  int index = 0;

  while (Wire.available()) {
    char c = Wire.read();
    message[index] = c;
    index++;
  }

  message[index] = '\0';
  Serial.println(message);

  Serial.println("-----------------");

}
