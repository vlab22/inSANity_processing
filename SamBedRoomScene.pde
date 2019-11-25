class SamBedRoomScene extends SceneWithTransition implements IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton mirrorPlaceButton = new ImageButton( null, round(853 * widthRatio), round(410 * heightRatio), "Sam_bedroom mirror overlay.png");
  ImageButton paintPlaceButton = new ImageButton( null, round(537 * widthRatio), round(311 * heightRatio), "Sam_bedroom paint overlay.png");
  ImageButton underbedPlaceButton = new ImageButton( null, round(19 * widthRatio), round(662 * heightRatio), "Sam_bedroom under bed overlay.png");

  SoundClip footStepsSoundClip;

  UISprite underBedNote = new UISprite(round(108 * widthRatio), round(766 * heightRatio), "Sam_bedroom under bed note sprite.png");

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  boolean isFlashLightOn;

  boolean noteInScene = true;

  PImage flashLightImage;

  SamBedRoomScene() {
    super("Sam_bedroom.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    flashLightImage = loadImage("Flashlight light alpha.png");
    
    underBedNote.enabled = false;
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    //isFlashLightOn = playerHasFlashLight == true && playerHasBatteries == true;

    //if (playerHasFlashLight == false) {
    //  placeText.show();
    //} else if (playerHasFlashLight == true && playerHasBatteries == false) {
    //  placeText.textBox.setText("I have a flashlight but where are the batteries?\r\nMaybe in the garage too.");
    //  placeText.show();
    //} else if (playerHasFlashLight == false && playerHasBatteries == true) {
    //  placeText.textBox.setText("I have some batteries but where is the flashlight?\r\nMaybe in the garage too.");
    //  placeText.show();
    //} else if (isFlashLightOn) {
    //  placeText.textBox.setText("Now I can see...");
    //  placeText.show();
    //  placeText.hideDuration = 3;
    //  waiter.waitForSeconds(2, this, 0, null);
    //}

    //playerHasFlashLight = true;
    //playerHasBatteries = true;
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    rectMode(CORNER);
    noStroke();

    float blackAlpha = 0.975 * 255; //to set alpha of image and filler rects

    //if (isFlashLightOn) {
    //  pushStyle();
    //  tint(1, blackAlpha);
    //  imageMode(CENTER);
    //  image(flashLightImage, mouseX, mouseY);
    //  popStyle();

    //  //Fill screen with 4 rectangles sorrounding the flashlight image
    //  fill(1, 1, 1, blackAlpha);
    //  rectMode(CORNER);
    //  rect(0, 0, width, mouseY - flashLightImage.height * 0.5);
    //  rect(0, mouseY + flashLightImage.height * 0.5, width, height - mouseY + flashLightImage.height * 0.5);
    //  rect(0, mouseY - flashLightImage.height * 0.5, mouseX - flashLightImage.width * 0.5, flashLightImage.height);
    //  rect(mouseX + flashLightImage.width * 0.5, mouseY - flashLightImage.height * 0.5, width - mouseX + flashLightImage.width * 0.5, flashLightImage.height);
    //} else {
    //  fill(1, 1, 1, blackAlpha);
    //  rect(0, 0, width, height);
    //}

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
      changeState( HALLWAY2_ATTIC_SCENE );
    }

    if (noteInScene == true && underbedPlaceButton.isPointInside( mouseX, mouseY ) ) {
      noteInScene = false;
      underBedNote.enabled = true;
      invManager.PickUpItem("notes_item", new Object[] { "notes_item page 4" }, underBedNote);
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
    }
  }
}
