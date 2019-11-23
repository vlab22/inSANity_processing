


class GroundHallwayScene extends SceneWithTransition
{
  ImageButton appleButton = new ImageButton( "apple.png", 325, 366 );
  ImageButton toOutofHouseButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton toUpstairsButton = new ImageButton( "arrowUp.png", round(908 * widthRatio), round(340 * heightRatio), "arrowUp outline.png" );
  ImageButton toLivingRoomButton = new ImageButton( "arrowLeft.png", round(450 * widthRatio), round(950 * heightRatio), "arrowLeft outline.png" );

  SoundClip footStepsSoundClip;

  float angle = 0;

  GroundHallwayScene() {
    super( "Ground_Hallway.png" );
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    toOutofHouseButton.display();
    toUpstairsButton.display();
    toLivingRoomButton.display();

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
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
