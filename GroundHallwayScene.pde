class GroundHallwayScene extends SceneWithTransition
{
  ImageButton toOutofHouseButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton toUpstairsButton = new ImageButton( "arrowUp.png", round(908 * widthRatio), round(340 * heightRatio), "arrowUp outline.png" );
  ImageButton toLivingRoomButton = new ImageButton( "arrowLeft.png", round(450 * widthRatio), round(950 * heightRatio), "arrowLeft outline.png" );

  ImageButton garageDoorPlaceButton = new ImageButton( null, round(1343 * widthRatio), round(169 * heightRatio), "Ground_Hallway garage door overlay.png");

  SoundClip footStepsSoundClip;
  SoundClip doorOpenSoundClip;

  float angle = 0;

  GroundHallwayScene() {
    super( "Ground_Hallway.png" );
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
    doorOpenSoundClip = new SoundClip("53280__the-bizniss__front-door-open.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    toOutofHouseButton.display();
    toUpstairsButton.display();
    toLivingRoomButton.display();

    garageDoorPlaceButton.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( toLivingRoomButton.isPointInside(mouseX, mouseY) ) {
      changeState(LIVINGROOM_SCENE);
    }
    if ( toUpstairsButton.isPointInside(mouseX, mouseY) ) {
      changeState(HALLWAY2_ATTIC_SCENE);
    }
    if ( toOutofHouseButton.isPointInside( mouseX, mouseY ) ) {
      changeState(FRONTDOOR_SCENE);
    }
    if ( garageDoorPlaceButton.isPointInside( mouseX, mouseY ) ) {
      changeState(GARAGE_SCENE);
      doorOpenSoundClip.play();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
