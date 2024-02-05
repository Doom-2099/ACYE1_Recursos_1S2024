void setup() {
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);

}

// CONECTAR LCD CON I2C
// MOTOR STEPPER

void loop() {
  analogWrite(10, 255);
  analogWrite(9, 175);
  
  digitalWrite(4, HIGH);
  digitalWrite(5, LOW);
  digitalWrite(6, HIGH);
  digitalWrite(7, LOW);

}
