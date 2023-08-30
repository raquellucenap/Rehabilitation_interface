String dirWek = "C:/Users/rache/";
String dirPython = "C:\\Users\\rache\\Documents\\Rehabilitation_interface\\dist\\";

// Función seleccionar canción
void selectButtonClicked() {
  selectInput("Selecciona un archivo de audio:", "fileSelected");
}
// Función detener aplicación
void stopButtonClickedPython() {
  // Cambiar el texto del objeto wekinatorLabel
  wekinatorLabel.setText("Para Detener: Cierra la ventana de Wekinator y la consola. En la cámara aprieta y presiona la tecla Q (quit).");
  // Cambiar el estado a "stopped"
  isStopped = true;
}

// Apretar un botón de nota musical
void doButtonClicked() {
  if (!isPlaying1) {
    playTone1();
  } else {
    stopTone1();
  }
  chooseOrder(1);
  println(diccionarioNotas);
}
void reButtonClicked() {
  if (!isPlaying2) {
    playTone2();
  } else {
    stopTone2();
  }
  chooseOrder(2);
}

void miButtonClicked() {
  if (!isPlaying3) {
    playTone3();
  } else {
    stopTone3();
  }
  chooseOrder(3);
}
void faButtonClicked() {
  if (!isPlaying4) {
    playTone4();
  } else {
    stopTone4();
  }
  chooseOrder(4);
}
void solButtonClicked() {
  if (!isPlaying5) {
    playTone5();
  } else {
    stopTone5();
  }
  chooseOrder(5);
}
void laButtonClicked() {
  if (!isPlaying6) {
    playTone6();
  } else {
    stopTone6();
  }
  chooseOrder(6);
}
void siButtonClicked() {
  if (!isPlaying7) {
    playTone7();
  } else {
    stopTone7();
  }
  chooseOrder(7);
}
void do_ButtonClicked() {
  if (!isPlaying8) {
    playTone8();
  } else {
    stopTone8();
  }
  chooseOrder(8);
}
//Detener canción 
void stopButtonClicked() {
  if (soundFile != null && isPlaying) {
    cuePoint = soundFile.position();
    println("CuePoint 1", cuePoint);
    soundFile.pause();
    isPlaying = false;
  }
}
//Continuar canción (error en la velocidad)
void resumeButtonClicked() {
  if (soundFile != null && !isPlaying) {
    soundFile.rate(1.0);  // Ajusta la velocidad de reproducción a su valor predeterminado
    println("CuePoint 2", cuePoint);
    soundFile.play(cuePoint);
    isPlaying = true;
  }
}

// Botones partes del cuerpo 
void caraButtonClicked() {    
  wekinatorLabel.setText("Wekinator parameters: Inputs: 936 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  println(comando);
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"cara";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void manosButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 84 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"ManosWekinator/ManosWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"manos";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoDerechaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"right_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void manoIzquierdaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"left_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void cuerpoEnteroButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 37 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoTorsoButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 16 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"tronco_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoSinCabezaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 24 - Outputs: 1 - Type: All classifiers (default settings) - Classes: X");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"nocara_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
