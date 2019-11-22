abstract class UIShape {
  color c = #FFFFFF;
  color strokeColor = #111111;
  int x;
  int y;
  int w;
  int h;

  UIShape(int pX, int pY) {
    x = pX;
    y = pY;
  }

  UIShape(int pX, int pY, int pW, int pH) {
    this(pX, pY);
    w = pW;
    h = pH;
  }

  abstract void display(float delta);

  void endDisplay() {
  }
}

class UIImageShape extends UIShape {

  PImage image;

  UIImageShape (int pX, int pY, String imageFileName) {
    super(pX, pY);
    image = loadImage(imageFileName);

    if (image != null) {
      w = round(image.width * widthRatio);
      h = round(image.height * heightRatio);
    }
  }

  void display(float delta) {
    
    tint(c);
    pushMatrix();
    translate(x, y);
    imageMode(CORNER);
    image(image, 0, 0, w, h);
    popMatrix();
    
    super.endDisplay();
  }
}
