class LivingRoomScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );

  ImageButton fireplaceButton = new ImageButton( null, round(93 * widthRatio), round(405 * heightRatio), "Living_room fireplace outline.png");


  SoundClip footStepsSoundClip;

  LivingRoomScene() {
    super("Living_room.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    fireplaceButton.display();

    super.TransitionDisplay();
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
    footStepsSoundClip.play();
  }
}
