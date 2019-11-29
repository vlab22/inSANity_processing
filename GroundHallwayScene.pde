class GroundHallwayScene extends SceneWithTransition implements IWaiter //<>//
{
  //ImageButton toOutofHouseButton = new ImageButton( "arrowDown.png", round(908 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton toUpstairsButton = new ImageButton( "arrowUp.png", round(908 * widthRatio), round(340 * heightRatio), "arrowUp outline.png" );
  ImageButton toLivingRoomButton = new ImageButton( "arrowLeft.png", round(531 * widthRatio), round(774 * heightRatio), "arrowLeft outline.png" );

  ImageButton garageDoorPlaceButton = new ImageButton( null, round(1343 * widthRatio), round(169 * heightRatio), "Ground_Hallway garage door overlay.png");

  TextBoxWithFader placeText = new TextBoxWithFader();

  float angle = 0;

  boolean garageDoorLocked = true;

  boolean garageKeyAnimationPlaying = false;

  UISprite garageKeySprite;
  UISprite garageKeyLockerSprite;

  GroundHallwayScene() {
    super( "Ground_Hallway.png" );

    placeText.enabled = false;
    placeText.alpha = 0;

    garageKeySprite = new UISprite(0, 0, "garage_key_item.png");
    garageKeySprite.enabled = false;

    garageKeyLockerSprite = new UISprite(1439, 775, "Ground_Hallway key locker.png");
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    //toOutofHouseButton.display();
    toUpstairsButton.display();
    toLivingRoomButton.display();

    garageDoorPlaceButton.display();

    garageKeySprite.display(delta);
    garageKeyLockerSprite.display(delta);

    TransitionDisplay(delta);
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
        textManager.showText("It's locked", 3);
      } else if (garageDoorLocked == true && invManager.hasItem("garage_key_item") == true) {

        allowMousePressed = false;

        println("allowMousePressed", stateAllowMousePressed, frameCount);

        //Player unlock the door
        //Anim inventory key to door
        InventoryItem keyItem = invManager.findItemByName("garage_key_item");
        InventoryPanelItem invItem = invPanel.panelItems[keyItem.slot];

        invPanel.removeItem(keyItem);
        invManager.removeItem(keyItem);

        PVector globalItemPosition = invPanel.getItemGlobalPosition(invItem);

        float toX = 1403 * widthRatio;
        float toY = 750 * heightRatio;
        float toW = 63 * widthRatio;
        float toH = 62 * heightRatio;

        //Reposition sprite oto global space
        garageKeySprite.x = round(globalItemPosition.x);
        garageKeySprite.y = round(globalItemPosition.y);

        garageKeySprite.enabled = true;

        garageKeyAnimationPlaying = true;

        Ani.to(garageKeySprite, 0.4, 0, "x:" + toX + ", y:" + toY + ", w:" + toW + ", h:" + toH, Ani.QUAD_OUT, this, "onEnd:garageKeyAnimEnd");

        invManager.inventoryPanel.openPanel();
      } else if (garageDoorLocked == false)
      {
        changeState(GARAGE_SCENE);
        soundManager.OPEN_DOOR.play();
      }
    }
  }

  void garageKeyAnimEnd() {
    allowMousePressed = true;
    garageDoorLocked = false;

    garageKeyAnimationPlaying = false;

    waiter.waitForSeconds(0.5, this, 0, null);
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      changeState(GARAGE_SCENE);
      soundManager.OPEN_DOOR.play();
    }
  }

  void TransitionDisplay(float delta) { //<>//

    usableItemManager.step(delta);

    invPanel.display(delta);

    if (garageKeyAnimationPlaying == true) {
      garageKeySprite.display(delta);
      garageKeyLockerSprite.display(delta);
    }

    textManager.display(delta);

    if (sceneLeaveTransition.enabled == true) {
      sceneLeaveTransition.display();
    } else if (sceneEnterTransition.enabled == true) {
      sceneEnterTransition.display();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    soundManager.FOOT_STEPS.play();
  }
}
