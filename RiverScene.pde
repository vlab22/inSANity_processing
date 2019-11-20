


class RiverScene extends Scene
{
    ImageButton    upButton = new ImageButton(    "arrowUp.png", 190, 490 );
    ImageButton rightButton = new ImageButton( "arrowRight.png", 700, 485 );
    HintButton   hintButton = new  HintButton(       "hint.png", "Find the apple", 190, 490 );

    RiverScene() {
        super( "river.png" );
    }

    public void doStepWhileInState()
    {
        super.doStepWhileInState();
        rightButton.display();
        if ( isAppleTaken ) {
            upButton.display();
        } else {
            hintButton.display();
        }
    }

    void handleMousePressed() {
        if ( rightButton.isPointInside( mouseX , mouseY ) ) {
            stateHandler.changeStateTo( LAWN_SCENE );
        }
        if ( isAppleTaken && upButton.isPointInside( mouseX , mouseY ) ) {
            stateHandler.changeStateTo( FOREST_SCENE );
        }
    }
}
