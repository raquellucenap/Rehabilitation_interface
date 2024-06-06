import processing.video.*;
import java.io.File;

Capture cam;
int numClases;
int numFotos;
String path_to_data = "/Users/raquel/Documents/GitHub/Rehabilitation_interface_doc/BodyEvaluation/Data";
boolean capturing = false;

boolean executed = false;
void setup() {
  size(640, 480);
  cam = new Capture(this, width, height);
  numClases = 2;
  numFotos = 5;
  cam.start();
  if (!new File(path_to_data).exists()) {
    new File(path_to_data).mkdir();
  }
  for (int i = 0; i < numClases; i++) {
    String folderName = "clase" + i;
    String folderPath = path_to_data + "/" + folderName;
    if (!new File(folderPath).exists()) {
      new File(folderPath).mkdir();
    }
  }
}

void draw() {
  if(!executed){
    if (cam.available()) {    
      for (int i = 0; i < numClases; i++) {
        String folderName = "clase" + i;
        for (int j = 0; j < numFotos; j++) {
          cam.read();
          image(cam, 0, 0, width, height); 
          String fileName = folderName + "/photo_" +j + ".png";
          saveFrame(path_to_data + "/" + fileName);
          delay(500);
        }
      }
      println("Fotos guardadas en las carpetas correspondientes.");
      executed = true;
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void exit() {
  cam.stop();
  super.exit();
}
