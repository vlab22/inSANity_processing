import processing.sound.*;
import ddf.minim.*;

class SoundManager {

  final SoundClip INSERT_BATTERIES_SOUND = new SoundClip("insert batteries.wav");
  final SoundClip PICK_UP_ITEM_01 = new SoundClip("pickuo item 01.mp3");
  final SoundClip PICK_UP_ITEM_02 = new SoundClip("pickuo item 02.mp3");
  final SoundClip FLASHLIGHT_ON = new SoundClip("flashlight on.wav");
  final SoundClip FLASHLIGHT_OFF = new SoundClip("flashlight off.wav");

  final SoundClip[] sounds = new SoundClip[] {
    INSERT_BATTERIES_SOUND, 
    PICK_UP_ITEM_01, 
    PICK_UP_ITEM_02, 
    FLASHLIGHT_ON
  };

  SoundManager() {
    println( "new SoundManager()");
  }

  void playCategory(ItemCategory category) {
    switch (category) {
    case NOTE:
      break;
    case TOOL:
      break;
    default:
    }
  }

  void playPickUpItem(String itemName) {
    switch (itemName) {
    case "notes_item":
      break;
    case "batteries_item":
      PICK_UP_ITEM_01.play();
      break;
    case "flashlight_item":
      PICK_UP_ITEM_02.play();
      break;
    default:
    }
  }

  void playItemClicked(String itemName) {
    switch (itemName) {
    case "notes_item":
      break;
    case "flashlight_batteries_item_on":
      FLASHLIGHT_ON.play();
      break;
    case "flashlight_batteries_item_off":
      FLASHLIGHT_OFF.play();
      break;
    default:
    }
  }
}

class SoundClip {

  //Minim minim;
  //AudioPlayer player;
  SoundFile player;

  SoundClip(String pSoundFile) {
    //minim = new Minim(thisApplet);
    //player = minim.loadFile(pSoundFile);
    println(pSoundFile);
    player = new SoundFile(thisApplet, pSoundFile);
  }

  boolean play() {
    //if (player != null && player.isPlaying() == false) {
    //  player.play();
    //  return true;
    //}

    if (player != null && player.isPlaying() == false) {
      player.play();
      return true;
    }

    return false;
  }
}
