#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <Wire.h>
#include <DHT.h>
#include <DHT_U.h>


#define STASSID "dlink"   // * NOMBRE DE LA RED A LA QUE SE CONECTARA
#define STAPSK "contrasenadsi104."  // * PASSWORD DE LA RED A LA QUE SE CONECTARA
#define PORT 8080              // * PUERTO DONDE SE ABRIRA EL SERVIDOR

const char* SSID = STASSID;
const char* PASS = STAPSK;

const String user = "admin";
const String pass = "admin";


const int dhtPin = 2;   // * DHT
const int okLed = 13;   // * OK
const int notLed = 12;  // * NOT

bool flag = false;
IPAddress ip;

DHT dhtSensor(dhtPin, DHT11);
ESP8266WebServer server(PORT);  // * INICIALIZAR SERVIDOR EN EL PUERTO 8080

// TODO: FUNCIONES HANDLER DE LAS RUTAS DEL SERVER
void handleLogin() { // * MANEJADOR RUTA /login
  String data;
  if(user == server.arg("user") && pass == server.arg("pass")){
    data = "{ \"state\": true }";
  } else {
    data = "{ \"state\": false }";
  }

  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", data);
}

void handleRoot() {  // * MANEJADOR RUTA /info
  String data = "{ \"red\": \"";
  data.concat(SSID);
  data.concat("\", \"ip\": \"");
  data.concat(ip.toString());
  data.concat("\", \"port\": \"");
  data.concat(PORT);
  data.concat("\"}");

  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", data);
}

void handleIlumination() { // * MANEJADOR RUTA /ilumination
  Serial.println(server.arg("id"));

  int id = atoi(server.arg("id").c_str());
  
  Wire.beginTransmission(9);
  Wire.print(id);
  Wire.endTransmission();
  
  String data = "{ \"value\": true }";

  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", data);
}

void handleTemperature() {  // * MANEJADOR RUTA /temperature

  float temperatura = dhtSensor.readTemperature();

  String response = "{ \"state\": \"";
  response.concat((String)true);
  response.concat("\", \"dato\": \"");
  response.concat((String) temperatura);
  response.concat("\" }");

  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", response);
}

void handleHumedad() { // * MANEJADOR RUTA /humedad
  float humedad = dhtSensor.readHumidity();

  String response = "{ \"state\": \"";
  response.concat((String) true);
  response.concat("\", \"dato\": \"");
  response.concat((String) humedad);
  response.concat("\" }");

  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "application/json", response);
}

void setup() {
  pinMode(okLed, OUTPUT);
  pinMode(notLed, OUTPUT);

  digitalWrite(okLed, LOW);
  digitalWrite(notLed, LOW);

  dhtSensor.begin();
  delay(100);

  Wire.begin();
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID, PASS);

  // * ESPERAR POR LA CONEXION A LA RED WIFI
  while (WiFi.status() != WL_CONNECTED) {  // * VALIDAR QUE LA CONEXION SE REALIZO CORRECTAMENTE.
    delay(500);
    digitalWrite(notLed, HIGH);
  }

  digitalWrite(notLed, LOW);
  digitalWrite(okLed, HIGH);

  ip = WiFi.localIP();

  // * DECLARACION DE LAS RUTAS DEL SERVIDOR
  server.on("/info", handleRoot);

  server.on("/login", handleLogin);

  server.on("/ilumination", handleIlumination);

  server.on("/temperatura", handleTemperature);

  server.on("/humedad", handleHumedad);

  server.begin();
}

void loop() {
  server.handleClient();
}
