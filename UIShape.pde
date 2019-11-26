class UISprite extends UIShape {

  PImage image;

  boolean enabled = true;

  UISprite (int pX, int pY, String imageFileName) {
    super(round(pX * widthRatio), round(pY * heightRatio));
    image = loadImage(imageFileName);

    if (image != null) {
      w = round(image.width * widthRatio);
      h = round(image.height * heightRatio);
      colliderW = w;
      colliderH = h;
    }
  }

  void display(float delta) {
    if (enabled) {
      c = (c & 0xffffff) | (alpha << 24);
      tint(c);
      pushMatrix();
      translate(x, y);
      imageMode(CORNER);
      image(image, 0, 0, w, h);
      popMatrix();

      super.endDisplay();
    }
  }
}

abstract class UIShape {
  color c = #FFFFFF;
  color strokeColor = #111111;
  int alpha = 255;
  
  int x;
  int y;
  int w;
  int h;

  int colliderW;
  int colliderH;

  UIShape(int pX, int pY) {
    x = pX;
    y = pY;
  }

  UIShape(int pX, int pY, int pW, int pH) {
    this(pX, pY);
    w = pW;
    h = pH;
    colliderW = w;
    colliderH = h;
  }

  abstract void display(float delta);

  void endDisplay() {
  }
}

class Rect {
  float x;
  float y;
  float w;
  float h;
 
  Rect(float pX, float pY, float pW, float pH) {
    x = pX * widthRatio;
    y = pY * heightRatio;
    w = pW * widthRatio;
    h = pH * heightRatio;
  }
}
