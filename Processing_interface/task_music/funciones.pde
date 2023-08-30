void playTone1() {
  sineDo.play();
  isPlaying1 = true;
  startTimeDo = millis();
}

void stopTone1() {
  sineDo.stop();
  isPlaying1 = false;
}

void playTone2() {
  sineRe.play();
  isPlaying2 = true;
  startTimeRe = millis();
}

void stopTone2() {
  sineRe.stop();
  isPlaying2 = false;
}

void playTone3() {
  sineMi.play();
  isPlaying3 = true;
  startTimeMi = millis();
}

void stopTone3() {
  sineMi.stop();
  isPlaying3 = false;
}

void playTone4() {
  sineFa.play();
  isPlaying4 = true;
  startTimeFa = millis();
}

void stopTone4() {
  sineFa.stop();
  isPlaying4 = false;
}

void playTone5() {
  sineSol.play();
  isPlaying5 = true;
  startTimeSol = millis();
}

void stopTone5() {
  sineSol.stop();
  isPlaying5 = false;
}
void playTone6() {
  sineLa.play();
  isPlaying6 = true;
  startTimeLa = millis();
}

void stopTone6() {
  sineLa.stop();
  isPlaying6 = false;
}
void playTone7() {
  sineSi.play();
  isPlaying7 = true;
  startTimeSi = millis();
}

void stopTone7() {
  sineSi.stop();
  isPlaying7 = false;
}
void playTone8() {
  sineDo_.play();
  isPlaying8 = true;
  startTimeDo_ = millis();
}
void stopTone8() {
  sineDo_.stop();
  isPlaying8 = false;
}

void stopAll(){
  stopTone1();
  stopTone2();
  stopTone3();
  stopTone4();
  stopTone5();
  stopTone6();
  stopTone7();
  stopTone8();
}


int getKeyFromValue(HashMap<Integer, String> map, String value) {
  for (Map.Entry<Integer, String> entry : map.entrySet()) {
    if (entry.getValue().equals(value)) {
      return entry.getKey();
    }
  }
  // Si no se encuentra el valor, puedes devolver un valor especial o lanzar una excepción
  // En este ejemplo, devolvemos -1 para indicar que no se encontró la clave
  return -1;
}
// Convertir de entero a string (nota musical)
String mapToString(HashMap<Integer, String> map) {
  StringBuilder sb = new StringBuilder();
  for (Map.Entry<Integer, String> entry : map.entrySet()) {
    sb.append("(").append(entry.getKey()).append(", ").append(entry.getValue()).append("), ");
  }
  
  // Eliminar la coma y el espacio al final
  if (sb.length() > 2) {
    sb.setLength(sb.length() - 2);
  }
  return sb.toString();
}
    
// Función para ejecutar comando de terminal
void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}

//Seleccionar canción
void fileSelected(File selection) {
  if (selection != null) {
    if (soundFile != null) {
      soundFile.stop();
      //soundFile.close();
    }
    soundFile = new SoundFile(this, selection.getAbsolutePath());
    if (soundFile != null) {
      soundFile.amp(0.5);
    }
    soundFile.play();
    isPlaying = true;
    
    selectedSongLabel.setText("Canción seleccionada: " + selection.getName());
  }
}

//Función elegir orden notas
void chooseOrder(int note){
  if (currentSelected < maxSelected){
    diccionarioNotas.put(currentSelected, buttonText[note-1]);
    //diccionario.put(currentSelected, note);
    currentSelected += 1;
    diccionarioOrder.setText(mapToString(diccionarioNotas));
  }
}
