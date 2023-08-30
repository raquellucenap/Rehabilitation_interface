//Importar librerías de Processing
import processing.sound.*;
import oscP5.*;
import netP5.*;
import controlP5.*;
import java.io.*;
import processing.opengl.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
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

//ArrayList<DrumButton> drumButtons;
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

ArrayList<PVector> notePositions;
ArrayList<Integer> noteLetter;
String[] notes = {"Do", "Re", "Mi", "Fa", "Sol", "La", "Si", "Do_"};
PImage player;
PImage[] images = new PImage[8];
float noteSpeed =2;
float kidsWidth = 30;
float kidsHeight = 30;
float kidsX = 600;
float kidsY =750;
float kidsSpeed = 20;
int vidas = 0;
int timer;
int aux;
int letter;
int nextLetter = 10;
int partidas=0;
String sidemessage ="";
float gyros;

int clase1= 0;

//Función de configuración
void setup() {
  //Ventana con una imagen de fondo gris
  size(1200, 900);
  img = loadImage("background.jpeg");
  img.filter(GRAY); // Aplicar filtro blanco y negro
  img.resize(width, height);
  
  notePositions = new ArrayList<PVector>();
  noteLetter = new ArrayList<Integer>(); 
  player = loadImage("kids.png");  // Archivo PNG
  // Carga las 8 imágenes
  images[0] = loadImage("DO.jpg");
  images[1] = loadImage("RE.jpg");
  images[2] = loadImage("MI.jpg");
  images[3] = loadImage("FA.jpg");
  images[4] = loadImage("SOL.jpg");
  images[5] = loadImage("LA.jpg");
  images[6] = loadImage("SI.jpg");
  images[7] = loadImage("DO_.jpg");
  
  letter = int(random(images.length));
  timer = millis();
  
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
  
  // Crea las instancias de SinOsc para cada tono
  sineDo = new SinOsc(this);
  sineRe = new SinOsc(this);
  sineMi = new SinOsc(this);
  sineFa = new SinOsc(this);
  sineSol = new SinOsc(this);
  sineLa = new SinOsc(this);
  sineSi = new SinOsc(this);
  sineDo_ = new SinOsc(this);
  // Configura las propiedades de SinOsc
  sineDo.freq(261.63); // Frecuencia de la nota Do
  sineRe.freq(293.66); // Frecuencia de la nota Re
  sineMi.freq(329.63); // Frecuencia de la nota Mi
  sineFa.freq(349.23); // Frecuencia de la nota Re
  sineSol.freq(392.00); // Frecuencia de la nota Sol
  sineLa.freq(440.00); // Frecuencia de la nota La
  sineSi.freq(493.88); // Frecuencia de la nota Mi
  sineDo_.freq(523.25); // Frecuencia de la nota Mi

  
  wekinatorLabel = cp5.addTextlabel("wekinatorLabel")
                          .setPosition(width/10+20, height/3-140)
                          .setSize(300, 20)
                          .setText("Wekinator parameters: Inputs: ? - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2")
                          .setFont(createFont("Arial", 20));
  
  // Agrega los botones o cajas de texto para las notas
  doButton = cp5.addButton("doButtonClicked")
    .setPosition(width/2-115*4, 200)
    .setSize(100, 40)
    .setLabel("Do");
  doButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  reButton = cp5.addButton("reButtonClicked")
    .setPosition(width/2-115*3, 200)
    .setSize(100, 40)
    .setLabel("Re");
  reButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  miButton = cp5.addButton("miButtonClicked")
    .setPosition(width/2 - 115*2, 200)
    .setSize(100, 40)
    .setLabel("Mi");
  miButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  
  faButton = cp5.addButton("faButtonClicked")
    .setPosition(width/2-115, 200)
    .setSize(100, 40)
    .setLabel("Fa");
  faButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  solButton = cp5.addButton("solButtonClicked")
    .setPosition(width/2, 200)
    .setSize(100, 40)
    .setLabel("Sol"); 
  solButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  laButton = cp5.addButton("laButtonClicked")
    .setPosition(width/2+115, 200)
    .setSize(100, 40)
    .setLabel("La");
  laButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  
  siButton = cp5.addButton("siButtonClicked")
    .setPosition(width/2+115*2, 200)
    .setSize(100, 40)
    .setLabel("Si");
  siButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  do_Button = cp5.addButton("do_ButtonClicked")
    .setPosition(width/2+115*3, 200)
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

//Dibujar
void draw() {
  background(img);
  // Rectangulo 
  fill(32, 32, 128); 
  fill(256, 256, 256); 
  rect(width / 2 - 220 , height / 2 -200, 450, 50); 
  //Boton detener programa
  if (isStopped) {
    // Cambiar el color del segundo rectángulo a rojo
    fill(255, 0, 0); // Color rojo
    rect(width/10, height/3-140, 1000, 30); // Posición
  } else {
    // Mantener color azul
    fill(32, 32, 128); 
    rect(width/10, height/3-140, 1000, 30);
  }
  // Actualiza el estado de reproducción de cada tono
  int durationNote = 1000;
  if (isPlaying1 && millis() - startTimeDo > durationNote) {
    stopTone1();
  }
  if (isPlaying2 && millis() - startTimeRe > durationNote) {
    stopTone1();
  }
  if (isPlaying3 && millis() - startTimeMi > durationNote) {
    stopTone1();
  }
  if (isPlaying4 && millis() - startTimeFa > durationNote) {
    stopTone1();
  }
  if (isPlaying5 && millis() - startTimeSol > durationNote) {
    stopTone1();
  }
  if (isPlaying6 && millis() - startTimeLa > durationNote) {
    stopTone1();
  }
  if (isPlaying7 && millis() - startTimeSi > durationNote) {
    stopTone1();
  }
  if (isPlaying8 && millis() - startTimeDo_ > durationNote) {
    stopTone1();
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
  // Actualizar la posición de reproducción en el slider
  //if (song != null) {
  //  if (!positionSlider.isInside()) {
  //    positionSlider.setValue(songPosition / song.duration());
  //  }
  //}
  
  textSize(24);
  
  //Código del juego
  textSize(30);
  String message1 = "Points: " + vidas + "/100";
  text(message1, width/3, height/2-160);
  textSize(30);
  String message2 = "Catch note " + notes[letter];
  text(message2, width/2,height/2-160);
  textSize(20);
  text(sidemessage, kidsX+100,kidsY+50);
  textSize(20);
  
  updateY();
  PVector newPosition = new PVector(random(width-40), 300);
  if (millis() - timer >= 800) {
    aux= int(random(images.length));
    notePositions.add(newPosition);
    noteLetter.add(aux);
    timer = millis();
  }

  for (int i=0; i<notePositions.size(); i++) {
    
    PVector position=notePositions.get(i);
    image(images[noteLetter.get(i)], position.x, position.y);  // Dibuja la imagen en la posición nueva
    if(noteLetter.get(i) == letter){ //Correcto!
      
      if (position.x + images[noteLetter.get(i)].width >= kidsX && position.x <= kidsX + player.width && position.y + images[noteLetter.get(i)].height >= kidsY && position.y <= kidsY + player.height) {
        vidas += 1;
        clase1 = letter +1;
        playTone1();
        sidemessage="Great!";
        if (vidas == 100){
          continue;
        }
      }
    }else{ // Incorrecto
      if (position.x + images[noteLetter.get(i)].width >= (kidsX) && position.x <= kidsX + player.width && position.y + images[noteLetter.get(i)].height >= kidsY && position.y <= kidsY + player.height) {
          sidemessage="Ouch!";
        }  
    }    
  }

  image(player, kidsX, kidsY);
  
  if(vidas == 100){
    println(vidas);
    nextLetter=int(random(images.length)); //Cambiamos de letra
    while(letter ==nextLetter){
      nextLetter=int(random(images.length));
    }
    letter=nextLetter;
    vidas=0; //Reiniciamos vidas
    partidas+=1;
    stopTone1();
    isPlaying1 = false;
    isPlaying2 = false;
    isPlaying3 = false;
    isPlaying4 = false;
    isPlaying5 = false;
    isPlaying6 = false;
    isPlaying7 = false;
    isPlaying8 = false;
  
  }

  if (partidas == 5) {
    notePositions.clear();
     // Subrayar
    float lineY = height / 2;  
    stroke(256, 256 ,256);  // Color blanco
    strokeWeight(60);  // Grosor
    line(width / 2 - 150, lineY, width / 2 + 150, lineY);  
    
    textAlign(CENTER);
    textSize(48);
    text("Congratulations!", width / 2, height / 2+10);
    delay(2000);
    noLoop();
  }
}
// Modificar posición 
void updateY() {
  for (PVector position : notePositions) {
    position.y += noteSpeed;
  }
}

// Recibir mensajes desde Wekinator y mapearlo
void receiveOsc(OscMessage message) {
  if (message.checkAddrPattern("/wek/outputs")) {
    float outputValue = message.get(0).floatValue();
    println("Output: " + outputValue);

    if (outputValue == 1 ){//&& lastPlayed != 1) {
      stopAll();
      //playTone1();
      lastPlayed = 1;
      fill(255, 0, 0); // Cambia el color del botón cuando está presionado

      println("Output: " + outputValue);
      if(kidsX<width){
        kidsX += kidsSpeed;
      }
    } else if (outputValue == 2 ){//&& lastPlayed != 2) {
      stopAll();
      //playTone1();
      lastPlayed = 2;
      println("Output: " + outputValue);
      if(kidsX>0){
        kidsX -= kidsSpeed;
      }
    }
  }
}
void oscEvent(OscMessage message) {
  receiveOsc(message);
}
