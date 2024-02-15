#include <Wire.h>

long startTimer;
long endTimer;

void setup() {
  Wire.begin();

  Serial.begin(115200);
  Serial.println("USING BUS I2C");

  delay(200);
  startTimer = millis();
}

void loop() {

  endTimer = millis();

  if ((endTimer - startTimer) >= 25000) {
    Wire.requestFrom(9, 20);
    Serial.println("SOLICITANDO DATOS AL ESCLAVO\nCON DIRECCION -> 9");
    Serial.println("------------------");

    while (Wire.available()) {
      char c = Wire.read();

      if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) {
        Serial.print(c);
      } else if (c == '%' || c == ' ' || c == ':') {
        Serial.print(c);
      } else {
        break;
      }
    }

    Serial.println("\n-----------------");
    startTimer = millis();
  }

  if (Serial.available() > 0) {
    Serial.println("----------\nENVIANDO MENSAJE AL SLAVE");

    String inputString = Serial.readStringUntil('\n');

    char buffer[inputString.length() + 1];
    inputString.toCharArray(buffer, sizeof(buffer));

    Serial.print("CADENA ENVIADA: ");
    Serial.println(buffer);
    Serial.println("------------------------");

    Wire.beginTransmission(9);
    Wire.print(buffer);
    Wire.endTransmission();

    delay(100);
  }
}
