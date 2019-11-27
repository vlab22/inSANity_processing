import processing.sound.*;
import ddf.minim.*;

class SoundManager {

  final SoundClip INSERT_BATTERIES_SOUND = new SoundClip("insert batteries.wav");
  final SoundClip PICK_UP_ITEM_01 = new SoundClip("pickuo item 01.mp3");
  final SoundClip PICK_UP_ITEM_02 = new SoundClip("pickuo item 02.mp3");
  final SoundClip FLASHLIGHT_ON = new SoundClip("flashlight on.wav");
  final SoundClip FLASHLIGHT_OFF = new SoundClip("flashlight off.wav");
  final SoundClip ATTIC_DOOR_FALL = new SoundClip("attic door open.wav");
  final SoundClip FOOT_STEPS = new SoundClip("footstep01 0.800 seconds.wav");
  final SoundClip[] PICKUP_PAGE = new SoundClip[] { 
    new SoundClip("pickup page 01.wav"), 
    new SoundClip("pickup page 02.wav")
  };
  final SoundClip[] PAGE_FLIP = new SoundClip[] { 
    new SoundClip("page flip 01.wav"), 
    new SoundClip("page flip 02.wav")
  };
  
  final SoundClip LIMBO_SOUND = new SoundClip("Lets Play Limbo (Blind) - Part 4 - Medium Speed Chase.wav");

  final SoundClip[] sounds = new SoundClip[] {
    INSERT_BATTERIES_SOUND, 
    PICK_UP_ITEM_01, 
    PICK_UP_ITEM_02, 
    FLASHLIGHT_ON, 
    PICKUP_PAGE[0], 
    PICKUP_PAGE[1], 
    PAGE_FLIP[0],
    PAGE_FLIP[1]
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
      int rand = int(random(0, PICKUP_PAGE.length));
      PICKUP_PAGE[rand].play();
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
      PICKUP_PAGE[1].play();
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
