class Hallway2AtticScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton samDoorsButton = new ImageButton( null, round(1132 * widthRatio), round(198 * heightRatio), "Hallway_2_Room Attic - Sam Door Overlay.png" );
  ImageButton parentDoorsButton = new ImageButton( null, round(461 * widthRatio), round(264 * heightRatio), "Hallway_2_Room Attic - Parents Door Overlay.png" );
  ImageButton atticStairsButton = new ImageButton( "Hallway_2_Room Attic stairs.png", round(607 * widthRatio), round(0 * heightRatio), "Hallway_2_Room Attic stairs overlay.png" );

  SoundClip footStepsSoundClip;
  SoundClip frontDoorOpenSoundClip;

  boolean atticStairsOpen = false;

  Hallway2AtticScene() {
    super("Hallway_2_Room Attic.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
    frontDoorOpenSoundClip = new SoundClip("53280__the-bizniss__front-door-open.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    samDoorsButton.display();
    parentDoorsButton.display();

    if (atticStairsOpen == true) 
      atticStairsButton.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( GROUND_HALLWAY_SCENE );
    }

    if ( samDoorsButton.isPointInside( mouseX, mouseY ) ) {
      changeState( SAM_BEDROOM_SCENE );
      frontDoorOpenSoundClip.play();
    }

    if ( atticStairsOpen && atticStairsButton.isPointInside( mouseX, mouseY ) ) {
      changeState( ATTIC_SCENE );
      frontDoorOpenSoundClip.play();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
