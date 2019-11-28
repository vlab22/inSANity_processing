class GarageScene extends SceneWithTransition implements IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton shelfPlaceButton = new ImageButton( null, round(31 * widthRatio), round(326 * heightRatio), "Garage shelf overlay.png");
  ImageButton carPlaceButton = new ImageButton( null, round(800 * widthRatio), round(395 * heightRatio), "Garage car overlay.png");

  TextBoxWithFader placeText = new TextBoxWithFader("none", false);

  boolean carPlaceEnabled = false;

  GarageScene() {
    super("Garage.png");

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

    shelfPlaceButton.display();
    backButton.display();

    if (carPlaceEnabled){
      carPlaceButton.display();
    }

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
    if (carPlaceEnabled && carPlaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState(CAR_INSIDE_SCENE);
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
    }
  }
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

class GarageShelfScene extends SceneWithTransition implements IWaiter/*, IHasHiddenLayer*/ {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton flashLightPlaceButton = new ImageButton( null, round(776 * widthRatio), round(388 * heightRatio), "flashlight_item outline.png");
  ImageButton batteriesPlaceButton = new ImageButton( null, round(1032 * widthRatio), round(810 * heightRatio), "batteries_item outline.png");

  UISprite flashLigthSprite = new UISprite(776, 388, "flashlight_item.png");
  UISprite batteriesSprite = new UISprite(1032, 810, "batteries_item.png");

  TextBoxWithFader placeText = new TextBoxWithFader("none", false);

  boolean flashLightInScene = true;
  boolean batteriesInScene = true;

  PImage hiddenImage;

  //HiddenCollider[] hiddenColliders = new HiddenCollider[] {
  //  new HiddenCollider(this, "kill", 103, 286, 398, 89)
  //};

  GarageShelfScene() {
    super("Garage_shelf.png");
    hiddenImage = loadImage("Garage_shelf hidden.png");
    hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));

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
      changeState(GARAGE_SCENE);
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
    soundManager.FOOT_STEPS.play();

    if (placeText.alpha > 0)
      placeText.hide();
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    }
  }

  //PImage getHiddenImage() {
  //  return hiddenImage;
  //}

  //HiddenCollider[] getHiddenColliders() {
  //  return hiddenColliders;
  //}
}
