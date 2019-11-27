import processing.sound.*;

class EndCreditScene extends SceneWithTransition implements IHasHiddenLayer
{

  // =============== End Scene Image ================
  PImage endCreditHiddenImage; 

  EndCreditScene() {
    super( "End Scene.png" );

    background = loadImage( filename );

    endCreditHiddenImage = loadImage("End Scene hidden.png"); 
    endCreditHiddenImage.resize(round(endCreditHiddenImage.width * widthRatio), round(endCreditHiddenImage.height * heightRatio));
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);


    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
  }

  PImage getHiddenImage() {
    return endCreditHiddenImage;
  }
  
  HiddenCollider[] getHiddenColliders() {
    return new HiddenCollider[0];
  }
}
