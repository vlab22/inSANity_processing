class SamBedRoomScene extends SceneWithTransition implements IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton mirrorPlaceButton = new ImageButton( null, round(853 * widthRatio), round(410 * heightRatio), "Sam_bedroom mirror overlay.png");
  ImageButton paintPlaceButton = new ImageButton( null, round(537 * widthRatio), round(311 * heightRatio), "Sam_bedroom paint overlay.png");
  ImageButton underbedPlaceButton = new ImageButton( null, round(19 * widthRatio), round(662 * heightRatio), "Sam_bedroom under bed overlay.png");

  SoundClip footStepsSoundClip;

  UISprite underBedNote = new UISprite(108, 766, "Sam_bedroom under bed note sprite.png");

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  boolean isFlashLightOn;

  boolean noteInScene = true;

  PImage flashLightImage;

  boolean firstTimeInRoom = true;

  SamBedRoomScene() {
    super("Sam_bedroom.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    flashLightImage = loadImage("Flashlight light alpha.png");

    underBedNote.enabled = false;
  }

  void enterState(State oldState) {
    super.enterState(oldState);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    rectMode(CORNER);
    noStroke();

    mirrorPlaceButton.display();
    paintPlaceButton.display();

    if (noteInScene == true) {
      underbedPlaceButton.display();
    }

    backButton.display();
    placeText.display();

    underBedNote.display(delta);

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {

      if (firstTimeInRoom) {
        this.allowMousePressed = false;
        placeText.alpha = 0;
        placeText.textBox.setText("Something happened in the Hallway");
        placeText.show();

        firstTimeInRoom = false;

        soundManager.ATTIC_DOOR_FALL.play();

        Hallway2AtticScene hall = ((Hallway2AtticScene)HALLWAY2_ATTIC_SCENE);
        hall.atticStairsOpen = true;

        waiter.waitForSeconds(3, this, 1, null);
      } else {
        changeState( HALLWAY2_ATTIC_SCENE );
      }
    }

    if (noteInScene == true && underbedPlaceButton.isPointInside( mouseX, mouseY ) ) {
      noteInScene = false;
      underBedNote.enabled = true;
      invManager.PickUpItem("notes_item", new Object[] { "notes_item page 3" }, underBedNote);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();

    if (placeText.alpha > 0)
      placeText.hide();
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    } else if (executeId == 1) {
      changeState( HALLWAY2_ATTIC_SCENE );
      this.allowMousePressed = true;
    }
  }
}
