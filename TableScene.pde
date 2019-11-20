


class TableScene extends Scene
{
  ImageButton appleButton = new ImageButton( "apple.png", 325, 366 );
  ImageButton  downButton = new ImageButton( "arrowDown.png", 320, 700, "arrowDown outline.png" );

  TableScene() {
    super( "table_with_apples.png" );
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    if ( ! isAppleTaken ) {
      appleButton.display();
    }
    downButton.display();

    super.endDisplay();
  }

  void handleMousePressed() {
    if ( ( ! isAppleTaken ) && appleButton.isPointInside( mouseX, mouseY ) ) {
      isAppleTaken = true;
    }
    if ( downButton.isPointInside( mouseX, mouseY ) ) {
      stateHandler.changeStateTo( LAWN_SCENE );
    }
  }
}
