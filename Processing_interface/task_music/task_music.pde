//Importar librerías de Processing

import processing.sound.*;
import oscP5.*;
import netP5.*;
import controlP5.*;
import java.io.*;
import java.util.HashMap;
import java.util.Map;

OscP5 oscP5;
ControlP5 cp5;

// Declarar las variables necesarias
HashMap<Integer, Integer> diccionario;
HashMap<Integer, String> diccionarioNotas;
HashMap<Integer, String> diccionarioNotasOk;

Button caraButton;
Button cuerpoEnteroButton;
Button cuerpoTorsoButton;
Button cuerpoSinCabezaButton;
Button manoDerechaButton;
Button manoIzquierdaButton;
Button manosButton;

Textlabel numClassText;
Textfield numClass;

Button stopButton;
boolean isScriptRunning = false;
Process pythonProcess;

SoundFile song;
float songPosition;
boolean isPlaying;
Textlabel songLabel;
SoundFile soundFile;
float cuePoint = 0;
Button playButton;
Slider positionSlider;
SoundFile[] drumSounds;
Bang bang;
Button resetButton;
Button selectButton;
Button resumeButton;

Textlabel selectedSongLabel; // Etiqueta para mostrar el nombre de la canción seleccionada
Textlabel selectedSongLabelBack; // Etiqueta para mostrar el nombre de la canción seleccionada
Textlabel wekinatorLabel;
Textlabel diccionarioOrder;

String[] buttonText = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si", "Do_"};

SinOsc sineDo;
SinOsc sineRe;
SinOsc sineMi;
SinOsc sineFa;
SinOsc sineSol;
SinOsc sineLa;
SinOsc sineSi;
SinOsc sineDo_;

float startTimeDo;
float startTimeRe;
float startTimeMi;
float startTimeFa;
float startTimeSol;
float startTimeLa;
float startTimeSi;
float startTimeDo_;

boolean isPlaying1 = false;
boolean isPlaying2 = false;
boolean isPlaying3 = false;
boolean isPlaying4 = false;
boolean isPlaying5 = false;
boolean isPlaying6 = false;
boolean isPlaying7 = false;
boolean isPlaying8 = false;

int selectedDrum1 = -1;
int selectedDrum2 = -1;
int selectedDrum3 = -1;
int selectedDrum4 = -1;
int selectedDrum5 = -1;
int selectedDrum6 = -1;
int selectedDrum7 = -1;
int selectedDrum8 = -1;

int maxSelected = 8;
int currentSelected = 1;

Button doButton;
Button reButton;
Button miButton;
Button faButton;
Button solButton;
Button laButton;
Button siButton;
Button do_Button;

int lastPlayed = -1;

boolean isStopped = false;

boolean isPaused = false; // Estado de pausa/reanudar
float pausedPosition = 0; // Posición de la canción al pausar

PImage img; 

// Vector inicial de botones
int[] botones = {1, 2, 3, 4, 5, 6, 7, 8};
// Lista para almacenar el orden de los botones apretados
ArrayList<Integer> ordenApretado = new ArrayList<Integer>();

float lastSoundTime = 0;
float minTimeDifference = 0.5; // Tiempo mínimo entre sonidos en segundos


//Función de configuración
void setup() {
  //Ventana con una imagen de fondo gris
  size(1200, 600);
  img = loadImage("background.jpeg");
  img.filter(GRAY); // Aplicar filtro blanco y negro
  img.resize(width, height);
  
  // Seleccionar orden de notas con diccionario
  diccionarioNotasOk = new HashMap<Integer, String>();
  for (int i = 1; i <=8; i++) {
    diccionarioNotasOk.put(i, buttonText[i-1]);
  }
  diccionarioNotas = new HashMap<Integer, String>();
  for (int i = 1; i <=8; i++) {
    diccionarioNotas.put(i, buttonText[i-1]);
  }
  diccionario = new HashMap<Integer, Integer>();
  for (int i = 1; i <= 8; i++) {
    diccionario.put(i, i);
  }

  //Configuración puerto
  oscP5 = new OscP5(this, 12000);
  //Definir labels y buttons que permiten la interacción
  cp5 = new ControlP5(this);
  diccionarioOrder = cp5.addTextlabel("diccionarioOrder")
                       .setText(mapToString(diccionarioNotas))
                       .setPosition(width/3, height/2-15)
                       .setColor(color(255))
                       .setFont(createFont("Arial", 15));
  caraButton = cp5.addButton("caraButtonClicked")
               .setPosition(15, 10)
               .setSize(180, 40)
               .setLabel("Cara");
  caraButton.getCaptionLabel().setFont(createFont("Arial", 15));
  
  manosButton = cp5.addButton("manosButtonClicked")
                .setPosition(315, 10)
                .setSize(180, 40)
                .setLabel("Manos");
  manosButton.getCaptionLabel().setFont(createFont("Arial", 15));
  
  manoDerechaButton = cp5.addButton("manoDerechaButtonClicked")
                      .setPosition(315, 60)
                      .setSize(180, 40)
                      .setLabel("Mano Derecha");
  manoDerechaButton.getCaptionLabel().setFont(createFont("Arial", 15));
  
  manoIzquierdaButton = cp5.addButton("manoIzquierdaButtonClicked")
                        .setPosition(315, 110)
                        .setSize(180, 40)
                        .setLabel("Mano Izquierda");
  manoIzquierdaButton.getCaptionLabel().setFont(createFont("Arial", 15));
  
  cuerpoEnteroButton  = cp5.addButton("cuerpoEnteroButtonClicked")
                 .setPosition(615, 10)
                 .setSize(180, 40)
                 .setLabel("Cuerpo Entero");
  cuerpoEnteroButton .getCaptionLabel().setFont(createFont("Arial", 15));
  
  cuerpoTorsoButton = cp5.addButton("cuerpoTorsoButtonClicked")
                      .setPosition(615, 60)
                      .setSize(180, 40)
                      .setLabel("Cuerpo Torso");
  cuerpoTorsoButton.getCaptionLabel().setFont(createFont("Arial", 15));
  
  cuerpoSinCabezaButton = cp5.addButton("cuerpoSinCabezaButtonClicked")
                          .setPosition(615, 110)
                          .setSize(180, 40)
                          .setLabel("Cuerpo Sin Cabeza");
  cuerpoSinCabezaButton.getCaptionLabel().setFont(createFont("Arial", 15));

  stopButton = cp5.addButton("stopButtonClickedPython")
    .setPosition(915, 10)
    .setSize(180, 40)
    .setLabel("Detener");
  stopButton.getCaptionLabel().setFont(createFont("Arial", 15));

  // Crea las instancias de Sinus para cada tono
  sineDo = new SinOsc(this);
  sineRe = new SinOsc(this);
  sineMi = new SinOsc(this);
  sineFa = new SinOsc(this);
  sineSol = new SinOsc(this);
  sineLa = new SinOsc(this);
  sineSi = new SinOsc(this);
  sineDo_ = new SinOsc(this);
  // Configura las frecuencias de Sinus
  sineDo.freq(261.63); // Frecuencia de la nota Do
  sineRe.freq(293.66); // Frecuencia de la nota Re
  sineMi.freq(329.63); // Frecuencia de la nota Mi
  sineFa.freq(349.23); // Frecuencia de la nota Re
  sineSol.freq(392.00); // Frecuencia de la nota Sol
  sineLa.freq(440.00); // Frecuencia de la nota La
  sineSi.freq(493.88); // Frecuencia de la nota Si
  sineDo_.freq(523.25); // Frecuencia de la nota Do_
 
  selectButton =cp5.addButton("selectButtonClicked")
     .setPosition(15, 200)
     .setSize(180, 40)
     .setLabel("Seleccionar cancion");
  selectButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  resetButton = cp5.addButton("stopButtonClicked")
     .setPosition(230, 200)
     .setSize(150, 40)
     .setLabel("Detener cancion");
  resetButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  selectedSongLabel = cp5.addTextlabel("selectedSongLabel")
                          .setPosition(15, 250)
                          .setSize(300, 20)
                          .setText("Canción Seleccionada: ")
                          .setFont(createFont("Arial", 20));
                          //.setColor(color(64, 224, 208)); // Establecer color azul turquesa (RGB: 64, 224, 208)
                          //.setColor(color(128, 0, 0)); // Granate color (R: 128, G: 0, B: 0)
  wekinatorLabel = cp5.addTextlabel("wekinatorLabel")
                          .setPosition(width/10+20, height/2+220)
                          .setSize(300, 20)
                          .setText("Wekinator parameters: Inputs: ? - Outputs: 1 - Type: All classifiers (default settings) - Classes: ?")
                          .setFont(createFont("Arial", 20));

  // Agrega los botones para las notas
  doButton = cp5.addButton("doButtonClicked")
    .setPosition(width/2-115*4, 320)
    .setSize(100, 40)
    .setLabel("Do");
  doButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  reButton = cp5.addButton("reButtonClicked")
    .setPosition(width/2-115*3, 320)
    .setSize(100, 40)
    .setLabel("Re");
  reButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  miButton = cp5.addButton("miButtonClicked")
    .setPosition(width/2 - 115*2, 320)
    .setSize(100, 40)
    .setLabel("Mi");
  miButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  
  faButton = cp5.addButton("faButtonClicked")
    .setPosition(width/2-115, 320)
    .setSize(100, 40)
    .setLabel("Fa");
  faButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  solButton = cp5.addButton("solButtonClicked")
    .setPosition(width/2, 320)
    .setSize(100, 40)
    .setLabel("Sol"); 
  solButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  laButton = cp5.addButton("laButtonClicked")
    .setPosition(width/2+115, 320)
    .setSize(100, 40)
    .setLabel("La");
  laButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  
  siButton = cp5.addButton("siButtonClicked")
    .setPosition(width/2+115*2, 320)
    .setSize(100, 40)
    .setLabel("Si");
  siButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  do_Button = cp5.addButton("do_ButtonClicked")
    .setPosition(width/2+115*3, 320)
    .setSize(100, 40)
    .setLabel("Do_");
  do_Button.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  // Establece el color de fondo predeterminado para los botones
  doButton.setColorBackground(color(200));
  reButton.setColorBackground(color(200));
  miButton.setColorBackground(color(200));
  faButton.setColorBackground(color(200));
  solButton.setColorBackground(color(200));
  laButton.setColorBackground(color(200));
  siButton.setColorBackground(color(200));
  do_Button.setColorBackground(color(200));
}

//Función de dibujo
void draw() {

  background(img);
  
  //Dibujar rectangulos detrás de textos
  fill(32, 32, 128); // Color azul oscuro
  rect(15, 250, 1100, 30); //Posición
  fill(32, 32, 128); 
  rect(130, height/2-15, 900, 20); 

  if (isStopped) { //Cuando se detiene el programa
    // Cambiar el color del segundo rectángulo a rojo
    fill(255, 0, 0); // Color rojo
    rect(width/10, height/2+220, 1000, 30); //Posición
  } else {
    // Mantener el color azul
    fill(32, 32, 128);
    rect(width/10, height/2+220, 1000, 30);
  }
  // Actualiza el estado de reproducción de cada tono
  if (isPlaying1 && millis() - startTimeDo > 1000) {
    stopTone1();
  }
  if (isPlaying2 && millis() - startTimeRe > 1000) {
    stopTone2();
  }
  if (isPlaying3 && millis() - startTimeMi > 1000) {
    stopTone3();
  }
  if (isPlaying4 && millis() - startTimeFa > 1000) {
    stopTone4();
  }
  if (isPlaying5 && millis() - startTimeSol > 1000) {
    stopTone5();
  }
  if (isPlaying6 && millis() - startTimeLa > 1000) {
    stopTone6();
  }
  if (isPlaying7 && millis() - startTimeSi > 1000) {
    stopTone7();
  }
  if (isPlaying8 && millis() - startTimeDo_ > 1000) {
    stopTone8();
  }
  // Cambiar el color del botón que está sonando actualmente
  if (isPlaying1) {
    doButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    doButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying2) {
    reButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    reButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying3) {
    miButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    miButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying4) {
    faButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    faButton.setColorBackground(color(200)); // Gris
  }

  if (isPlaying5) {
    solButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    solButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying6) {
    laButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    laButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying7) {
    siButton.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    siButton.setColorBackground(color(200)); // Gris
  }
  if (isPlaying8) {
    do_Button.setColorBackground(color(255, 0, 0)); // Rojo
  } else {
    do_Button.setColorBackground(color(200)); // Gris
  }
}

// Recibir mensajes desde Wekinator y mapearlo
void receiveOsc(OscMessage message) {
  println("Mensaje OSC recibido");
  if (message.checkAddrPattern("/wek/outputs")) {
    float  output = message.get(0).floatValue();
    println("Output: " + output); //Clasificación
    String noteValue = diccionarioNotas.get(int(output));
    println("noteValue", noteValue); //Nota musica. 
    int outputValue = getKeyFromValue(diccionarioNotasOk, noteValue);
    float currentTime = millis() / 1000.0; // Convertir a segundos
    float timeDifference = currentTime - lastSoundTime;
    if (timeDifference >= minTimeDifference) {
      if (outputValue == 1 && lastPlayed != 1) {
        stopAll();
        playTone1();
        lastPlayed = 1;
        fill(255, 0, 0); // Cambia el color del botón cuando está presionado
      } else if (outputValue == 2 && lastPlayed != 2) {
        stopAll();
        playTone2();
        lastPlayed = 2;
      } else if (outputValue == 3 && lastPlayed != 3) {
        stopAll();
        playTone3();
        lastPlayed = 3;
        println("Output: " + outputValue);
      } else if (outputValue == 4 && lastPlayed != 4) {
        stopAll();
        playTone4();
        lastPlayed = 4;
      } else if (outputValue == 5 && lastPlayed != 5) {
        stopAll();
        playTone5();
        lastPlayed = 5;
      } else if (outputValue == 6 && lastPlayed != 6) {
        stopAll();
        playTone6();
        lastPlayed = 6;
      } else if (outputValue == 7 && lastPlayed != 7) {
        stopAll();
        playTone5();
        lastPlayed = 7;
      } else if (outputValue == 8 && lastPlayed != 8) {
        stopAll();
        playTone8();
        lastPlayed = 8;
      }
      // Actualizar el tiempo del último sonido reproducido
      lastSoundTime = currentTime;
    }
  }
}
void oscEvent(OscMessage message) {
  receiveOsc(message);
}
