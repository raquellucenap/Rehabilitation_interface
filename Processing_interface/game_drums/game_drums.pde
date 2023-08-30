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
String[] buttonText = {"Hat", "Kick", "Snare"};

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

ArrayList<PVector> notePositions;
ArrayList<Integer> noteLetter;
PImage player;
PImage[] images = new PImage[3];
float noteSpeed =2;

float kidsWidth = 30;
float kidsHeight = 30;
float kidsX = 600;
float kidsY =750;
float kidsSpeed = 30;
int vidas = 0;
int timer;
int aux;
int letter;
int nextLetter = 10;
int partidas=0;
String sidemessage ="";
float gyros;

boolean boton1Presionado = false;
boolean boton2Presionado = false;
int clase1 = 0;
int clase2 = 0;

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
  // Carga las 3 imágenes
  PImage imagenOriginal = loadImage("hat.png");
  int nuevoAncho = 100;
  int nuevoAlto = 100;  
  imagenOriginal.resize(nuevoAncho, nuevoAlto);
  images[0] = imagenOriginal;
  imagenOriginal = loadImage("kick.png");
  imagenOriginal.resize(nuevoAncho, nuevoAlto);
  images[1] = imagenOriginal;
  imagenOriginal = loadImage("snare.png");
  imagenOriginal.resize(nuevoAncho, nuevoAlto);
  images[2] = imagenOriginal;
  
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
  selectButton =cp5.addButton("selectButtonClicked")
     .setPosition(15, 180)
     .setSize(180, 40)
     .setLabel("Seleccionar cancion");
  selectButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  resumeButton = cp5.addButton("stopButtonClicked")
     .setPosition(230, 180)
     .setSize(150, 40)
     .setLabel("Detener cancion");
  resumeButton.getCaptionLabel().setFont(createFont("Arial", 15));
     
  selectedSongLabel = cp5.addTextlabel("selectedSongLabel")
                          .setPosition(15,230)
                          .setSize(300, 20)
                          .setText("Canción seleccionada: ")
                          .setFont(createFont("Arial", 20));
  wekinatorLabel = cp5.addTextlabel("wekinatorLabel")
                          .setPosition(width/10+20, height/3-20)
                          .setSize(300, 20)
                          .setText("Wekinator parameters: Inputs: ? - Outputs: 1 - Type: All classifiers (default settings) - Classes: X")
                          .setFont(createFont("Arial", 20));
  minim = new Minim(this);  

  kick  = new Sampler( "BD.wav", 4, minim );
  snare = new Sampler( "SD.wav", 4, minim );
  hat   = new Sampler( "CHH.wav", 4, minim );
  out   = minim.getLineOut();
  kick.patch( out );
  snare.patch( out );
  hat.patch( out );
  
  kickButton = cp5.addButton("kickButtonClicked")
    .setPosition(width/2-100, 320)
    .setSize(100, 40)
    .setLabel("Kick");
  kickButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  hatButton = cp5.addButton("hatButtonClicked")
    .setPosition(width/2-250, 320)
    .setSize(100, 40)
    .setLabel("Hat");
  hatButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  snareButton = cp5.addButton("snareButtonClicked")
    .setPosition(width/2+50, 320)
    .setSize(100, 40)
    .setLabel("Snare");  
  snareButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  hatButton.setColorBackground(color(200));
  kickButton.setColorBackground(color(200));
  snareButton.setColorBackground(color(200));
}

// Dibujar
void draw() {
  background(img);
  //Rectángulo
  fill(32, 32, 128); 
  rect(15, 230, 1100, 30);
  fill(256, 256, 256); 
  rect(width / 2 - 220 , height / 2 -80, 450, 50); 
  //Boton detener programa
  if (isStopped) {
    // Cambiar el color del segundo rectángulo a rojo
    fill(255, 0, 0); // Color rojo
    rect(width/10, height/3-20, 1000, 30); // Posición
  } else {
    // Mantener color azul
    fill(32, 32, 128);
    rect(width/10, height/3-20, 1000, 30);
  } 
  textSize(24);
  
  //Código del juego
  textSize(20);
  String message1 = "Points: " + vidas;
  text(message1, width/3+30, height/2-40);
  textSize(20);
  String message2 = "Catch drum " + buttonText[letter];
  
  // Draw the text
  text(message2, width/2-70, height/2-40);
  
  // Draw the image next to the text
  PImage drumImage = images[letter]; // Assuming images[] is an array of PImage objects
  int imageWidth = 40; // Adjust the image width as needed
  int imageHeight = 40; // Adjust the image height as needed
  image(drumImage, width/2-50 + textWidth(message2) + 10, height/2-50 - imageHeight/2, imageWidth, imageHeight);
  textSize(20);
  text(sidemessage, kidsX+130,kidsY+50);
  //String message3 = "Clase1 " + clase1 + " Clase2 " + clase2;
  //text(message3, width/2+100,height/2-40);
  updateY();
  PVector newPosition = new PVector(random(width-40), 300);
  if (millis() - timer >= 1500) {
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
        sidemessage="Great!";
      }
    }else{ // Incorrecto
      if (position.x + images[noteLetter.get(i)].width >= (kidsX) && position.x <= kidsX + player.width && position.y + images[noteLetter.get(i)].height >= kidsY && position.y <= kidsY + player.height) {
          sidemessage="Ouch!";
        }  
    }      
  }

  image(player, kidsX, kidsY);
  
  if(vidas == 100){
    nextLetter=int(random(images.length)); //Cambiamos de letra
    while(letter ==nextLetter){
      nextLetter=int(random(images.length));
    }
    letter=nextLetter;
    vidas=0; //Reiniciamos vidas
    partidas+=1;
  
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
    text("Congratulations!", width / 2, height / 2 + 10);
    
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
void oscEvent(OscMessage message) {
  if (message.checkAddrPattern("/wek/outputs")) {
    float outputValue = message.get(0).floatValue();
    println("Output: " + outputValue);
    if (outputValue == 1) {
  
      if(clase1 ==1){
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
      }
      if(clase1 ==2){
        if(lastDrum!=1){
          kick.patch(out);
          kick.trigger();
          lastDrum =1;
          isPlaying1 = false;
          isPlaying2 = true;
          isPlaying3 = false;
          kickButton.setColorBackground(color(255, 0, 0)); // Rojo
          snareButton.setColorBackground(color(200)); // 
          hatButton.setColorBackground(color(200)); // 
        }
      }
      if(clase1 ==3){
        if(lastDrum!=1){
        snare.patch(out);
        snare.trigger();
        lastDrum =1;
        isPlaying1 = false;
        isPlaying2 = false;
        isPlaying3 = true;
        kickButton.setColorBackground(color(200)); // 
        snareButton.setColorBackground(color(255, 0, 0)); // Rojo
        hatButton.setColorBackground(color(200)); // 
        }
      }
      if(kidsX<width - kidsWidth*6){
        kidsX += kidsSpeed;
      }
    } else if (outputValue == 2) {
      if(kidsX>0){
        kidsX -= kidsSpeed;
      }
      if(clase2 == 1){
        //kick  = new Sampler( "BD.wav", 4, minim );
        if(lastDrum!=2){
          hat.patch(out);
          hat.trigger();
          lastDrum =2;
          isPlaying1 = true;
          isPlaying2 = false;
          isPlaying3 = false;
          hatButton.setColorBackground(color(255, 0, 0)); // Rojo
          snareButton.setColorBackground(color(200)); // 
          kickButton.setColorBackground(color(200)); // 
        }
      }
      if(clase2 == 2){
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
      }
      if(clase2 == 3){
        //kick  = new Sampler( "BD.wav", 4, minim );
        if(lastDrum!=2){
            snare.patch(out);
            snare.trigger();
            lastDrum =2;
            isPlaying1 = false;
            isPlaying2 = false;
            isPlaying3 = true;
            kickButton.setColorBackground(color(200)); // 
            snareButton.setColorBackground(color(255, 0, 0)); // Rojo
            hatButton.setColorBackground(color(200)); // 
        }
      }
    }
  }
}
