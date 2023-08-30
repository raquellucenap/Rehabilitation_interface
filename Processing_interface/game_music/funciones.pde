// Función para ejecutar comando de terminal
void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}
//Stop python
void stopPythonScript() {
  if (pythonProcess != null) {
    pythonProcess.destroy(); // Detener el proceso de Python
    isScriptRunning = false;
    println("Script de Python detenido.");
  }
}

//Play tonos
void playTone1() {
  println("play tone", clase1);
  if (clase1 == 1){
    sineDo.play();
    isPlaying1 = true;
    startTimeDo = millis();
  }
  if (clase1 == 2){
    sineRe.play();
    isPlaying2 = true;
    startTimeRe = millis();
  }
  if (clase1 == 3){
    sineMi.play();
    isPlaying3 = true;
    startTimeMi = millis();
  }
  if (clase1 == 4){
    sineFa.play();
    isPlaying4 = true;
    startTimeFa = millis();
  }
  if (clase1 == 5){
    sineSol.play();
    isPlaying5 = true;
    startTimeSol = millis();
  }
  if (clase1 == 6){
    sineLa.play();
    isPlaying6 = true;
    startTimeLa = millis();
  }
  if (clase1 == 7){
    sineSi.play();
    isPlaying7 = true;
    startTimeSi = millis();
  }
  if (clase1 == 8){
    sineDo_.play();
    isPlaying8 = true;
    startTimeDo_ = millis();
  }
}

//Stop tonos
void stopAll(){
  stopTone1();
}
void stopTone1() {
  sineDo.stop();
  isPlaying1 = false;
  sineRe.stop();
  isPlaying2 = false;
  sineMi.stop();
  isPlaying3 = false;
  sineFa.stop();
  isPlaying4 = false;
  sineSol.stop();
  isPlaying5 = false;
  sineLa.stop();
  isPlaying6 = false;
  sineSi.stop();
  isPlaying7 = false;
  sineDo_.stop();
  isPlaying8 = false;
  
  if (clase1 == 1){
    sineDo.stop();
    isPlaying1 = false;
  }
  if (clase1 == 2){
    sineRe.stop();
    isPlaying2 = false;
  }
  if (clase1 == 3){
    sineMi.stop();
    isPlaying3 = false;
  }
  if (clase1 == 4){
    sineFa.stop();
    isPlaying4 = false;
  }
  if (clase1 == 5){
    sineSol.stop();
    isPlaying5 = false;
  }
  if (clase1 == 6){
    sineLa.stop();
    isPlaying6 = false;
  }
  if (clase1 == 7){
    sineSi.stop();
    isPlaying7 = false;
  }
  if (clase1 == 8){
    sineDo_.stop();
    isPlaying8 = false;
  }
}
