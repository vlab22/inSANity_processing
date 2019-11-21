class LivingRoomChimneyScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );

  SoundClip footStepsSoundClip;


  LivingRoomChimneyScene() {
    super("Living_room_Chimney_Photo.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();

    super.TransitionDisplay();
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( LIVINGROOM_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
