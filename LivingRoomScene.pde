class LivingRoomFireplaceScene extends SceneWithTransition { //<>// //<>// //<>// //<>// //<>// //<>//

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton diaryButton = new ImageButton( null, round(620 * widthRatio), round(976 * heightRatio), "Living_room_Chimney_Photo diary overlay.png" );

  UISprite diarySprite = new UISprite(620, 976, "Living_room_Chimney_Photo diary object.png");

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
      invManager.PickUpItem("notes_item", new Object[] { 
        "notes_item page 2", 
        "notes_item page 1" 
        }, diarySprite);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
    placeText.hide();
  }
}

class LivingRoomScene extends SceneWithTransition implements IWaiter, IHasHiddenLayer {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton fireplaceButton = new ImageButton( null, round(93 * widthRatio), round(405 * heightRatio), "Living_room fireplace outline.png");

  boolean firePlaceTextEnabled = true;

  TextBoxWithFader placeText;

  SoundClip footStepsSoundClip;

  State nextState;

  PImage hiddenImage;

  LivingRoomScene() {
    super("Living_room.png");

    background = loadImage( filename );

    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    placeText = new TextBoxWithFader("My old diary is over there as my mom said.");
    placeText.alpha = 0;

    hiddenImage = loadImage("Living_room hidden.png");
    hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    if (!invManager.hasItem("notes_item")) {
      placeText.show();
      waiter.waitForSeconds(3.5, this, 0, null);
    }
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    fireplaceButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {

      if (invManager.hasItem("notes_item")) {
        NotesUsableItem notes = (NotesUsableItem)usableItemManager.usablesMap.get("notes_item");
        InventoryItem item = invManager.findItemByName("notes_item");
      }

      changeState( GROUND_HALLWAY_SCENE );
    }

    if ( fireplaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState( LIVINGROOM_CHIMNEY_SCENE );
    }
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      placeText.hide();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    nextState = state;
    footStepsSoundClip.play();

    placeText.hide();
  }

  PImage getHiddenImage() {
    return hiddenImage;
  }

  HiddenCollider[] getHiddenColliders() {
    return new HiddenCollider[0];
  }

  void hiddenColliderHit(HiddenCollider hc) {
  }
}
