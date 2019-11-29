class Hallway2AtticScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton samDoorsButton = new ImageButton( null, round(1132 * widthRatio), round(198 * heightRatio), "Hallway_2_Room Attic - Sam Door Overlay.png" );
  //ImageButton parentDoorsButton = new ImageButton( null, round(461 * widthRatio), round(264 * heightRatio), "Hallway_2_Room Attic - Parents Door Overlay.png" );
  ImageButton atticStairsButton = new ImageButton( "Hallway_2_Room Attic stairs.png", round(607 * widthRatio), round(0 * heightRatio), "Hallway_2_Room Attic stairs overlay.png" );
  ImageButton garageKeyPlaceButton = new ImageButton( null, round(921 * widthRatio), round(664 * heightRatio), "garage_key_laydown outline.png");

  UISprite garageKeySprite = new UISprite(921, 664, "garage_key_laydown.png");

  boolean atticStairsOpen = false;

  boolean garageKeyPicked = false;

  Hallway2AtticScene() {
    super("Hallway_2_Room Attic.png");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    samDoorsButton.display();
    //parentDoorsButton.display();

    if (atticStairsOpen == true && garageKeyPicked == false) {
      garageKeyPlaceButton.display();
      garageKeySprite.display(delta);
    }

    if (atticStairsOpen == true) {
      atticStairsButton.display();
    }

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( GROUND_HALLWAY_SCENE );
    }

    if ( samDoorsButton.isPointInside( mouseX, mouseY ) ) {
      changeState( SAM_BEDROOM_SCENE );
      soundManager.OPEN_DOOR.play();
    }

    if ( atticStairsOpen && atticStairsButton.isPointInside( mouseX, mouseY ) ) {
      changeState( ATTIC_SCENE );
      soundManager.OPEN_DOOR.play();
    }


    if (garageKeyPicked == false && garageKeyPlaceButton.isPointInside( mouseX, mouseY ) ) {
      garageKeyPicked = true;
      invManager.PickUpItem("garage_key_item", new String[] { "garage_key item 0" }, garageKeySprite);
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();
  }
}
