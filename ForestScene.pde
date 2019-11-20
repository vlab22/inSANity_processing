

class ForestScene extends Scene
{
    TextButton resetButton = new TextButton( 320, 500, "Reset" , 50 );

    ForestScene() {
        super( "forest.png" );  
    }

    public void doStepWhileInState()
    {
        super.doStepWhileInState();
        resetButton.display();
    }

    void handleMousePressed() {
        if ( resetButton.isPointInside( mouseX , mouseY ) ) {
            isAppleTaken = false;
            stateHandler.changeStateTo( RIVER_SCENE );
        }
    }
}