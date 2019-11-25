class GarageScene extends SceneWithTransition implements IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton shelfPlaceButton = new ImageButton( null, round(31 * widthRatio), round(326 * heightRatio), "Garage shelf overlay.png");

  SoundClip footStepsSoundClip;

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  GarageScene() {
    super("Garage.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  void enterState(State oldState) {
    super.enterState(oldState);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    rectMode(CORNER);
    noStroke();

    shelfPlaceButton.display();
    backButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState(GROUND_HALLWAY_SCENE);
    }
    if ( shelfPlaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState(GARAGE_SHELF_SCENE);
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

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

class GarageShelfScene extends SceneWithTransition implements IWaiter, IHasHiddenLayer {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton flashLightPlaceButton = new ImageButton( null, round(717 * widthRatio), round(388 * heightRatio), "flashlight_item outline.png");
  ImageButton batteriesPlaceButton = new ImageButton( null, round(831 * widthRatio), round(783 * heightRatio), "batteries_item outline.png");

  UISprite flashLigthSprite = new UISprite(round(717 * widthRatio), round(388 * heightRatio), "flashlight_item.png");
  UISprite batteriesSprite = new UISprite(round(831 * widthRatio), round(783 * heightRatio), "batteries_item.png");

  SoundClip footStepsSoundClip;

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  boolean flashLightInScene = true;
  boolean batteriesInScene = true;

  PImage hiddenImage;

  GarageShelfScene() {
    super("Garage_shelf.png");
    hiddenImage = loadImage("Garage_shelf hidden.png");

    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  void enterState(State oldState) {
    super.enterState(oldState);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    rectMode(CORNER);
    noStroke();

    backButton.display();

    flashLigthSprite.display(delta);
    if (flashLightInScene == true)
      flashLightPlaceButton.display();

    batteriesSprite.display(delta);
    if (batteriesInScene == true)
      batteriesPlaceButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState(GROUND_HALLWAY_SCENE);
    }
    if ( flashLightInScene == true && flashLightPlaceButton.isPointInside( mouseX, mouseY ) ) {
      flashLightInScene = false;
      invManager.PickUpItem("flashlight_item", new Object[] { "flashlight_item item 0" }, flashLigthSprite);
    }
    if ( batteriesInScene == true && batteriesPlaceButton.isPointInside( mouseX, mouseY ) ) {
      batteriesInScene = false;
      invManager.PickUpItem("batteries_item", new Object[] { "batteries_item item 0" }, batteriesSprite);
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

  PImage getHiddenImage() {
    return hiddenImage;
  }
}
