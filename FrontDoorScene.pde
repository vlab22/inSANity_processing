import processing.sound.*; //<>// //<>//

class FrontDoorScene extends SceneWithTransition
{
  //ImageButton   upButton = new ImageButton( "arrowUp.png", 320, 550, "arrowUp outline.png");
  //ImageButton downButton = new ImageButton( "arrowDown.png", 320, 700, "arrowDown outline.png");
  //ImageButton window01Button = new ImageButton( null, 480, 296, "lawn window 00 overlay.png");

  ImageButton doorButton = new ImageButton( null, round(659 * widthRatio), round(196 * heightRatio), "House_front_zoomed front door overlay.png");

  PImage powerDownWindow;
  PImage powerDownWallLight;
  int powerDownAlpha = 0;
  Ani blinkWindow;
  int blinkCount = 0;
  final int BLINK_MAX = 5;
  boolean blinkAlreadyRan = false;

  SoundClip frontDoorOpenSoundClip;
  SoundClip footStepsSoundClip;
  SoundClip lightBlinkSoundClip;

  FrontDoorScene() {
    super( "House_front_zoomed.png" );

    powerDownWindow = loadImage("House_front_zoomed power off window.png");
    powerDownWallLight = loadImage("House_front_zoomed wall light off.png");


    frontDoorOpenSoundClip = new SoundClip("53280__the-bizniss__front-door-open.wav");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
    lightBlinkSoundClip = new SoundClip("light blink 01.wav");

    blinkWindow = new Ani(this, 0.100, 0, "powerDownAlpha", 255, Ani.LINEAR, this, "onEnd:blinkWindowOn");
    blinkWindow.pause();
  }


  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    doorButton.display();

    tint(255, blinkCount >= BLINK_MAX ? 0 : powerDownAlpha);
    image(powerDownWindow, 237 * widthRatio, 196 * heightRatio, powerDownWindow.width * widthRatio, powerDownWindow.height * heightRatio);
    image(powerDownWallLight, 1308 * widthRatio, 189 * heightRatio, powerDownWallLight.width * widthRatio, powerDownWallLight.height * heightRatio);

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {

    if ( doorButton.isPointInside( mouseX, mouseY ) ) {
      if (blinkAlreadyRan == false) {
        blinkAlreadyRan = true;
        lightBlinkSoundClip.play();
        blinkWindow.start();
      } else if (blinkAlreadyRan == true && blinkWindow.isPlaying() == false) {
        changeToNextSceneAfterDelay();
      }
    }
  }

  void blinkWindowOn() {
    blinkCount++;
    if (blinkCount < BLINK_MAX) {
      blinkWindow.setEnd(0);
      blinkWindow.setBegin(255);
      blinkWindow.setDelay(0);
      blinkWindow.start();
    } else {
      Ani.to(this, 0.5, "powerDownAlpha", 255, Ani.LINEAR, this, "onEnd:changeToNextSceneAfterDelay");
    }
  }

  void changeToNextSceneAfterDelay() {
    changeState( GROUND_HALLWAY_SCENE );
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
    frontDoorOpenSoundClip.play();
    footStepsSoundClip.play();
  }
}
