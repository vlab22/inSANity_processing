class SamBedRoomScene extends SceneWithTransition implements IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton mirrorPlaceButton = new ImageButton( null, round(853 * widthRatio), round(410 * heightRatio), "Sam_bedroom mirror overlay.png");
  ImageButton paintPlaceButton = new ImageButton( null, round(537 * widthRatio), round(311 * heightRatio), "Sam_bedroom paint overlay.png");
  ImageButton underbedPlaceButton = new ImageButton( null, round(19 * widthRatio), round(662 * heightRatio), "Sam_bedroom under bed overlay.png");

  UISprite underBedNote = new UISprite(108, 766, "Sam_bedroom under bed note sprite.png");

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  boolean isFlashLightOn;

  boolean allowUnderBed = false;  //Flag activated by mirror hiddencollider using the blacklight
  boolean noteInScene = true;

  PImage flashLightImage;

  boolean firstTimeInRoom = true;

  SamBedRoomScene() {
    super("Sam_bedroom.png");

    flashLightImage = loadImage("Flashlight light alpha.png");

    underBedNote.enabled = false;

    placeText.enabled = false;
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

    if (allowUnderBed == true && noteInScene == true) {
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
        this.stateAllowMousePressed = false;
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

    if ( mirrorPlaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState(SAM_BEDROOM_MIRROR_SCENE);
    }

    if ( paintPlaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState(SAM_BEDROOM_PAINTING_SCENE);
    }

    if (allowUnderBed == true && noteInScene == true && underbedPlaceButton.isPointInside( mouseX, mouseY ) ) {
      noteInScene = false;
      underBedNote.enabled = true;
      invManager.PickUpItem("notes_item", new Object[] { "notes_item page 3" }, underBedNote);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();

    if (placeText.alpha > 0)
      placeText.hide();
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    } else if (executeId == 1) {
      changeState( HALLWAY2_ATTIC_SCENE );
      this.stateAllowMousePressed = true;
    }
  }
}

class SamBedRoomMirrorScene extends SceneWithTransition implements IHasHiddenLayer {
  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  PImage hiddenImage;

  HiddenCollider[] hiddenColliders = new HiddenCollider[] {
    new HiddenCollider(this, "unlock sam under bed button", 810, 505, 191, 259)
  };

  SamBedRoomMirrorScene() {
    super("Sam_bedroom_mirror.png");
    hiddenImage = loadImage("Sam_bedroom_mirror hidden.png");
    hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));
  }

  void enterState(State oldState) {
    super.enterState(oldState);
  }

  void checkMessages() {
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState(SAM_BEDROOM_SCENE);
    }
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();

    if (placeText.alpha > 0)
      placeText.hide();
  }

  PImage getHiddenImage() {
    return hiddenImage;
  }

  HiddenCollider[] getHiddenColliders() {
    return hiddenColliders;
  }

  void hiddenColliderHit(HiddenCollider hc) {
    hc.enabled = false;  //allways disable the collider stop the collision detection

    //Enable the underBed overlay in SAM_B
    SamBedRoomScene samBed = (SamBedRoomScene)SAM_BEDROOM_SCENE;
    samBed.allowUnderBed = true;
  }
}

class SamBedRoomPaintingScene extends SceneWithTransition implements IHasHiddenLayer {
  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );

  PImage hiddenImage;

  boolean firstTimeInScene = false;

  HiddenCollider[] hiddenColliders = new HiddenCollider[] {
    new HiddenCollider(this, "unlock sam under bed button", 810, 505, 191, 259)
  };

  SamBedRoomPaintingScene() {
    super("Sam_bedroom_painting.png");
    hiddenImage = null; //loadImage("Sam_bedroom_mirror hidden.png");
    //hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    if (firstTimeInScene == false) {
      textManager.showText("Aah I remember my old blacklight,\r\nspend a lot of time with that thing when I was young", 5, 0.6);
      firstTimeInScene = true;
    }
  }

  void checkMessages() {
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState(SAM_BEDROOM_SCENE);
    }
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();
  }

  PImage getHiddenImage() {
    return hiddenImage;
  }

  HiddenCollider[] getHiddenColliders() {
    return hiddenColliders;
  }

  void hiddenColliderHit(HiddenCollider hc) {
    hc.enabled = false;  //allways disable the collider stop the collision detection
  }
}
