abstract class SceneWithTransition extends Scene
{
  SceneTransition sceneEnterTransition;
  SceneTransition sceneLeaveTransition;

  SceneWithTransition( String backgroundFilename ) {
    super(backgroundFilename);

    enterTransition = new SceneTransition();
    leaveTransition = new SceneTransition();

    sceneEnterTransition = (SceneTransition)enterTransition;
    sceneLeaveTransition = (SceneTransition)leaveTransition;

    sceneEnterTransition.to = 0;
    sceneEnterTransition.start = 255;
    sceneEnterTransition.easing = AniConstants.QUAD_IN;
    sceneEnterTransition.callBackName = "onEnd:enterStateAfterTransition";
  }

  void TransitionDisplay() {
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
