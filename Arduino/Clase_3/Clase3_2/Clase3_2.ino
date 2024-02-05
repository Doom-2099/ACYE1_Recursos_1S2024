#include <Servo.h>

Servo servo1;
Servo servo2;

int posServo1 = 0;
int posServo2 = 0;

void setup() {
  pinMode(7, OUTPUT);
  pinMode(4, INPUT);
  pinMode(3, INPUT);

  servo1.attach(6);
  servo2.attach(5);

}

void loop() {
  if (digitalRead(3)) {
    int val = analogRead(A1);
    val = map(val, 0, 1023, 0, 180);
    servo1.write(val);
    delay(15);
  } else {
    if (digitalRead(4) && posServo2 == 0) {
      for (posServo2 = 0; posServo2 <= 90; posServo2 += 1) {
        servo2.write(posServo2);
        delay(15);
      }

      posServo2 = 90;
    } else if (digitalRead(4) && posServo2 >= 90) {
      for (posServo2 = 90; posServo2 >= 0; posServo2 -= 1) {
        servo2.write(posServo2);
        delay(15);
      }

      posServo2 = 0;
    }
  }

  int lectura = analogRead(A0);
  if (lectura < 512) {
    digitalWrite(7, HIGH);
  } else {
    digitalWrite(7, LOW);
  }


}
