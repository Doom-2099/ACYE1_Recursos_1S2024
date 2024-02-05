#include <DHT_U.h>
#include <DHT.h>

#include <LiquidCrystal.h>

int echo = 6;
int trigger = 5;
int temp = 4;
int O3 = 1;
int O2 = 2;
int O1 = 3;
int mov = 0;

long startTimerTemp;
long endTimerTemp;
long startTimerDist;
long endTimerDist;
long temperatura;
long humedad;

DHT sensorTemp = DHT(temp, DHT11);
LiquidCrystal lcd = LiquidCrystal(8, 9, 10, 11, 12, 13);

void setup() {
  pinMode(echo, INPUT);
  pinMode(trigger, OUTPUT);
  pinMode(O1, OUTPUT);
  pinMode(O2, OUTPUT);
  pinMode(O3, OUTPUT);
  pinMode(mov, INPUT);

  sensorTemp.begin();
  lcd.begin(16, 2);
  lcd.clear();

  startTimerTemp = millis();
  startTimerDist = millis();
}

void loop() {
  if (digitalRead(mov)) {
    lcd.setCursor(0, 1);
    lcd.print("MOV: ACTIVO    ");
  } else {
    lcd.setCursor(0, 1);
    lcd.print("MOV: INACTIVO");
  }

  endTimerTemp = millis();

  if ((endTimerTemp - startTimerTemp) >= 1500) {
    temperatura = sensorTemp.readTemperature();
    humedad = sensorTemp.readHumidity();

    lcd.setCursor(0, 0);
    lcd.print("T: ");
    lcd.print((String)temperatura);
    lcd.print("C");
    lcd.print(" H: ");
    lcd.print((String)humedad);
    lcd.print("%   ");
    delay(500);

    if ((temperatura < 15) || (temperatura > 35)) {
      digitalWrite(O3, HIGH);
      digitalWrite(O2, LOW);
      digitalWrite(O1, LOW);
    } else if ((temperatura >= 15) && (temperatura < 24)) {
      digitalWrite(O3, LOW);
      digitalWrite(O2, HIGH);
      digitalWrite(O1, LOW);
    } else {
      digitalWrite(O3, LOW);
      digitalWrite(O2, LOW);
      digitalWrite(O1, HIGH);
    }

    startTimerTemp = millis();
  }

  endTimerDist = millis();
  if ((endTimerDist - startTimerDist) >= 1500) {
    calcularDistancia();

    startTimerDist = millis();
  }

}

void calcularDistancia() {
  digitalWrite(trigger, HIGH);
  delay(1);
  digitalWrite(trigger, LOW);
  int duracion = pulseIn(echo, HIGH);
  int distancia = duracion / 58.2;
  
  lcd.setCursor(0, 0);
  lcd.write("D: ");
  lcd.print((String)distancia);
  lcd.write(" cm         ");
  delay(500);
}
