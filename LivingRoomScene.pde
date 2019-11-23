class LivingRoomScene extends SceneWithTransition { //<>// //<>// //<>//

  ImageButton backButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton fireplaceButton = new ImageButton( null, round(93 * widthRatio), round(405 * heightRatio), "Living_room fireplace outline.png");

  boolean firePlaceTextEnabled = true;

  TextBoxWithFader firePlaceText;

  SoundClip footStepsSoundClip;

  State nextState;

  LivingRoomScene() {
    super("Living_room concept-Recovered-Recovered.png");

    background = loadImage( filename );

    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    firePlaceText = new TextBoxWithFader("That pictures over the Fireplace...");
  }

  void enterState(State oldState) {
    super.enterState(oldState);
    firePlaceText.show();
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    fireplaceButton.display();

    firePlaceText.display();

    super.TransitionDisplay(delta);
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
    nextState = state;
    footStepsSoundClip.play();

    firePlaceText.hide();
  }
}
