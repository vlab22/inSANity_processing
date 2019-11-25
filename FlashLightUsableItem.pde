class FlashLightUsableItem extends UsableItem { //<>// //<>//

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
    mask = loadImage("BlackLight mask.png");

    maskW = round(mask.width * widthRatio);
    maskH = round(mask.height * heightRatio);

    masked = new PImage(maskW, maskH);

    pg = createGraphics(width, height, P2D);

    maskArray = new int[maskW * maskH];

    createMaskArray();
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

    image(blackLightImage, mouseX, mouseY, blackLightImage.width * widthRatio, blackLightImage.height * heightRatio);
  }

  void step(float delta) {
    if (hiddenImage != null) {
      xPos = mouseX;
      yPos = mouseY;

      for (int i = 0; i < hiddenColliders.length; i++) {
        if (hiddenColliders[i].pointInCollider(xPos, yPos)) {
          hiddenColliders[i].enabled = false;
          soundManager.LIMBO_SOUND.play();
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
    pg.image(mask, 0, 0, mask.width * widthRatio, mask.height * heightRatio);

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

  HiddenCollider(String name, float x, float y, float w, float h) {
    this.name = name;
    this.rect = new Rect(x, y, w, h);
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
