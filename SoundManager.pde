import processing.sound.*;
import ddf.minim.*;

class SoundManager {

  final SoundClip LIGHT_BLINK_SOUND = new SoundClip("light blink 01.wav");
  final SoundClip INSERT_BATTERIES_SOUND = new SoundClip("insert batteries.wav");
  final SoundClip PICK_UP_ITEM_01 = new SoundClip("pickuo item 01.mp3");
  final SoundClip PICK_UP_ITEM_02 = new SoundClip("pickuo item 02.mp3");
  final SoundClip FLASHLIGHT_ON = new SoundClip("flashlight on.wav");
  final SoundClip FLASHLIGHT_OFF = new SoundClip("flashlight off.wav");
  final SoundClip ATTIC_DOOR_FALL = new SoundClip("attic door open.wav");
  final SoundClip FOOT_STEPS = new SoundClip("footstep01 0.800 seconds.wav");
  final SoundClip OPEN_DOOR = new SoundClip("53280__the-bizniss__front-door-open.wav");
  final SoundClip[] PICKUP_PAGE = new SoundClip[] { 
    new SoundClip("pickup page 01.wav"), 
    new SoundClip("pickup page 02.wav")
  };
  final SoundClip[] PAGE_FLIP = new SoundClip[] { 
    new SoundClip("page flip 01.wav"), 
    new SoundClip("page flip 02.wav")
  };

  //Music and BG
  final SoundClip BG_SOUND = new SoundClip("Insanity_BG_Audio.wav");
  final SoundClip LIVINGROOM_MUSIC = new SoundClip("Living Room Fireplace and Family photos.wav");
  final SoundClip ATTIC_MUSIC = new SoundClip("Attic with fade out.wav");

  final SoundClip LIMBO_SOUND = new SoundClip("Lets Play Limbo (Blind) - Part 4 - Medium Speed Chase.wav");

  final SoundClip[] sounds = new SoundClip[] {
    INSERT_BATTERIES_SOUND, 
    PICK_UP_ITEM_01, 
    PICK_UP_ITEM_02, 
    FLASHLIGHT_ON, 
    PICKUP_PAGE[0], 
    PICKUP_PAGE[1], 
    PAGE_FLIP[0], 
    PAGE_FLIP[1], 
    OPEN_DOOR, 
    ATTIC_DOOR_FALL, 
  };

  HashSet<SoundClip> soundsPlaying;

  SoundManager() {
    println( "new SoundManager()");

    soundsPlaying = new HashSet<SoundClip>();
  }

  void step(float delta) {
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

  float FADEOUT_DURATION = 2;

  SoundFile player;

  float amp = 1;

  boolean isFadingOut;

  float fooLoop; //used to make a fake Ani only to wait and run a callback <-- ugly but productive
  float fooPlay;

  Ani anim;

  SoundClip(String pSoundFile) {
    //player = minim.loadFile(pSoundFile);
    println(pSoundFile);
    player = new SoundFile(thisApplet, pSoundFile);
  }

  boolean play() {
    if (player.isPlaying() == false) {
      amp = 1;
      player.amp(amp);
      player.play();
      return true;
    } else if (player.isPlaying() && isFadingOut) {
      fooLoop = 0;
      float wait = map(amp, 0, 1, 0, FADEOUT_DURATION);
      Ani.to(this, wait, 0, "fooPlay", 1, Ani.LINEAR, this, "onEnd:playAgainAfterFadeOut");
    }

    return false;
  }

  boolean loop() {
    if (player != null && player.isPlaying() == false) {
      amp = 1;
      player.amp(amp);
      player.loop();
      return true;
    } else if (player.isPlaying() && isFadingOut) {
      fooLoop = 0;
      float wait = map(amp, 0, 1, 0, FADEOUT_DURATION);
      Ani.to(this, wait, 0, "fooLoop", 1, Ani.LINEAR, this, "onEnd:loopAgainAfterFadeOut");
    }

    return false;
  }

  void playAgainAfterFadeOut() {
    this.play();
  }

  void loopAgainAfterFadeOut() {
    this.loop();
  }

  boolean fadeOut() {

    if (player.isPlaying()) {
      anim = Ani.to(this, FADEOUT_DURATION, 0, "amp", 0, Ani.LINEAR, this, "onUpdate:fadeOutUpdate, onEnd:fadeOutEnd");
      isFadingOut = true;
      return true;
    }

    return false;
  }

  void fadeOutUpdate() {
    player.amp(amp);
  }

  void fadeOutEnd() {
    if (player.isPlaying()) {
      player.stop();
    }
    isFadingOut = false;
  }
}
