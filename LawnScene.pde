

class LawnScene extends Scene
{
  ImageButton   upButton = new ImageButton( "arrowUp.png", 320, 550, "arrowUp outline.png");
  ImageButton downButton = new ImageButton( "arrowDown.png", 320, 700, "arrowDown outline.png");

  LawnScene() {
    super( "lawn.png" );
  }


  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    upButton.display();
    downButton.display();

    super.endDisplay();
  }

  void handleMousePressed() {
    if ( upButton.isPointInside( mouseX, mouseY ) ) {
      stateHandler.changeStateTo( TABLE_SCENE );
    }
    if ( downButton.isPointInside( mouseX, mouseY ) ) {
      stateHandler.changeStateTo( RIVER_SCENE );
    }
  }
}
