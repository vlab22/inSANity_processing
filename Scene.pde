class Scene extends State //<>//
{
  PImage background;
  String filename;

  SceneTransition sceneEnterTransition;
  SceneTransition sceneLeaveTransition;

  Scene( String backgroundFilename ) {
    filename = backgroundFilename;

    enterTransition = new SceneTransition();
    leaveTransition = new SceneTransition();

    sceneEnterTransition = (SceneTransition)enterTransition;
    sceneLeaveTransition = (SceneTransition)leaveTransition;

    sceneEnterTransition.to = 0;
    sceneEnterTransition.start = 255;
    sceneEnterTransition.easing = AniConstants.QUAD_IN;
    sceneEnterTransition.callBackName = "onEnd:enterStateAfterTransition";
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
    image( background, 0, 0, width, height );
  }

  void endDisplay() {
    if (sceneLeaveTransition.enabled == true) {
      sceneLeaveTransition.display();
    } else if (sceneEnterTransition.enabled == true) {
      sceneEnterTransition.display();
    }
  }
}
