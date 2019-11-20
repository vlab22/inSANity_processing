


class FrontHouseScene extends Scene
{
  //ImageButton    upButton = new ImageButton(    "arrowUp.png", 190, 490, "arrowUp outline.png" );
  //ImageButton rightButton = new ImageButton( "arrowRight.png", 700, 485, "arrowRight outline.png" );
  //HintButton   hintButton = new  HintButton(       "hint.png", "Find the apple", 190, 490 );
  ImageButton houseFrontDoorButton = new ImageButton(null, round(967 * widthRatio), round(655 * heightRatio), "House_front door overlay.png");

  FrontHouseScene() {
    super( "House_front.png" );
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
    //rightButton.display();
    //if ( isAppleTaken ) {
    //  upButton.display();
    //} else {
    //  hintButton.display();
    //}

    houseFrontDoorButton.display();

    super.endDisplay();
  }

  void handleMousePressed() {
    if ( houseFrontDoorButton.isPointInside( mouseX, mouseY ) ) {
      stateHandler.changeStateTo( FRONTDOOR_SCENE );
    }
  }
}
