class FrontDoorScene extends Scene //<>//
{
  //ImageButton   upButton = new ImageButton( "arrowUp.png", 320, 550, "arrowUp outline.png");
  //ImageButton downButton = new ImageButton( "arrowDown.png", 320, 700, "arrowDown outline.png");
  //ImageButton window01Button = new ImageButton( null, 480, 296, "lawn window 00 overlay.png");

  ImageButton window01Button = new ImageButton( null, round(659 * widthRatio), round(196 * heightRatio), "House_front_zoomed front door overlay.png");

  PImage powerDownWindow;
  int powerDownAlpha = 0;
  Ani blinkWindow;
  int blinkCount = 0;
  final int BLINK_MAX = 3;
  boolean blinkAlreadyRan = false;

  FrontDoorScene() {
    super( "House_front_zoomed.png" );

    powerDownWindow = loadImage("House_front_zoomed power off window.png");

    window01Button.overlayColor = color(0, 0, 255);

    blinkWindow = new Ani(this, 0.100, 0, "powerDownAlpha", 255, Ani.LINEAR, this, "onEnd:blinkWindowOn");
    blinkWindow.pause();
  }


  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    //upButton.display();
    //downButton.display();

    window01Button.display();

    tint(255, blinkCount >= BLINK_MAX ? 0 : powerDownAlpha);
    image(powerDownWindow, 237 * widthRatio, 196 * heightRatio, powerDownWindow.width * widthRatio, powerDownWindow.height * heightRatio);

    super.endDisplay();
  }

  void handleMousePressed() {
    //if ( upButton.isPointInside( mouseX, mouseY ) ) {
    //  stateHandler.changeStateTo( TABLE_SCENE );
    //}
    //if ( downButton.isPointInside( mouseX, mouseY ) ) {
    //  stateHandler.changeStateTo( RIVER_SCENE );
    //}

    if ( window01Button.isPointInside( mouseX, mouseY ) ) {
      if (blinkAlreadyRan == false) {
        blinkAlreadyRan = true;
        blinkWindow.start();
      } else if (blinkAlreadyRan == true && blinkWindow.isPlaying() == false) {
        stateHandler.changeStateTo( GROUND_HALLWAY_SCENE ); //<>//
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
      Ani.to(this, 1.3, "powerDownAlpha", 255, Ani.LINEAR, this, "onEnd:changeToNextSceneAfterDelay");
    }
  }

  void changeToNextSceneAfterDelay() {
    stateHandler.changeStateTo( GROUND_HALLWAY_SCENE );
  }
}
