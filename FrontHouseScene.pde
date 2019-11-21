


class FrontHouseScene extends SceneWithTransition
{
  ImageButton houseFrontDoorButton = new ImageButton(null, round(967 * widthRatio), round(655 * heightRatio), "House_front door overlay.png");
  SoundClip footStepsSoundClip;

  FrontHouseScene() {
    super( "House_front.png" );
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    houseFrontDoorButton.display();

    super.TransitionDisplay();
  }

  void handleMousePressed() {
    if ( houseFrontDoorButton.isPointInside( mouseX, mouseY ) ) {
      changeState( FRONTDOOR_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
