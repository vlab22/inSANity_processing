class LivingRoomFireplaceScene extends SceneWithTransition { //<>// //<>// //<>//

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton diaryButton = new ImageButton( null, round(620 * widthRatio), round(976 * heightRatio), "Living_room_Chimney_Photo diary overlay.png" );

  UISprite diarySprite = new UISprite(round(620 * widthRatio), round(976 * heightRatio), "Living_room_Chimney_Photo diary object.png");

  SoundClip footStepsSoundClip;

  boolean placeTextEnabled = true;

  TextBoxWithFader placeText;

  boolean diaryInScene = true;

  LivingRoomFireplaceScene() {
    super("Living_room_Chimney_Photo.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    placeText = new TextBoxWithFader("So many memories");
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    if (placeTextEnabled) {
      placeText.show();
      placeTextEnabled = false;
    }
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();

    diarySprite.display(delta);

    if (diaryInScene == true)
      diaryButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( LIVINGROOM_SCENE );
    }
    if ( diaryInScene == true && diaryButton.isPointInside( mouseX, mouseY ) ) {
      diaryInScene = false;
      invManager.PickUpItem("notes_item", new Object[] { "notes_item page 2", "notes_item page 1" }, diarySprite);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
    placeText.hide();
  }
}

class LivingRoomScene extends SceneWithTransition implements IHasHiddenLayer { //<>//

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton fireplaceButton = new ImageButton( null, round(93 * widthRatio), round(405 * heightRatio), "Living_room fireplace outline.png");

  boolean firePlaceTextEnabled = true;

  TextBoxWithFader firePlaceText;

  SoundClip footStepsSoundClip;

  State nextState;

  PImage hiddenImage;

  LivingRoomScene() {
    super("Living_room concept-Recovered-Recovered.png");

    background = loadImage( filename );

    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    firePlaceText = new TextBoxWithFader("That pictures over the Fireplace...");

    hiddenImage = loadImage("Living_room hidden.png");
    hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));
  }

  void enterState(State oldState) {
    super.enterState(oldState);
    firePlaceText.show();
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    fireplaceButton.display();

    firePlaceText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( GROUND_HALLWAY_SCENE );
    }

    if ( fireplaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState( LIVINGROOM_CHIMNEY_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    nextState = state;
    footStepsSoundClip.play();

    firePlaceText.hide();
  }

  PImage getHiddenImage() {
    return hiddenImage;
  }

  HiddenCollider[] getHiddenColliders() {
    return new HiddenCollider[0];
  }
}
