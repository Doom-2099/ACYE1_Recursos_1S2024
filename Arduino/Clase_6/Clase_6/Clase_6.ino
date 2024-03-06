/* #include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x20, 16, 2); */

int flag = 0;

void setup() {
  DDRC = B001111;
  DDRB = B001111;

  PORTC = B000000;
  PORTB = B000000;

  /* pinMode(5, OUTPUT);
  pinMode(6, OUTPUT); */

  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);

  /* lcd.init();
  lcd.backlight();

  lcd.setCursor(0, 0);
  lcd.print("PORTS AND ISR");
  lcd.setCursor(0, 1);
  lcd.print("CLASE 6"); */

  attachInterrupt(0, execISR1, RISING);
  attachInterrupt(digitalPinToInterrupt(3), execISR2, CHANGE);
}

void loop() {
  if (flag == 1) {
    convertBCD();

    /* lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(" -> ISR 1 <- "); */

    flag = 0;
  } else if (flag == 2) {
    /* lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(" -> ISR 2 <- "); */

    convertBCD();

    flag = 0;
  }
}

void execISR1() {
  /* digitalWrite(5, LOW);
  digitalWrite(6, HIGH); */

  flag = 1;

  /* digitalWrite(5, HIGH);
  digitalWrite(6, LOW); */
}

void execISR2() {
  /* digitalWrite(5, LOW);
  digitalWrite(6, HIGH); */

  flag = 2;

  /* digitalWrite(5, HIGH);
  digitalWrite(6, LOW); */
}

void convertBCD() {
  int valor = random(0, 99);
  int decenas;
  int unidades;
  int decenasBin[4];
  int unidadesBin[4];

  decenas = valor / 10;
  for (int i = 0; i < 4; i++) {
    decenasBin[i] = decenas % 2;
    decenas = decenas / 2;
  }

  unidades = valor % 10;
  for (int i = 0; i < 4; i++) {
    unidadesBin[i] = unidades % 2;
    unidades = unidades / 2;
  }

  for (int i = 3; i > -1; i--) {
    if (decenasBin[i] == 1)
      PORTB |= (1 << i);
    else
      PORTB &= ~(1 << i);
  }

  for (int i = 3; i > -1; i--) {
    if (unidadesBin[i] == 1)
      PORTC |= (1 << i);
    else
      PORTC &= ~(1 << i);
  }
}
