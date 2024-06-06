import oscP5.*;
import netP5.*;
import controlP5.*;
import controlP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

OscP5 oscP5;
ControlP5 cp5;
String clase;

Minim minim;

Sampler kick;
Sampler snare;
Sampler hat;
Button kickButton;
Button hatButton;
Button snareButton;

AudioOutput out;

PImage img;

float lastSoundTime = 0;
float minTimeDifference = 0.4; // Tiempo mínimo entre sonidos en segundos

int lastDrum = 3;

boolean isPlaying1 = false;
boolean isPlaying2 = false;
boolean isPlaying3 = false;

void setup() {
  size(800, 400);
  img = loadImage("background.jpeg");
  if (img != null) {
    println("Imagen cargada con éxito.");
  } else {
    println("Error al cargar la imagen.");
  }
  img.filter(GRAY);
  img.resize(width, height);
  oscP5 = new OscP5(this, 12001);
  cp5 = new ControlP5(this);
  
  minim = new Minim(this);
  //audio drums
  kick = new Sampler("BD.wav", 4, minim);
  snare = new Sampler("SD.wav", 4, minim);
  hat = new Sampler("CHH.wav", 4, minim);
  out = minim.getLineOut();
  kick.patch(out);
  snare.patch(out);
  hat.patch(out);
  
  kickButton = cp5.addButton("kickButtonClicked")
    .setPosition(width/2-250, 150)
    .setSize(100, 40)
    .setLabel("Kick");
  kickButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  hatButton = cp5.addButton("hatButtonClicked")
    .setPosition(width/2-100, 150)
    .setSize(100, 40)
    .setLabel("Hat");
  hatButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));

  snareButton = cp5.addButton("snareButtonClicked")
    .setPosition(width/2+50, 150)
    .setSize(100, 40)
    .setLabel("Snare");  
  snareButton.getCaptionLabel().setFont(createFont("Arial Bold", 15));
  hatButton.setColorBackground(color(200)); //Color gris
  kickButton.setColorBackground(color(200));
  snareButton.setColorBackground(color(200));
  
}
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/adress")) {
    long time = millis();
    clase = theOscMessage.get(0).stringValue();
    float currentTime = millis() / 1000.0; // Convertir a segundos
    float timeDifference = currentTime - lastSoundTime;
    
    if (timeDifference >= minTimeDifference) {
      if (clase.equals("clase0")) {
        if (lastDrum!=1){
          hat.patch(out);
          hat.trigger();
          lastDrum = 1;
          isPlaying1 = true;
          isPlaying2 = false;
          isPlaying3 = false;
          kickButton.setColorBackground(color(200)); 
          snareButton.setColorBackground(color(200)); 
          hatButton.setColorBackground(color(255, 0, 0)); // Rojo
        }
      } else if (clase.equals("clase1")) {
        if (lastDrum != 2) {
          kick.patch(out);
          kick.trigger();
          lastDrum = 2;
          isPlaying1 = false;
          isPlaying2 = true;
          isPlaying3 = false;
          kickButton.setColorBackground(color(255, 0, 0)); // Rojo
          snareButton.setColorBackground(color(200)); 
          hatButton.setColorBackground(color(200));
        }
      } else if (clase.equals("clase2")) {
        if(lastDrum!=3){
          snare.patch(out);
          snare.trigger();
          lastDrum = 3;
          isPlaying1 = false;
          isPlaying2 = false;
          isPlaying3 = true;
          kickButton.setColorBackground(color(200));  
          snareButton.setColorBackground(color(255, 0, 0)); // Rojo
          hatButton.setColorBackground(color(200)); 
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

void draw() {
  background(img);
}
