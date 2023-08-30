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

//ArrayList<DrumButton> drumButtons;
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

void setup() {
  size(1200, 600);
  img = loadImage("background.jpeg");
  img.filter(GRAY); // Aplicar filtro blanco y negro
  img.resize(width, height);
  
  
  oscP5 = new OscP5(this, 12000);
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
  //cp5.setControlFont(createFont("Arial", 18));
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
                          .setPosition(width/10+50, height/2+220)
                          .setSize(300, 20)
                          .setText("Wekinator parameters: Inputs: ? - Outputs: 1 - Type: All classifiers (default settings) - Classes: ?")
                          .setFont(createFont("Arial", 20));
  minim = new Minim(this);  
  // load all of our samples, using 4 voices for each.
  // this will help ensure we have enough voices to handle even
  // very fast tempos.
  kick  = new Sampler( "BD.wav", 4, minim );
  snare = new Sampler( "SD.wav", 4, minim );
  hat   = new Sampler( "CHH.wav", 4, minim );
  out   = minim.getLineOut();
  kick.patch( out );
  snare.patch( out );
  hat.patch( out );
  hat.trigger();
  kick.trigger();
  //snare.trigger();
  
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
  hatButton.setColorBackground(color(200));
  kickButton.setColorBackground(color(200));
  snareButton.setColorBackground(color(200));
}

void draw() {
  background(img);
  
  fill(32, 32, 128); // Establecer el color de relleno azul oscuro (RGB: 32, 32, 128)
  rect(15, 250, 1100, 30); // Dibujar el rectángulo detrás del texto
  
  if (isStopped) {
    // Cambiar el color del segundo rectángulo a rojo
    fill(255, 0, 0); // Establecer el color de relleno rojo
    rect(width/10, height/2+220, 1000, 30);
  } else {
    // Mantener el color original del segundo rectángulo
    fill(32, 32, 128); // Establecer el color de relleno azul oscuro (RGB: 32, 32, 128)
    rect(width/10, height/2+220, 1000, 30);
  }
  // Actualizar la posición de reproducción en el slider
  if (song != null) {
    if (!positionSlider.isInside()) {
      positionSlider.setValue(songPosition / song.duration());
    }
  }
  
  textSize(24);
}

void selectButtonClicked() {
  selectInput("Selecciona un archivo de audio:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection != null) {
    if (soundFile != null) {
      soundFile.stop();
      //soundFile.close();
    }
    soundFile = new SoundFile(this, selection.getAbsolutePath());
    if (soundFile != null) {
      soundFile.amp(0.5);
    }
    soundFile.play();
    isPlaying = true;
    
    selectedSongLabel.setText("Canción seleccionada: " + selection.getName());
  }
}

void stopButtonClicked() {
  if (soundFile != null && isPlaying) {
    cuePoint = soundFile.position();
    soundFile.pause();
    isPlaying = false;
  }
}

void selectSong() {
  selectInput("Seleccionar canción", "loadSong");
}

void loadSong(File selection) {
  if (selection == null) {
    println("No se ha seleccionado ningún archivo");
  } else {
    song = new SoundFile(this, selection.getAbsolutePath());
    song.play();
    playButton.setLabel("Pausar");
    positionSlider.setValue(0);
    isPlaying = true;
    songLabel.setText("Canción: " + selection.getName());
  }
}

void playPause() {
  if (song != null) {
    if (isPlaying) {
      song.pause();
      playButton.setLabel("Reproducir");
    } else {
      song.play();
      playButton.setLabel("Pausar");
    }
    isPlaying = !isPlaying;
  }
}

void stop() {
  if (soundFile != null) {
    //soundFile.close();
  }
  super.stop();
  stopPythonScript(); 
}
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
          println(lastDrum);
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
void stopButtonClickedPython() {
  // Cambiar el texto del objeto wekinatorLabel
  wekinatorLabel.setText("Para Detener: Cierra la ventana de Wekinator y la consola (ventana negra)");
  
  // Cambiar el estado a "stopped"
  isStopped = true;
  if (isScriptRunning) {
    stopPythonScript();
  }
}
void caraButtonClicked() {    
  wekinatorLabel.setText("Wekinator parameters: Inputs: 936 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\cara";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manosButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 84 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/ManosWekinator/ManosWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\manos";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoDerechaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\right_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoIzquierdaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\left_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void cuerpoEnteroButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 37 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoTorsoButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 16 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\tronco_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoSinCabezaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 24 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\nocara_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}

void stopPythonScript() {
  if (pythonProcess != null) {
    pythonProcess.destroy(); // Detener el proceso de Python
    isScriptRunning = false;
    println("Script de Python detenido.");
  }
}
