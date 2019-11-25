abstract class SceneWithTransition extends Scene //<>// //<>//
{
  SceneTransition sceneEnterTransition;
  SceneTransition sceneLeaveTransition;

  SceneWithTransition( String backgroundFilename ) {
    super(backgroundFilename);
    
    //background = loadImage( filename );

    enterTransition = new SceneTransition();
    leaveTransition = new SceneTransition();

    sceneEnterTransition = (SceneTransition)enterTransition;
    sceneLeaveTransition = (SceneTransition)leaveTransition;

    sceneEnterTransition.to = 0;
    sceneEnterTransition.start = 255;
    sceneEnterTransition.easing = Ani.QUAD_IN;
    sceneEnterTransition.callBackName = "onEnd:enterStateAfterTransition";
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
  }

  void TransitionDisplay(float delta) {

    usableItemManager.step(delta);
    
    invPanel.display(delta);

    if (sceneLeaveTransition.enabled == true) {
      sceneLeaveTransition.display();
    } else if (sceneEnterTransition.enabled == true) {
      sceneEnterTransition.display();
    }
  }

  abstract void changeState(State state);

  void changeStateEnd(State state) {
  }
}

abstract class Scene extends State //<>// //<>//
{
  PImage background;
  String filename;
  
  ImageButton[] imageButtons;

  Scene( String backgroundFilename ) {
    filename = backgroundFilename;
  }

  void enterState( State oldState )
  {
    super.enterState(oldState);
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
