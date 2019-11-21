import processing.sound.*;

class SoundClip {
  SoundFile soundFile;

  SoundClip(String pSoundFile) {
    soundFile = new SoundFile(thisApplet, pSoundFile);
  }
  
  boolean play() {
    if (soundFile != null && soundFile.isPlaying() == false) {
      soundFile.play();
      return true;
    }
    
    return false;
  }
}
