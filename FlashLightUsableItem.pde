class FlashLightUsableItem extends UsableItem { //<>// //<>//

  PImage blackLightImage;
  PImage hiddenImage;

  PImage mask;
  PImage masked;

  float xPos;
  float yPos;

  PGraphics mG;

  int density;

  FlashLightUsableItem() {
    super();
    blackLightImage = loadImage("BlackLight.png");
    mask = loadImage("BlackLight mask.png");

    masked = new PImage(mask.width, mask.height);
  }

  void display() {
    imageMode(CENTER);
    //image(blackLightImage, mouseX, mouseY);

    if (hiddenImage != null) {
      mG.push();

      mG.translate(mG.width / 2, mG.height / 2);

      //mG.clear();
      mG.fill(255);
      mG.noStroke();
      mG.ellipse(mouseX, mouseY, 200 * widthRatio, 200 * heightRatio);
      mG.pop();

      hiddenImage.loadPixels();
      mG.loadPixels();

      pixelDensity(density);

      for (int pixY = 0; pixY < hiddenImage.height; pixY++) {
        for (int pixX = 0; pixX < hiddenImage.width; pixX++) {

          int i = (pixX + pixY * mG.width * ceil(density)) * 4;
          //go through all the pixel of the mask image and apply the alpha value of mask to my image
          //hiddenImage.pixels[i/* + 3*/] = mG.pixels[i/* + 3*/];
          hiddenImage.pixels[pixX + (pixY * hiddenImage.width)] = mG.pixels[pixX + (pixY * mG.width)];
        }
      }

      //update pixels of both image and mask graphics
      mG.updatePixels();
      hiddenImage.updatePixels();


      //display masked image
      image(hiddenImage, 0, 0, width, height);
      //applyMask();
      ////image(img1, 0, 0);
      //image(masked, xPos/* - mask.width/2*/, yPos/* - mask.height/2*/);
      //noFill();
      //ellipse(xPos, yPos, width/4, height/4);
    }
  }

  void step(float delta) {
    display();
  }

  void applyMask() {
    xPos = mouseX;
    yPos = mouseY;
    // this is what andreas was doing translated to Processing 124
    masked.copy(hiddenImage, mouseX - mask.width/2, mouseY - mask.height/2, mask.width, mask.height, 0, 0, mask.width, mask.height);
    masked.mask(mask);
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

      density = displayDensity();
      mG = createGraphics(hiddenImage.width / ceil(density), hiddenImage.height / ceil(density), P2D);

      println(stateHandler.currentState.name, enabled);
    }
  }

  void disable() {
  }
}
