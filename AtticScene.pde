class AtticScene extends SceneWithTransition implements IHasHiddenLayer, IWaiter {

  ImageButton backButton = new ImageButton( "arrowDown.png", round(825 * widthRatio), round(997 * heightRatio), "arrowDown outline.png" );
  ImageButton notesPlaceButton = new ImageButton( null, round(579 * widthRatio), round(572 * heightRatio), "Attic notes overlay.png");

  UISprite atticNote = new UISprite(579, 572, "Sam_bedroom under bed note sprite.png");

  SoundClip footStepsSoundClip;

  TextBoxWithFader placeText = new TextBoxWithFader("It's too dark, I remember to have a flashlight\r\nin the garage", false);

  boolean flashLightInScene = true;
  boolean batteriesInScene = true;

  PImage hiddenImage;
  PImage hiddenImageWithoutNote;

  boolean playerHasFlashWithBatteries;

  boolean noteInScene = true;

  HiddenCollider[] hiddenColliders = new HiddenCollider[] {
    new HiddenCollider(this, "foo", 103, 286, 398, 89)
  };

  AtticScene() {
    super("Attic.png");
    hiddenImage = loadImage("Attic hidden.png");
    hiddenImage.resize(round(hiddenImage.width * widthRatio), round(hiddenImage.height * heightRatio));

    hiddenImageWithoutNote = loadImage("Attic hidden 2 - without note.png");
    hiddenImageWithoutNote.resize(round(hiddenImageWithoutNote.width * widthRatio), round(hiddenImageWithoutNote.height * heightRatio));

    footStepsSoundClip = new SoundClip("footstep01 0.800 seconds.wav");

    atticNote.enabled = false;
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    boolean playerHasFlashLight = invManager.hasItem("flashlight_item");
    boolean playerHasBatteries = invManager.hasItem("batteries_item");
    playerHasFlashWithBatteries = invManager.hasItem("flashlight_batteries_item");

    if (playerHasFlashWithBatteries == true) {
      placeText.textBox.setText("Now I can the flashlight.");
    } else if (playerHasFlashLight == false) {
    } else if (playerHasFlashLight == true && playerHasBatteries == false) {
      placeText.textBox.setText("I have a flashlight but where are the batteries?\r\nMaybe in the garage too.");
    } else if (playerHasFlashLight == false && playerHasBatteries == true) {
      placeText.textBox.setText("I have some batteries but where is the flashlight?\r\nMaybe in the garage too.");
    } else if (playerHasFlashLight && playerHasBatteries) {
      placeText.textBox.setText("I forgot to insert the batteries or do I missing something else?");
    }
    placeText.show();
    waiter.waitForSeconds(5, this, 0, null);
  }

  void checkMessages() {
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    rectMode(CORNER);
    noStroke();

    float blackAlpha = 0.975 * 255; //to set alpha of image and filler rects

    if (usableItemManager.usablesMap.containsKey("flashlight_batteries_item") && usableItemManager.usablesMap.get("flashlight_batteries_item").enabled) {

      if (noteInScene == true)
        atticNote.display(delta);

      notesPlaceButton.display();
    } else {
      fill(1, 1, 1, blackAlpha);
      rect(0, 0, width, height);
    }

    backButton.display();

    placeText.display();

    super.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( backButton.isPointInside( mouseX, mouseY ) ) {
      changeState(HALLWAY2_ATTIC_SCENE);
    }

    if (noteInScene == true && notesPlaceButton.isPointInside( mouseX, mouseY ) ) {
      noteInScene = false;
      
      //Reassing hidden image to image without the note ans reload
      hiddenImage = hiddenImageWithoutNote;
      invManager.checkAndEnableHiddenImageForFlashLight(this);
      
      atticNote.enabled = true;
      invManager.PickUpItem("notes_item", new Object[] { "notes_item page 4" }, atticNote);
    }
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      println("Anis", Ani.size() );
      placeText.hide();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
    footStepsSoundClip.play();

    if (placeText.alpha > 0)
      placeText.hide();
  }

  PImage getHiddenImage() {
    return hiddenImage;
  }

  HiddenCollider[] getHiddenColliders() {
    return hiddenColliders;
  }
  
  void hiddenColliderHit(HiddenCollider hc) {
  }
}
