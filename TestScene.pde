class TestScene extends SceneWithTransition {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  //ImageButton samDoorsButton = new ImageButton( null, round(1132 * widthRatio), round(198 * heightRatio), "Hallway_2_Room Attic - Sam Door Overlay.png" );
  //ImageButton parentDoorsButton = new ImageButton( null, round(461 * widthRatio), round(264 * heightRatio), "Hallway_2_Room Attic - Parents Door Overlay.png" );

  SoundClip footStepsSoundClip;

  PFont mono;

  boolean textBoxDisable = false;
  TextBoxWithFader textBoxWithFader;

  TestScene() {
    super("Test Scene.png");
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    // The font "andalemo.ttf" must be located in the 
    // current sketch's "data" directory to load successfully
    //mono = loadFont("Gaiatype.ttf");
    mono = createFont("Gaiatype", 32, true);

    //textBoxWithFader = new TextBoxWithFader(0.4, 2);
    //textBoxWithFader.textBox.setTextSize(32);
  }

  void enterState( State oldState )
  {
    super.enterState(oldState);
    if (textBoxDisable == false) {
      //textBoxWithFader.show();
      textBoxDisable = true;
    }
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    backButton.display();
    //samDoorsButton.display();
    //parentDoorsButton.display();

    fill(255);
    textFont(mono);
    text("word", 12, 60);

    textSize(10);
    text("word", 12, 80);

    //float tSize = map(mouseY, 0, height, 1, 100);
    //textBox.text = str(tSize);
    //textBox.setTextSize(tSize);

    //textBoxWithFader.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState( HALLWAY2_ATTIC_SCENE );
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
    //textBoxWithFader.hide();
  }
}
