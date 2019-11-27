class FlashLightUsableItem extends UsableItem implements IWaiter { //<>// //<>// //<>//

  PImage blackLightImage;
  PImage hiddenImage;

  HiddenCollider[] hiddenColliders = new HiddenCollider[0];

  PImage mask;

  PImage masked;
  color cp;
  int xPos, yPos;
  boolean doCopy = false;
  int maskW, maskH;

  PGraphics pg; 
  int[] maskArray;

  TextBoxWithFader placeText = new TextBoxWithFader();

  FlashLightUsableItem() {
    super();
    blackLightImage = loadImage("BlackLight.png");
    blackLightImage.resize(round(blackLightImage.width * widthRatio), round(blackLightImage.height * heightRatio));

    mask = loadImage("BlackLight mask.png");
    mask.resize(round(mask.width * widthRatio), round(mask.height * heightRatio));

    maskW = mask.width;
    maskH = mask.height;

    masked = new PImage(maskW, maskH);

    pg = createGraphics(width, height, P2D);

    maskArray = new int[maskW * maskH];

    createMaskArray();

    placeText.enabled = false;
  }

  void display() {
    imageMode(CENTER);

    if (hiddenImage != null) {
      //if (!(mouseX < maskW/2 || mouseX > width - maskW/2))
      //{
      //  xPos = mouseX;
      //  doCopy = true;
      //}
      //if (!(mouseY < maskH/2 || mouseY > height - maskH/2))
      //{
      //  yPos = mouseY;
      //  doCopy = true;
      //}
      //if (doCopy) copyApplyMask();
      //doCopy = false;

      copyApplyMask();

      image(masked, xPos, yPos);
    }

    image(blackLightImage, mouseX, mouseY);

    placeText.display();
  }

  void step(float delta) {
    if (hiddenImage != null) {
      xPos = mouseX;
      yPos = mouseY;

      for (int i = 0; i < hiddenColliders.length; i++) {
        if (hiddenColliders[i].pointInCollider(xPos, yPos)) {

          if (hiddenColliders[i].parent instanceof NotesUsableItem) {
            hiddenColliders[i].enabled = false;

            int wordPage = Integer.parseInt(hiddenColliders[i].name.split(" ")[1]); //the page is the second value in string, example "page 2 0"
            int wordIndex = Integer.parseInt(hiddenColliders[i].name.split(" ")[2]); //the index is the third value in string, example "page 2 0"

            NotesUsableItem notes = (NotesUsableItem)hiddenColliders[i].parent;

            if (wordPage == 5) {
              //Final Page Goes To EndScene

              soundManager.LIMBO_SOUND.play();
              allowMousePressed = false;

              waiter.waitForSeconds(5, this, 3, notes);
            } else {
              UISprite hiddenWordSprite = notes.getHiddenWordSprite(wordIndex);
              hiddenWordSprite.enabled = true;

              notes.hiddenWordsFound++;

              println("hiddenWordsFound", notes.hiddenWordsFound);

              if (notes.hiddenWordsFound >= notes.MAX_WORDS_FOUND_TO_END) {

                //Unlock CAR
                GarageScene garage = (GarageScene)GARAGE_SCENE;
                garage.carPlaceEnabled = true;

                placeText.setDuration(3);
                placeText.textBox.setText("I want to leave this house right now!\r\nI can't handle it anymore!");
                placeText.enabled = true;
                placeText.show();

                allowMousePressed = false; //lock player input mouse while playing messages

                waiter.waitForSeconds(3, this, 0, notes);

                println("Car collider enabled");
              }
            }
          }

          println("inside", hiddenColliders[i].name);
        }

        //fill(255, 255, 255, 10);
        //rect(hiddenColliders[i].rect.x, hiddenColliders[i].rect.y, hiddenColliders[i].rect.w, hiddenColliders[i].rect.h);
      }
    }

    display();
  }

  void execute(int executeId, Object obj) {


    //Run to garage messages
    if (executeId == 0) {

      placeText.hide();
      waiter.waitForSeconds(0.5, this, 1, obj); //wait text fadeout
    } else if (executeId == 1) {

      if (stateHandler.currentState.name != "GarageScene") {
        placeText.textBox.setText("I need to reach the garage right now!.");
        placeText.show();

        waiter.waitForSeconds(3, this, 2, obj); //wait text fadeout
      } else {
        placeText.disableAfterHide = true;
        placeText.hide();
        NotesUsableItem notes = (NotesUsableItem)obj;
        allowMousePressed = true;
      }
    } else if (executeId == 2) {
      placeText.disableAfterHide = true;
      placeText.hide();
      NotesUsableItem notes = (NotesUsableItem)obj;
      allowMousePressed = true;
    }

    //END Game Sequence
    else if (executeId == 3) {
      NotesUsableItem notes = (NotesUsableItem)obj;
      notes.itemSoundEnabled = false; //not play annoying sound when close
      notes.setEnabled(false);

      waiter.waitForSeconds(2, this, 4, notes);
    } else if (executeId == 4) {
      SceneWithTransition scene = (SceneWithTransition)stateHandler.currentState;
      invPanel.closepanel();
      scene.changeState(END_CREDIT_SCENE);
    }
  }

  void setEnabled(boolean val) {

    if (val) {
      enable();
    } else {
      disable();
    }

    soundManager.playItemClicked("flashlight_batteries_item" + ((val) ? "_on" : "_off"));
    enabled = val;
    println("flashlight_batteries_item enabled:", this.enabled, "soundManager", soundManager.FLASHLIGHT_ON.player.isPlaying());
  }

  void enable() {

    //Find if note is opened
    UsableItem usable = usableItemManager.usablesMap.getOrDefault("notes_item", null);
    if (usable != null && usable.enabled) {
      invManager.checkAndEnableHiddenImageForFlashLight((IHasHiddenLayer)usable);
    } else
      if (stateHandler.currentState instanceof IHasHiddenLayer) {
        IHasHiddenLayer ihl = (IHasHiddenLayer)stateHandler.currentState;
        hiddenImage = ihl.getHiddenImage();
        hiddenColliders = ihl.getHiddenColliders();
        //createMaskArray();
        //copyApplyMask();

        println(stateHandler.currentState.name, enabled);
      }
  }

  void disable() {
  }

  void createMaskArray() {

    pg.beginDraw();
    pg.background(0);
    //pg.fill(255, 255, 255, 255);
    pg.imageMode(CORNER);
    //pg.ellipse(-maskW * 2, -maskH * 2, maskW, maskH);
    //pg.ellipse(0, 0, maskW, maskH);
    pg.image(mask, 0, 0);

    pg.loadPixels();
    for (int x = 0; x < maskW; x++)
    {
      for (int y = 0; y < maskH; y++)
      {
        maskArray[x + (y * maskW)] = pg.pixels[x + (y * width)];
      }
    }
    pg.updatePixels();
    pg.endDraw();
  }

  void copyApplyMask() {
    // this is what andreas was doing translated to Processing 124
    masked = hiddenImage.get(xPos - maskW/2, yPos - maskH/2, maskW, maskH);
    masked.mask(maskArray);
  }
}

class HiddenCollider {
  String name;
  Rect rect;
  boolean enabled = true;
  Object parent;

  HiddenCollider(String name, float x, float y, float w, float h) {
    this.name = name;
    this.rect = new Rect(x, y, w, h);
  }

  HiddenCollider(Object pParent, String name, float x, float y, float w, float h) {
    this(name, x, y, w, h);
    parent = pParent;
  }

  boolean pointInCollider(float xPos, float yPos) {
    return enabled == true && pointRect(xPos, yPos, rect.x, rect.y, rect.w, rect.h);
  }

  // POINT/RECTANGLE
  private boolean pointRect(float px, float py, float rx, float ry, float rw, float rh) {

    // is the point inside the rectangle's bounds?
    if (px >= rx &&        // right of the left edge AND
      px <= rx + rw &&   // left of the right edge AND
      py >= ry &&        // below the top AND
      py <= ry + rh) {   // above the bottom
      return true;
    }
    return false;
  }
}
