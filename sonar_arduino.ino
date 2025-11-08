
#include <Servo.h>

#define PINO_SERVO 9
#define PINO_TRIG 10
#define PINO_ECHO 11

Servo meuServo;

void setup() {

  Serial.begin(9600);

  meuServo.attach(PINO_SERVO);

  pinMode(PINO_TRIG, OUTPUT);
  pinMode(PINO_ECHO, INPUT);
}

void loop() {
  
  for (int angulo = 0; angulo <= 180; angulo++) {
   
    meuServo.write(angulo);
    
    long distancia = medirDistancia();
    
    Serial.print(angulo);    
    Serial.print(",");        
    Serial.println(distancia);
  
    delay(50);
  }

  for (int angulo = 180; angulo >= 0; angulo--) {
    meuServo.write(angulo);
    long distancia = medirDistancia();
    
    Serial.print(angulo);
    Serial.print(",");
    Serial.println(distancia);
    
    delay(50);
  }
}

long medirDistancia() {

  digitalWrite(PINO_TRIG, LOW);
  delayMicroseconds(2);

  digitalWrite(PINO_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PINO_TRIG, LOW);

  long duracao = pulseIn(PINO_ECHO, HIGH);
  
  long distanciaCm = (duracao * 0.034) / 2;
  
  return distanciaCm;
}