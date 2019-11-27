class CarInsideScene extends SceneWithTransition { //<>// //<>// //<>// //<>//

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton diaryButton = new ImageButton( null, round(1267 * widthRatio), round(438 * heightRatio), "Car_Inside note overlay.png" );

  UISprite noteSprite = new UISprite(1267, 438, "Car_Inside note.png");

  boolean placeTextEnabled = true;

  TextBoxWithFader placeText;

  boolean noteInScene = true;

  CarInsideScene() {
    super("Car_Inside.png");

    placeText = new TextBoxWithFader("So many memories");
  }

  void enterState(State oldState) {
    super.enterState(oldState);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    //backButton.display();

    noteSprite.display(delta);

    if (noteInScene == true)
      diaryButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    //if ( backButton.isPointInside( mouseX, mouseY ) ) {
    //  changeState( GARAGE_SCENE );
    //}
    if ( noteInScene == true && diaryButton.isPointInside( mouseX, mouseY ) ) {
      noteInScene = false;
      invManager.PickUpItem("notes_item", new Object[] { 
        "notes_item page 5", 
        }, noteSprite);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    //soundManager.FOOT_STEPS.play();
    placeText.hide();
  }
}
