

class ForestScene extends SceneWithTransition
{
  TextButton resetButton = new TextButton( 320, 500, "Reset", 50 );

  ForestScene() {
    super( "forest.png" );
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    resetButton.display();

    super.TransitionDisplay();
  }

  void handleMousePressed() {
    if ( resetButton.isPointInside( mouseX, mouseY ) ) {
      changeState(FRONTHOUSE_SCENE);
    }
  }
  
  void changeState(State state) {
    stateHandler.changeStateTo( state );
  }
}
