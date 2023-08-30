String dirWek = "C:/Users/rache/";
String dirPython = "C:\\Users\\rache\\Documents\\Rehabilitation_interface\\dist\\";

// Botones partes del cuerpo 
void caraButtonClicked() {    
  wekinatorLabel.setText("Wekinator parameters: Inputs: 936 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  println(comando);
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"cara";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void manosButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 84 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"ManosWekinator/ManosWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"manos";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoDerechaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"right_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void manoIzquierdaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"left_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void cuerpoEnteroButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 37 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoTorsoButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 16 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"tronco_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoSinCabezaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 24 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 2");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start " + dirWek +"CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start " + dirPython +"nocara_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void stopButtonClickedPython() {
  // Cambiar el texto del objeto wekinatorLabel
  wekinatorLabel.setText("Para Detener: Cierra la ventana de Wekinator y la consola. En la cámara aprieta y presiona la tecla Q (quit).");
  
  // Cambiar el estado a "stopped"
  isStopped = true;
}
