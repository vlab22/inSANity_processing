class MainMenuScene extends SceneWithTransition {
  ImageButton startButton = new ImageButton( null, round(1308 * widthRatio), round(469 * heightRatio), "title screen_Start start overlay.png" );

  PImage startLight;

  float startLightAlpha = 0;
  Ani blink;

  MainMenuScene() {
    super("title screen_black.png");

    background = loadImage( filename );
    startLight = loadImage("title screen_Start.png");
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    float delay = timeSinceStartInSeconds();

    blink = Ani.to(this, 1, 0.6, "startLightAlpha", 255, Ani.QUAD_IN);


    println(this.getName(), "entertate", frameCount, "delay", delay);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    //println(this.getName(), "doStep", frameCount, millis());

    if (frameCount == 4)
      blink.start();

    pushStyle();
    tint(255, startLightAlpha);
    image(startLight, 0, 0, startLight.width * widthRatio, startLight.height * heightRatio);
    popStyle();

    startButton.display();

    this.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( startButton.isPointInside( mouseX, mouseY ) ) {
      changeState( FRONTHOUSE_SCENE );
    }
  }


  void TransitionDisplay(float delta) {

    //usableItemManager.step(delta);

    //invPanel.display(delta);

    //textManager.display(delta);

    if (sceneLeaveTransition.enabled == true) {
      sceneLeaveTransition.display();
    } else if (sceneEnterTransition.enabled == true) {
      sceneEnterTransition.display();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
  }
}
