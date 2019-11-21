class Hallway2AtticScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );

  SoundClip footStepsSoundClip;


  Hallway2AtticScene() {
    super("Hallway_2_Room Attic.png");
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
      changeState( GROUND_HALLWAY_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
