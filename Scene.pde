abstract class Scene extends State //<>// //<>//
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

  public void doStepWhileInState(float delta)
  {
    tint(255);
    imageMode(CORNER);
    image( background, 0, 0, width, height );
  }
}
