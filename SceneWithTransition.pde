abstract class SceneWithInventory extends Scene
{
  SceneWithInventory( String backgroundFilename ) {
    super(backgroundFilename);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
  }
}

abstract class SceneWithTransition extends SceneWithInventory
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
    sceneEnterTransition.easing = Ani.QUAD_IN;
    sceneEnterTransition.callBackName = "onEnd:enterStateAfterTransition";
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);
  }

  void TransitionDisplay(float delta) {

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
