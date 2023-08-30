//Importar librerías de Processing
import processing.sound.*;
import oscP5.*;
import netP5.*;
import controlP5.*;
import java.io.*;
import processing.opengl.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

OscP5 oscP5;

// Declarar las variables necesarias
Button caraButton;
Button cuerpoEnteroButton;
Button cuerpoTorsoButton;
Button cuerpoSinCabezaButton;
Button manoDerechaButton;
Button manoIzquierdaButton;
Button manosButton;

Button stopButton;
boolean isScriptRunning = false;
Process pythonProcess;

SoundFile song;
float songPosition;
boolean isPlaying;
Textlabel songLabel;
SoundFile soundFile;
float cuePoint = 0;
ControlP5 cp5;
Button playButton;
Slider positionSlider;
SoundFile[] drumSounds;
Bang bang;
Button resetButton;
Button resumeButton;
Button selectButton;
Button kickButton;
Button hatButton;
Button snareButton;

Textlabel selectedSongLabel; // Etiqueta para mostrar el nombre de la canción seleccionada
Textlabel wekinatorLabel; 

String[] buttonText = {"Kick", "Hit", "Drum", "Clong", "Hat", "Clock"};

boolean isPlaying1 = false;
boolean isPlaying2 = false;
boolean isPlaying3 = false;
int selectedDrum1 = -1;
int selectedDrum2 = -1;
int lastDrum = 3;
PImage img; 

Minim       minim;
AudioOutput out;
Sampler     kick;
Sampler     snare;
Sampler     hat;

int bpm = 120;
int beat; // which beat we're on

PFont font;
boolean isStopped = false;

float lastSoundTime = 0;
float minTimeDifference = 0.5; // Tiempo mínimo entre sonidos en segundos

//Función de configuración
void setup() {
  //Ventana con una imagen de fondo gris
  size(1200, 600);
  img = loadImage("background.jpeg");
  img.filter(GRAY); // Aplicar filtro blanco y negro
  img.resize(width, height);
  
  //Configuración puerto 
  oscP5 = new OscP5(this, 12000);
  //Definir labels y buttons que permiten la interacción
  cp5 = new ControlP5(this);
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

  selectButton =cp5.addButton("selectButtonClicked")
     .setPosition(15, 200)
     .setSize(180, 40)
     .setLabel("Seleccionar cancion");
  selectButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  resumeButton = cp5.addButton("stopButtonClicked")
     .setPosition(230, 200)
     .setSize(150, 40)
     .setLabel("Detener cancion");
  resumeButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  selectedSongLabel = cp5.addTextlabel("selectedSongLabel")
                          .setPosition(15, 250)
                          .setSize(300, 20)
                          .setText("Canción seleccionada: ")
                          .setFont(createFont("Arial", 20));
  wekinatorLabel = cp5.addTextlabel("wekinatorLabel")
                          .setPosition(width/10+20, height/2+220)
                          .setSize(300, 20)
                          .setText("Wekinator parameters: Inputs: ? - Outputs: 1 - Type: All classifiers (default settings) - Classes: ?")
                          .setFont(createFont("Arial", 20));
  minim = new Minim(this);  
  
  // Cargar las muestras (audios de tambores)
  kick  = new Sampler( "BD.wav", 4, minim );
  snare = new Sampler( "SD.wav", 4, minim );
  hat   = new Sampler( "CHH.wav", 4, minim );
  out   = minim.getLineOut();
  kick.patch( out );
  snare.patch( out );
  hat.patch( out );
  
  //Botones de tambores
  kickButton = cp5.addButton("kickButtonClicked")
    .setPosition(width/2-250, 350)
    .setSize(100, 40)
    .setLabel("Kick");
  kickButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  hatButton = cp5.addButton("hatButtonClicked")
    .setPosition(width/2-100, 350)
    .setSize(100, 40)
    .setLabel("Hat");
  hatButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  snareButton = cp5.addButton("snareButtonClicked")
    .setPosition(width/2+50, 350)
    .setSize(100, 40)
    .setLabel("Snare");  
  snareButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  hatButton.setColorBackground(color(200)); //Color gris
  kickButton.setColorBackground(color(200));
  snareButton.setColorBackground(color(200));
}

//Función de dibujo
void draw() {
  background(img);
  
  //Dibujar rectangulos detrás de textos
  fill(32, 32, 128); // Color azul oscuro
  rect(15, 250, 1100, 30); // Posición
  
  if (isStopped) { //Cuando se detiene el programa
    // Cambiar el color del segundo rectángulo a rojo
    fill(255, 0, 0); // Color rojo
    rect(width/10, height/2+220, 1000, 30); // Posición
  } else {
    // Mantener el color azul
    fill(32, 32, 128);
    rect(width/10, height/2+220, 1000, 30);
  }
  // Actualizar la posición de reproducción en el slider
  //if (song != null) {
    //if (!positionSlider.isInside()) {
      //positionSlider.setValue(songPosition / song.duration());
    //}
  //}
  textSize(24);
}


// Recibir mensajes desde Wekinator y mapearlo
void oscEvent(OscMessage message) {
  if (message.checkAddrPattern("/wek/outputs")) {
    long time = millis();
    float outputValue = message.get(0).floatValue();
    println("Output: " + outputValue);
      // Comprobar el tiempo transcurrido desde el último sonido
    float currentTime = millis() / 1000.0; // Convertir a segundos
    float timeDifference = currentTime - lastSoundTime;
    
    if (timeDifference >= minTimeDifference) {
      // Reproducir el sonido solo si ha pasado suficiente tiempo
      //if (outputValue == 1) {
      if (outputValue == 2) {
        //snare = new Sampler( "SD.wav", 4, minim );
        //hat   = new Sampler( "CHH.wav", 4, minim );   
        if(lastDrum!=1){
          hat.patch( out );
          hat.trigger();
          lastDrum =1;
          isPlaying1 = true;
          isPlaying2 = false;
          isPlaying3 = false;
          kickButton.setColorBackground(color(200)); // 
          snareButton.setColorBackground(color(200)); // 
          hatButton.setColorBackground(color(255, 0, 0)); // Rojo
        }
      //} else if (outputValue == 2) {
      } else if (outputValue == 1) {
        //kick  = new Sampler( "BD.wav", 4, minim );
        if(lastDrum!=2){
          kick.patch(out);
          kick.trigger();
          lastDrum =2;
          isPlaying1 = false;
          isPlaying2 = true;
          isPlaying3 = false;
          kickButton.setColorBackground(color(255, 0, 0)); // Rojo
          snareButton.setColorBackground(color(200)); // 
          hatButton.setColorBackground(color(200)); // 
        }
      //} else if (outputValue == 3) {
      } else if (outputValue == 3) {
        //kick  = new Sampler( "BD.wav", 4, minim );
        if(lastDrum!=3){
          snare.patch(out);
          snare.trigger();
          lastDrum =3;
          isPlaying1 = false;
          isPlaying2 = false;
          isPlaying3 = true;
          kickButton.setColorBackground(color(200)); // 
          snareButton.setColorBackground(color(255, 0, 0)); // Rojo
          hatButton.setColorBackground(color(200)); // 
        }
      }
      // Actualizar el tiempo del último sonido reproducido
      lastSoundTime = currentTime;
      println(lastSoundTime);
    }
    long end = millis();
    long diff = end-time;
    println("Elapsed Time: " + diff + " milliseconds");
  }
}
