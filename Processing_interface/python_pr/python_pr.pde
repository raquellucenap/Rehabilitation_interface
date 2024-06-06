import processing.net.*;
import ddf.minim.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;

Server server;  // Server object
Minim minim;
AudioPlayer playerDrum3;  // AudioPlayer object for drum3
AudioPlayer playerDrum6;  // AudioPlayer object for drum6

void setup() {
  size(400, 200);
  server = new Server(this, 12345);  // Listen on port 12345
  minim = new Minim(this);
  playerDrum3 = minim.loadFile("/Users/raquel/Documents/GitHub/Rehabilitation_interface_doc/BodyEvaluation//DataOutputMovenet/drums/drum3.wav");  // Load drum3 audio file
  playerDrum6 = minim.loadFile("/Users/raquel/Documents/GitHub/Rehabilitation_interface_doc/BodyEvaluation//DataOutputMovenet/drums/drum6.wav");  // Load drum6 audio file
}

void draw() {
  // Wait for a client to connect
  Client client = server.available();
  if (client != null) {
    String data = client.readString().trim();
    println("Received class: " + data);

    // Play audio based on the received class
    if (data.equals("clase0")) {
      playerDrum3.rewind();
      playerDrum3.play();
    } else if (data.equals("clase1")) {
      playerDrum6.rewind();
      playerDrum6.play();
    }

    client.stop();  // Close the connection
  }
}

void stop() {
  playerDrum3.close();
  playerDrum6.close();
  minim.stop();
  super.stop();
}
