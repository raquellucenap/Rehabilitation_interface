// Importar la librería de Processing
import processing.core.*;

// Declarar las variables necesarias
PImage imagen1, imagen2, imagen3, imagen4;
Button boton1, boton2, boton3, boton4;

//Base Path to change
String basePath = "C:\\Users\\rache\\Documents\\Rehabilitation_interface";

String wekinatorPath = basePath + "\\Wekinator\\Wekinator.wekproj";
String game1Path = basePath + "\\music_task\\music_task.pde";
String game2Path = basePath + "\\music_game\\music_game.pde";
String game3Path = basePath + "\\drums_task\\drums_task.pde";
String game4Path = basePath + "\\drums_game\\drums_game.pde";

// Función de configuración
void setup() {
  // Crear una ventana de visualización
  size(1600, 900);
  
  // Cargar las imágenes
  imagen1 = loadImage("1.png");
  imagen2 = loadImage("2.png");
  imagen3 = loadImage("3.png");
  imagen4 = loadImage("4.png");
  // Crear los botones
  boton1 = new Button(0, 0, width/2, height/2, imagen1, "Frase 1");
  boton2 = new Button(width/2, 0, width/2, height/2, imagen2, "Frase 2");
  boton3 = new Button(0, height/2, width/2, height/2, imagen3, "Frase 3");
  boton4 = new Button(width/2, height/2, width/2, height/2, imagen4, "Frase 3");
}

// Función de dibujo
void draw() {
  //background(img);
  // Dibujar los botones
  boton1.display();
  boton2.display();
  boton3.display();
  boton4.display();
}

// Manage clicks
void mouseClicked() {
  // Verificar si se hizo clic en alguno de los botones
  if (boton1.isClicked()) {
    ejecutarComandoTerminal("cmd /c start " + game1Path);
  } else if (boton2.isClicked()) {
    ejecutarComandoTerminal("cmd /c start " + game2Path);
  } else if (boton3.isClicked()) {
    ejecutarComandoTerminal("cmd /c start " + game3Path);
  } else if (boton4.isClicked()) {
    ejecutarComandoTerminal("cmd /c start " + game4Path);
  }
}

// Clase Button
class Button {
  float x, y, width, height;
  PImage image;
  String frase;
  
  Button(float x, float y, float width, float height, PImage image, String frase) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.image = image;
    this.frase = frase;
  }
  void display() {
    // Dibujar el borde del botón
    stroke(0);  // Color negro
    strokeWeight(15);  // Grosor del borde
    rect(x, y, width, height);
    
    // Dibujar la imagen dentro del borde
    image(image, x, y, width, height);
  }
  boolean isClicked() {
    // Verificar si se hizo clic en el botón
    return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
  }
  
  String getFrase() {
    // Obtener la frase asociada al botón
    return frase;
  }
}
void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}
