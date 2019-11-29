import processing.sound.*;

class FrontHouseScene extends SceneWithTransition implements IWaiter
{
  ImageButton houseFrontDoorButton = new ImageButton(null, round(967 * widthRatio), round(655 * heightRatio), "House_front door overlay.png");

  TextBoxWithFader placeText = new TextBoxWithFader();

  FrontHouseScene() {
    super( "House_front.png" );

    background = loadImage( filename );
  }

  void enterState( State oldState )
  {
    super.enterState(oldState);

    placeText.textBox.setText("My childhood house. My mother left my diary on\r\nthe fireplace's table");
    placeText.alpha = 0;
    placeText.show();

    soundManager.BG_SOUND.loop();

    waiter.waitForSeconds(12, this, 0, null);
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    }
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    houseFrontDoorButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( houseFrontDoorButton.isPointInside( mouseX, mouseY ) ) {
      changeState( FRONTDOOR_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();
  }
}

class FrontDoorScene extends SceneWithTransition
{
  //ImageButton   upButton = new ImageButton( "arrowUp.png", 320, 550, "arrowUp outline.png");
  //ImageButton downButton = new ImageButton( "arrowDown.png", 320, 700, "arrowDown outline.png");
  //ImageButton window01Button = new ImageButton( null, 480, 296, "lawn window 00 overlay.png");

  ImageButton doorButton = new ImageButton( null, round(666 * widthRatio), round(175 * heightRatio), "House_front_zoomed front door overlay.png");

  PImage powerDownWindow;
  //PImage powerDownWallLight;
  int powerDownAlpha = 0;
  Ani blinkWindow;
  int blinkCount = 0;
  final int BLINK_MAX = 5;
  boolean blinkAlreadyRan = false;

  FrontDoorScene() {
    super( "House_front_zoomed.png" );

    powerDownWindow = loadImage("House_front_zoomed power off window.png");
    //powerDownWallLight = loadImage("House_front_zoomed wall light off.png");

    blinkWindow = new Ani(this, 0.100, 0, "powerDownAlpha", 255, Ani.LINEAR, this, "onEnd:blinkWindowOn");
    blinkWindow.pause();
  }


  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    doorButton.display();

    tint(255, blinkCount >= BLINK_MAX ? 0 : powerDownAlpha);
    image(powerDownWindow, 267 * widthRatio, 207 * heightRatio, powerDownWindow.width * widthRatio, powerDownWindow.height * heightRatio);
    //image(powerDownWallLight, 1308 * widthRatio, 189 * heightRatio, powerDownWallLight.width * widthRatio, powerDownWallLight.height * heightRatio);

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {

    if ( doorButton.isPointInside( mouseX, mouseY ) ) {
      if (blinkAlreadyRan == false) {
        blinkAlreadyRan = true;
        soundManager.LIGHT_BLINK_SOUND.play();
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
    soundManager.FOOT_STEPS.play();
    soundManager.OPEN_DOOR.play();
  }
}
