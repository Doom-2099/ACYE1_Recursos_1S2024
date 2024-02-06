#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x20, 16, 2);

void setup() {
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);

  pinMode(8, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);

  lcd.begin(16, 2, 0x20);
  lcd.backlight();

  lcd.setCursor(0, 0);
  lcd.print("USANDO I2C");
  lcd.setCursor(0, 1);
  lcd.print("EJ 3 - CLASE3");

  delay(5000);
  lcd.clear();
}


void loop() {
  int vel_dc1 = map(analogRead(A0), 0, 1023, 0, 255);
  int vel_dc2 = map(analogRead(A1), 0, 1023, 0, 255);

  analogWrite(10, vel_dc1);
  analogWrite(9, vel_dc2);

  if (digitalRead(2)) {
    seqStepper();
  }

  lcd.setCursor(0, 1);
  lcd.print("DC1:");
  lcd.print(vel_dc1);
  lcd.print(" DC2:");
  lcd.print(vel_dc2);
  lcd.print("   ");

  if (digitalRead(3)) {
    lcd.setCursor(0, 0);
    lcd.print("IZQUIERDA");

    digitalWrite(4, HIGH);
    digitalWrite(5, LOW);
    digitalWrite(6, HIGH);
    digitalWrite(7, LOW);
  } else {
    lcd.setCursor(0, 0);
    lcd.print("DERECHA      ");
    digitalWrite(4, LOW);
    digitalWrite(5, HIGH);
    digitalWrite(6, LOW);
    digitalWrite(7, HIGH);
  }
}


void seqStepper() {
  digitalWrite(8, HIGH);
  digitalWrite(11, LOW);
  digitalWrite(12, LOW);
  digitalWrite(13, LOW);

  delay(200);

  digitalWrite(8, LOW);
  digitalWrite(11, HIGH);
  digitalWrite(12, LOW);
  digitalWrite(13, LOW);

  delay(200);

  digitalWrite(8, LOW);
  digitalWrite(11, LOW);
  digitalWrite(12, HIGH);
  digitalWrite(13, LOW);

  delay(200);
  
  digitalWrite(8, LOW);
  digitalWrite(11, LOW);
  digitalWrite(12, LOW);
  digitalWrite(13, HIGH);

  delay(200);
}
