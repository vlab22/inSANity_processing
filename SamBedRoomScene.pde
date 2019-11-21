class SamBedRoomScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  //ImageButton samDoorsButton = new ImageButton( null, round(1132 * widthRatio), round(198 * heightRatio), "Hallway_2_Room Attic - Sam Door Overlay.png" );
  //ImageButton parentDoorsButton = new ImageButton( null, round(461 * widthRatio), round(264 * heightRatio), "Hallway_2_Room Attic - Parents Door Overlay.png" );


  SoundClip footStepsSoundClip;


  SamBedRoomScene() {
    super("Sam_bedroom.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    //samDoorsButton.display();
    //parentDoorsButton.display();

    super.TransitionDisplay();
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( HALLWAY2_ATTIC_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
