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
//void doButtonClicked() {
//  if (!isPlaying1) {
//    playTone1();
//  } else {
//    stopTone1();
//  }
//  return 1;
//}

//void reButtonClicked() {
//  if (!isPlaying2) {
//    playTone2();
//  } else {
//    stopTone2();
//  }
//}

//void miButtonClicked() {
//  if (!isPlaying3) {
//    playTone3();
//  } else {
//    stopTone3();
//  }
//}
//void faButtonClicked() {
//  if (!isPlaying4) {
//    playTone4();
//  } else {
//    stopTone4();
//  }
//}
//void solButtonClicked() {
//  if (!isPlaying5) {
//    playTone5();
//  } else {
//    stopTone5();
//  }
//}

//void laButtonClicked() {
//  if (!isPlaying6) {
//    playTone6();
//  } else {
//    stopTone6();
//  }
//}
//void siButtonClicked() {
//  if (!isPlaying7) {
//    playTone7();
//  } else {
//    stopTone7();
//  }
//}
//void do_ButtonClicked() {
//  if (!isPlaying8) {
//    playTone8();
//  } else {
//    stopTone8();
//  }
//}

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
void stopButtonClicked() {
  if (soundFile != null && isPlaying) {
    cuePoint = soundFile.position();
    println("CuePoint 1", cuePoint);
    soundFile.pause();
    isPlaying = false;
  }
}
void resumeButtonClicked() {
  if (soundFile != null && !isPlaying) {
    soundFile.rate(1.0);  // Ajusta la velocidad de reproducción a su valor predeterminado
    println("CuePoint 2", cuePoint);
    soundFile.play(cuePoint);
    isPlaying = true;
  }
}


void manosButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 84 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/ManosWekinator/ManosWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\manos";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoDerechaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\right_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void manoIzquierdaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 42 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\left_hand";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void cuerpoEnteroButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 37 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoTorsoButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 16 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\tronco_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}
void cuerpoSinCabezaButtonClicked() {
  wekinatorLabel.setText("Wekinator parameters: Inputs: 24 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CuerpoWekinator/CuerpoWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\nocara_cuerpo";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void caraButtonClicked() {    
  wekinatorLabel.setText("Wekinator parameters: Inputs: 936 - Outputs: 1 - Type: All classifiers (default settings) - Classes: 5");
  // Ejecutar el comando de terminal
  String comando = "cmd /c start C:/Users/rache/CaraWekinator/CaraWekinator.wekproj";
  ejecutarComandoTerminal(comando);
  comando = "cmd /c start C:\\Users\\rache\\Documents\\MusicTFM\\dist\\cara";
  ejecutarComandoTerminal(comando);
  isStopped = false;
}

void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}
