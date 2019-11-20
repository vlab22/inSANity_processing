


class RiverScene extends Scene
{
    ImageButton    upButton = new ImageButton(    "arrowUp.png", 190, 490, "arrowUp outline.png" );
    ImageButton rightButton = new ImageButton( "arrowRight.png", 700, 485, "arrowRight blue outline.png" );
    HintButton   hintButton = new  HintButton(       "hint.png", "Find the apple", 190, 490 );

    RiverScene() {
        super( "river.png" );
    }

    public void doStepWhileInState(float delta)
    {
        super.doStepWhileInState(delta);
        rightButton.display();
        if ( isAppleTaken ) {
            upButton.display();
        } else {
            hintButton.display();
        }
        
        super.endDisplay();
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
