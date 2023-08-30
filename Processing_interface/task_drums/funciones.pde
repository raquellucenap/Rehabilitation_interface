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
// Función para ejecutar comando de terminal
void ejecutarComandoTerminal(String comando) {
  try {
    Runtime.getRuntime().exec(comando);
  } catch (IOException e) {
    println("Error al ejecutar el comando de terminal: " + e.getMessage());
  }
}

void stopPythonScript() {
  if (pythonProcess != null) {
    pythonProcess.destroy(); // Detener el proceso de Python
    isScriptRunning = false;
    println("Script de Python detenido.");
  }
}
