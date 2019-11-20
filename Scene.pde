


class Scene extends State
{
    PImage background;
    String filename;
    
    Scene( String backgroundFilename ) {
        filename = backgroundFilename;
    }
        
    void enterState( State oldState )
    {
        if ( background == null ) {
            background = loadImage( filename );
        }
    }


    public void doStepWhileInState()
    {
        image( background, 0, 0, width, height );
    }
}
