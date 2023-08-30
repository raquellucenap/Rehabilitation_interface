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
