import processing.sound.*;
import ddf.minim.*;

class SoundClip {

  Minim minim;
  AudioPlayer player;

  SoundClip(String pSoundFile) {
    minim = new Minim(thisApplet);
    player = minim.loadFile(pSoundFile);
  }

  boolean play() {
    if (player != null && player.isPlaying() == false) {
      player.play();
      return true;
    }

    return false;
  }
}
