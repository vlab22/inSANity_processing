class GroundHallwayScene extends SceneWithTransition
{
  //ImageButton toOutofHouseButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton toUpstairsButton = new ImageButton( "arrowUp.png", round(908 * widthRatio), round(340 * heightRatio), "arrowUp outline.png" );
  ImageButton toLivingRoomButton = new ImageButton( "arrowLeft.png", round(531 * widthRatio), round(774 * heightRatio), "arrowLeft outline.png" );

  ImageButton garageDoorPlaceButton = new ImageButton( null, round(1343 * widthRatio), round(169 * heightRatio), "Ground_Hallway garage door overlay.png");

  TextBoxWithFader placeText = new TextBoxWithFader();

  SoundClip footStepsSoundClip;
  SoundClip doorOpenSoundClip;

  float angle = 0;

  boolean garageDoorLocked = true;

  GroundHallwayScene() {
    super( "Ground_Hallway.png" );
    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");
    doorOpenSoundClip = new SoundClip("53280__the-bizniss__front-door-open.wav");

    placeText.enabled = false;
    placeText.alpha = 0;
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    //toOutofHouseButton.display();
    toUpstairsButton.display();
    toLivingRoomButton.display();

    garageDoorPlaceButton.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( toLivingRoomButton.isPointInside(mouseX, mouseY) ) {
      changeState(LIVINGROOM_SCENE);
    }
    if ( toUpstairsButton.isPointInside(mouseX, mouseY) ) {
      changeState(HALLWAY2_ATTIC_SCENE);
    }
    //if ( toOutofHouseButton.isPointInside( mouseX, mouseY ) ) {
    //  changeState(FRONTDOOR_SCENE);
    //}
    if ( garageDoorPlaceButton.isPointInside( mouseX, mouseY ) ) {

      if (garageDoorLocked == true && invManager.hasItem("garage_key_item") == false) {
        //Garage Locked and player doesn't have a key
      } else if (garageDoorLocked == true && invManager.hasItem("garage_key_item") == true) {
        //Player unlock the door
        garageDoorLocked = true;
      } else if (garageDoorLocked == false)
      {
        changeState(GARAGE_SCENE);
        doorOpenSoundClip.play();
      }
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();
  }
}
