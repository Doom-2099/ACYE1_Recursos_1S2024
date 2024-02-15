#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <DHT.h>
#include <DHT_U.h>

#define STASSID "ARRIS-BDE5"   // * NOMBRE DE LA RED A LA QUE SE CONECTARA
#define STAPSK "BUL7B9337439"  // * PASSWORD DE LA RED A LA QUE SE CONECTARA
#define PORT 3000              // * PUERTO DONDE SE ABRIRA EL SERVIDOR

const char* SSID = STASSID;
const char* PASS = STAPSK;

const int dhtPin = 0;
const int led = 4;
const int buzzer = 5;
const int okLed = 13;   // * OK
const int notLed = 12;  // * NOT
bool flag = false;
IPAddress ip;

DHT dhtSensor(dhtPin, DHT11);
ESP8266WebServer server(PORT);  // * INICIALIZAR SERVIDOR EN EL PUERTO 8080

// TODO: FUNCIONES HANDLER DE LAS RUTAS DEL SERVER
void handleRoot() {  // * MANEJADOR RUTA /
  String data = "{ \"Red\": \"";
  data.concat(SSID);
  data.concat("\", \"IP\": \"");
  data.concat(ip.toString());
  data.concat("\"}");

  server.send(200, "application/json", data);
}

void handleLed() {  // * MANEJADOR RUTA /led
  if (flag) {
    digitalWrite(led, LOW);
    flag = false;
  } else {
    digitalWrite(led, HIGH);
    flag = true;
  }

  String response = "{ \"Value\": \"";
  response.concat((String)flag);
  response.concat("\" }");

  server.send(200, "application/json", response);
}

void handleTemperature() {  // * MANEJADOR RUTA /temperature

  float temperatura = dhtSensor.readTemperature();
  float humedad = dhtSensor.readHumidity();

  String response = "{ \"Temperature\": \"";
  response.concat((String)temperatura);
  response.concat("\", \"Humidity\": \"");
  response.concat((String)humedad);
  response.concat("\" }");

  server.send(200, "application/json", response);

  if (temperatura > 27) {
    int startTimer = millis();
    int endTimer = millis();
    while ((endTimer - startTimer) < 5000) {
      digitalWrite(buzzer, HIGH);
      delay(100);
      digitalWrite(buzzer, LOW);
      delay(100);
      endTimer = millis();
    }
  }
}

void setup() {
  pinMode(led, OUTPUT);
  pinMode(okLed, OUTPUT);
  pinMode(notLed, OUTPUT);
  pinMode(buzzer, OUTPUT);

  digitalWrite(led, LOW);
  digitalWrite(okLed, LOW);
  digitalWrite(notLed, LOW);
  digitalWrite(buzzer, LOW);

  dhtSensor.begin();
  delay(3000);

  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);

  // * ESPERAR POR LA CONEXION A LA RED WIFI
  while (WiFi.status() != WL_CONNECTED) {  // * VALIDAR QUE LA CONEXION SE REALIZO CORRECTAMENTE.
    delay(500);
    Serial.print(".");
    digitalWrite(notLed, HIGH);
  }

  digitalWrite(notLed, LOW);
  digitalWrite(okLed, HIGH);

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(SSID);  // * NOMBRE DE LA RED A LA QUE SE HA CONECTADO
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());  // * OBTENER LA DIRECCION IP ASIGNADA
  ip = WiFi.localIP();

  // * DECLARACION DE LAS RUTAS DEL SERVIDOR
  server.on("/", handleRoot);

  server.on("/led", handleLed);

  server.on("/temperature", handleTemperature);

  server.begin();
  Serial.print("HTTP server started in port: ");
  Serial.println(PORT);
}

void loop() {
  server.handleClient();
}
