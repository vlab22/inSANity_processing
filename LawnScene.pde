

class LawnScene extends Scene
{
    ImageButton   upButton = new ImageButton( "arrowUp.png"  , 320, 550 );
    ImageButton downButton = new ImageButton( "arrowDown.png", 320, 700 );

    LawnScene() {
        super( "lawn.png" );
    }

    
    public void doStepWhileInState()
    {
        super.doStepWhileInState();
        upButton.display();
        downButton.display();
    }

    void handleMousePressed() {
        if ( upButton.isPointInside( mouseX , mouseY ) ) {
            stateHandler.changeStateTo( TABLE_SCENE );
        }
        if ( downButton.isPointInside( mouseX , mouseY ) ) {
            stateHandler.changeStateTo( RIVER_SCENE );
        }
    }
        
}
