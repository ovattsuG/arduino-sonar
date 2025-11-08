# 🌊 Sonar com Arduino e Processing

Este projeto implementa um **sonar interativo** utilizando **Arduino**, um **sensor ultrassônico (HC-SR04)** e um **servo motor**.  
O sistema realiza medições de distância por meio de **ondas ultrassônicas**, enviando os dados via **Serial** para o **Processing**, onde é exibida uma interface visual que simula o funcionamento de um sonar em tempo real.

---

## ⚙️ Funcionalidades

✅ Varredura automática de 0° a 180°  
✅ Detecção de obstáculos por ultrassom  
✅ Comunicação serial entre Arduino e Processing  
✅ Interface visual estilo sonar em tempo real  
✅ Exibição precisa da posição e distância dos objetos detectados  

---

## 🧠 Como funciona

O **Arduino** controla o **servo motor**, movimentando o **sensor ultrassônico HC-SR04** em um arco de 180°.  
A cada ângulo, o sensor emite um pulso de som e calcula o tempo até o eco retornar, determinando assim a **distância** do objeto.  

Essas leituras são enviadas pela porta serial no formato:

```
<ângulo>,<distância>
```

Exemplo:
```
90,35
```

O **Processing** interpreta esses dados, converte-os em coordenadas no plano e desenha a visualização do sonar, mostrando em tempo real a linha de varredura e os pontos que representam os objetos detectados.

---

## 🧩 Componentes utilizados

| Componente | Quantidade | Descrição |
|-------------|-------------|-----------|
| Arduino Uno (ou compatível) | 1 | Microcontrolador principal |
| Sensor Ultrassônico HC-SR04 | 1 | Mede distâncias por eco sonoro |
| Servo Motor SG90 | 1 | Rotaciona o sensor |
| Jumpers e Protoboard | - | Conexões elétricas |
| Cabo USB | 1 | Comunicação e alimentação |

---

## ⚡ Ligações do circuito

| Componente | Pino Arduino |
|-------------|--------------|
| **Servo** - Sinal | 9 |
| **HC-SR04** - TRIG | 10 |
| **HC-SR04** - ECHO | 11 |
| **VCC e GND** | 5V e GND |

📸 **Imagem do circuito:**  

<img width="1822" height="750" alt="Circuito_sonar_arduino" src="https://github.com/user-attachments/assets/fe95d649-153b-461c-bc10-a9cfb61a70fd" />

---

## 💻 Código do Arduino

Arquivo: `sonar_arduino.ino`

Responsável por:
- Controlar o servo motor  
- Fazer leituras de distância com o sensor HC-SR04  
- Enviar as informações via Serial para o Processing  

---

## 🖥️ Código do Processing

Arquivo: `arduino_sonar_display.pde`

Responsável por:
- Receber os dados seriais enviados pelo Arduino  
- Converter ângulo e distância em coordenadas polares  
- Exibir a visualização gráfica do sonar em tempo real  

> ⚠️ **Importante:** Lembre-se de alterar o nome da porta serial no código Processing:  
```java
String nomeDaPorta = "COM6"; // Troque para a porta correta do seu Arduino
```

---

## 🎥 Demonstração

📽️ **Assista ao vídeo do sonar em funcionamento:**  
[▶️ Ver vídeo de demonstração](https://youtu.be/NSIyn0DI6bs)

---

## 🧰 Requisitos

### Arduino
- IDE Arduino instalada  
- Porta serial configurada em **9600 bps**

### Processing
- Versão 3.0 ou superior  
- Biblioteca padrão `processing.serial.*`

---

## 🚀 Como executar

1. **Carregue** o código no Arduino.  
2. **Feche o monitor serial** da IDE Arduino.  
3. **Abra** o projeto no Processing.  
4. Altere o nome da porta serial conforme o seu sistema (ex: `COM3`, `/dev/ttyUSB0`).  
5. **Execute o sketch** e veja o sonar em ação!  

---

## 📈 Resultado esperado

- O servo motor realiza a varredura entre 0° e 180°.  
- O sonar no Processing exibe a linha de varredura e os objetos detectados (em vermelho).  
- O terminal serial mostra ângulos e distâncias em tempo real.  

---

## 🧑‍💻 Autor

**Gustavo Correa**  
💡 Estudante e entusiasta de desenvolvimento de software e eletrônica  
📬 [Linkedin](https://www.linkedin.com/in/gustavo-correa-5b102a248/)

---

## 🛠️ Licença

Este projeto é distribuído sob a licença **MIT** — fique à vontade para usar, modificar e melhorar.
