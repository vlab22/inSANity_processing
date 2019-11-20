


class TableScene extends Scene
{
    ImageButton appleButton = new ImageButton( "apple.png"    , 325, 366 );
    ImageButton  downButton = new ImageButton( "arrowDown.png", 320, 700 );

    TableScene() {
        super( "table_with_apples.png" );
    }

    public void doStepWhileInState()
    {
        super.doStepWhileInState();
        if ( ! isAppleTaken ) {
            appleButton.display();
        }
        downButton.display();
    }

    void handleMousePressed() {
        if ( ( ! isAppleTaken ) && appleButton.isPointInside( mouseX , mouseY ) ) {
            isAppleTaken = true;
        }
        if ( downButton.isPointInside( mouseX , mouseY ) ) {
            stateHandler.changeStateTo( LAWN_SCENE );
        }
    }
}
