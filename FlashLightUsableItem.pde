class FlashLightUsableItem extends UsableItem implements IWaiter { 

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
  }

  void display() {
    imageMode(CENTER);

    if (hiddenImage != null) {

      copyApplyMask();

      image(masked, xPos, yPos);
      
      //Hack to draw note overlay in attic
      if (stateHandler.currentState.name.equals("AtticScene")){
        AtticScene attic = (AtticScene)ATTIC_SCENE;
        
        if (attic.noteInScene == true) {
          attic.notesPlaceButton.display();
        }
      }
    }

    image(blackLightImage, mouseX, mouseY);
  }

  void step(float delta) {
    if (hiddenImage != null) {
      xPos = mouseX;
      yPos = mouseY;

      //Checks if the mouse hits the hiddencollider of hidden messages
      for (int i = 0; i < hiddenColliders.length; i++) {

        if (hiddenColliders[i].pointInCollider(xPos, yPos)) {

          hiddenColliders[i].parent.hiddenColliderHit(hiddenColliders[i]);

          if (hiddenColliders[i].parent instanceof NotesUsableItem) {
          }

          println("inside", hiddenColliders[i].name);
        }
      }
    }

    display();
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

  void execute(int executeId, Object obj) {
  }
}

class HiddenCollider {
  String name;
  Rect rect;
  boolean enabled = true;
  IHasHiddenLayer parent;

  HiddenCollider(IHasHiddenLayer pParent, String name, float x, float y, float w, float h) {
    this.name = name;
    this.rect = new Rect(x, y, w, h);
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
