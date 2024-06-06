import processing.video.*;
import java.io.File;
import oscP5.*;

Capture cam;
OscP5 oscP5;
int port = 12345;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height);
  cam.start();
  oscP5 = new OscP5(this, port);
}
byte[] imageToBytes(PImage img) {
  img.loadPixels();
  byte[] imgData = new byte[img.pixels.length * 3];
  int index = 0;
  for (int i = 0; i < img.pixels.length; i++) {
    imgData[index++] = (byte) (img.pixels[i] >> 16 & 0xFF); // Red
    imgData[index++] = (byte) (img.pixels[i] >> 8 & 0xFF);  // Green
    imgData[index++] = (byte) (img.pixels[i] & 0xFF);       // Blue
  }
  return imgData;
}
void draw() {
  if (cam.available()) {        
    cam.read();
    image(cam, 0, 0, width, height);
    PImage img = get(0,0,width, height);
    byte[] imgData =imageToBytes(img);
    // Convert the captured image to bytes
    // Create an OSC message with the image data
    OscMessage message = new OscMessage("/image");
    message.add(imgData);
    // Send the OSC message to Python
    oscP5.send(message, "127.0.0.1", 12345); // Adjust IP and port as needed
    // Delay is optional; you can adjust it as needed
    //delay(500); 
  }
}
