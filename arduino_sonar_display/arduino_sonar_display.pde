// Importa a biblioteca Serial do Processing
import processing.serial.*;

// ----- Variáveis Globais -----
Serial minhaPorta; // Objeto para representar a porta Serial

int anguloAtual = 0;    // Guarda o último ângulo recebido
float distanciaAtual = 0; // Guarda a última distância recebida

// Variáveis para o nosso ecrã de radar
float raioMaximoTela;      // Quantos pixels tem o raio do nosso radar
float distanciaMaxSensor = 20; // Qual a distância MÁXIMA (em cm) que queremos desenhar

void setup() {
  // Cria uma janela de 800x600 pixels
  size(1540, 800);
  
  // O raio do nosso radar será metade da altura da janela
  raioMaximoTela = height / 2 - 50; // (deixa 50 pixels de margem)

  // ----- INICIALIZAR A PORTA SERIAL -----
  
  // 1. Mostra todas as portas Seriais disponíveis na consola (em baixo)
  //    Repara no NOME da porta do teu Arduino (ex: "COM3", "/dev/ttyUSB0")
  printArray(Serial.list());

  // 2. ***** MUDA ESTA LINHA *****
  //    Coloca o nome exato da porta do teu Arduino aqui
  //    (Se estiveres em Windows será "COM3", "COM4", etc.)
  //    (Se estiveres em Mac/Linux será algo como "/dev/tty.usbmodem1411")
  String nomeDaPorta = "COM6"; // <--- MUDA ISTO
  
  // 3. Abre a porta e define a velocidade (TEM DE SER 9600, igual ao Arduino)
  try {
    minhaPorta = new Serial(this, nomeDaPorta, 9600);
  } catch (Exception e) {
    println("Erro ao abrir a porta serial. Verifica se:");
    println("1. O Arduino está ligado.");
    println("2. O 'nomeDaPorta' está correto neste código.");
    println("3. O 'Monitor Serial' do Arduino IDE está FECHADO.");
    exit(); // Fecha o programa se não conseguir ligar
  }

  // Diz ao Processing para só nos avisar quando receber uma 'nova linha' (\n)
  // Isto é muito importante!
  minhaPorta.bufferUntil('\n');
}

void draw() {
  // A função draw() é o loop principal do Processing, corre 60x por segundo

  // 1. Desenha o fundo preto com um efeito de "rasto" (fade)
  //    Em vez de limpar o ecrã, desenha um retângulo preto semi-transparente
  //    O '15' é a opacidade. Quanto menor, maior o "rasto".
  fill(0, 15); 
  rect(0, 0, width, height);

  // 2. Desenha a interface estática do radar
  desenharUI();

  // 3. Desenha a linha de varredura e os "blips"
  desenharVarredura();
}

/**
 * Função que desenha o fundo do radar (círculos e linhas)
 */
void desenharUI() {
  // Centraliza todo o desenho no meio da parte de baixo do ecrã
  pushMatrix(); // Salva o estado atual do desenho (como um "checkpoint")
  translate(width / 2, height - 50); // Move a origem (0,0) para o centro/fundo

  noFill(); // Não preencher as formas
  strokeWeight(1);
  stroke(0, 255, 0); // Cor verde-radar

  // Desenha os arcos (semicírculos)
  // O radar é um semicírculo, que em radianos vai de PI (180º) até TWO_PI (360º ou 0º)
  float anguloInicio = PI;
  float anguloFim = TWO_PI;
  
  arc(0, 0, raioMaximoTela * 0.5, raioMaximoTela * 0.5, anguloInicio, anguloFim);
  arc(0, 0, raioMaximoTela * 1.0, raioMaximoTela * 1.0, anguloInicio, anguloFim);
  arc(0, 0, raioMaximoTela * 1.5, raioMaximoTela * 1.5, anguloInicio, anguloFim);
  arc(0, 0, raioMaximoTela * 2.0, raioMaximoTela * 2.0, anguloInicio, anguloFim);

  // Desenha as linhas (raios)
  line(0, 0, raioMaximoTela * cos(radians(180)), raioMaximoTela * sin(radians(180)));
  line(0, 0, raioMaximoTela * cos(radians(225)), raioMaximoTela * sin(radians(225)));
  line(0, 0, raioMaximoTela * cos(radians(270)), raioMaximoTela * sin(radians(270)));
  line(0, 0, raioMaximoTela * cos(radians(315)), raioMaximoTela * sin(radians(315)));
  line(0, 0, raioMaximoTela * cos(radians(360)), raioMaximoTela * sin(radians(360)));

  popMatrix(); // Restaura o estado do desenho (volta ao "checkpoint")
}

/**
 * Função que desenha a linha de varredura e os objetos detetados
 */
void desenharVarredura() {
  // Centraliza o desenho, tal como na função desenharUI()
  pushMatrix();
  translate(width / 2, height - 50);

  // ----- CONVERSÃO MÁGICA (Polar para Cartesiano) -----
  
  // 1. Mapeia o ângulo do servo (0-180) para o ângulo do ecrã (PI-TWO_PI)
  //    (map(valor, minOriginal, maxOriginal, minNovo, maxNovo))
  float anguloRads = map(anguloAtual, 0, 180, PI, TWO_PI);

  // 2. Mapeia a distância do sensor (cm) para a distância no ecrã (pixels)
  //    (Não deixamos passar do nosso máximo)
  float distanciaPixels = map(distanciaAtual, 0, distanciaMaxSensor, 0, raioMaximoTela);

  // 3. Calcula as coordenadas X e Y usando trigonometria
  float x = distanciaPixels * cos(anguloRads);
  float y = distanciaPixels * sin(anguloRads); // O 'y' negativo é "para cima" no Processing

  
  // ----- DESENHAR A LINHA E OS "BLIPS" -----

  // Desenha a linha de varredura (verde brilhante)
  stroke(0, 255, 0, 150); // Verde com alguma transparência
  strokeWeight(2);
  line(0, 0, x, y);

  // Desenha o "blip" (o ponto) se estiver dentro do alcance
  if (distanciaAtual > 0 && distanciaAtual < distanciaMaxSensor) {
    // Desenha um círculo vermelho e sólido no ponto (x,y)
    fill(255, 0, 0); // Cor vermelha
    noStroke();
    ellipse(x, y, 10, 10); // Um círculo de 10x10 pixels
  }
  
  popMatrix();
}


/**
 * Evento da Porta Serial: Esta função é chamada AUTOMATICAMENTE
 * pelo Processing sempre que chegam dados novos (terminados em '\n')
 */
void serialEvent(Serial minhaPorta) {
  // 1. Lê a string inteira até ao '\n' (ex: "90,35")
  String dadosRecebidos = minhaPorta.readStringUntil('\n');

  // 2. Verifica se a string não está vazia
  if (dadosRecebidos != null) {
    // 3. Limpa espaços em branco (segurança)
    dadosRecebidos = trim(dadosRecebidos);
    
    // 4. Separa a string na vírgula. 
    //    Isto cria um array: ["90", "35"]
    String[] partes = split(dadosRecebidos, ',');
    
    // 5. Se tivermos exatamente 2 partes, os dados estão bons!
    if (partes.length == 2) {
      try {
        // Converte a primeira parte (texto) para um número inteiro
        anguloAtual = int(partes[0]);
        // Converte a segunda parte (texto) para um número decimal (float)
        distanciaAtual = float(partes[1]);
        
        // (Descomenta a linha abaixo para ver os dados a chegar na consola)
        // println("Ângulo: " + anguloAtual + ", Distância: " + distanciaAtual);
        
      } catch (Exception e) {
        // Ignora se houver algum erro de conversão (ex: dados corrompidos)
      }
    }
  }
}
