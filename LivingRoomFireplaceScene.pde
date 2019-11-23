class LivingRoomFireplaceScene extends SceneWithTransition {

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
      invManager.PickUpItem("notes_item", diarySprite);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
    placeText.hide();
  }
}
