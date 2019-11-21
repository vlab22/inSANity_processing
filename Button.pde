import de.looksgood.ani.*; //<>//

class ImageButton {
  int x;
  int y;

  String buttonFilename;
  PImage buttonImage;

  PImage onHoverButtonImage;

  int alpha = 0;
  float onHoverTweenDuration = 0.25;
  int to = 0;
  Ani anim;
  int playDir;

  int colliderWidth = 100;
  int colliderHeight = 100;

  color overlayColor = color(255, 0, 0);

  ImageButton( String buttonImageFilename, int newX, int newY ) {
    buttonFilename = buttonImageFilename;
    x = newX;
    y = newY;

    if (buttonFilename != null) {
      buttonImage = loadImage( buttonFilename );
    }

    if (buttonImage != null) {
      colliderWidth = buttonImage.width;
      colliderHeight = buttonImage.height;
    }

    anim = new Ani(this, onHoverTweenDuration, 0, "alpha", to, Ani.QUAD_OUT);
  }

  ImageButton( String buttonImageFilename, int newX, int newY, String onHoverButtonImageFilename ) {
    this(buttonImageFilename, newX, newY);
    onHoverButtonImage = loadImage( onHoverButtonImageFilename );

    colliderWidth = onHoverButtonImage.width;
    colliderHeight = onHoverButtonImage.height;
  }

  void display() {
    if (buttonImage != null)
      image( buttonImage, x, y, buttonImage.width * widthRatio, buttonImage.height * heightRatio);

    if (onHoverButtonImage != null) {
      if (alpha < 255 && isPointInside(mouseX, mouseY) && playDir != 1) {
        to = 255;
        anim.setBegin(alpha);
        anim.setEnd(to);
        playDir = 1;
        anim.start();
      } else if (alpha > 0 && isPointInside(mouseX, mouseY) == false && playDir != -1) {
        to = 0;
        anim.setBegin(alpha);
        anim.setEnd(to);
        playDir = -1;
        anim.start();
      }
      pushStyle();
      tint(overlayColor, alpha);
      imageMode(CORNER);
      image(onHoverButtonImage, x, y, onHoverButtonImage.width * widthRatio, onHoverButtonImage.height * heightRatio);
      popStyle();
    }
  }

  boolean isPointInside( int px, int py ) {
    return isPointInRectangle( px, py, x, y, colliderWidth * widthRatio, colliderHeight * heightRatio );
  }
}


class TextButton {
  int x;
  int y;

  String buttonText;
  int buttonTextSize;

  int buttonWidth;
  int buttonHeight;

  int offset;

  TextButton( int newX, int newY, String aButtonText, int aButtonTextSize ) {
    x = newX;
    y = newY;
    buttonText = aButtonText;
    buttonTextSize = aButtonTextSize;
    buttonWidth = 0;
    offset = buttonTextSize / 5;
  }

  void display() {
    stroke( 0 );
    strokeWeight( 3 );
    fill( 255, 128 );
    rect( x - offset, y - offset, buttonWidth + 2 * offset, buttonHeight + 2 * offset);
    fill( 0 );
    textSize( buttonTextSize );
    if ( buttonWidth == 0 ) {
      buttonWidth = (int) textWidth( buttonText );
      buttonHeight = buttonTextSize;
    }
    text( buttonText, x, y + buttonTextSize * 0.9);
  }

  boolean isPointInside( int px, int py ) {
    return isPointInRectangle( px, py, x - offset, y - offset, 
      buttonWidth + 2 * offset, buttonTextSize +  2 * offset);
  }
}


class HintButton extends ImageButton {
  TextButton textButton;
  int max_distance;

  HintButton( String buttonImageFilename, String hintText, int newX, int newY ) {
    super( buttonImageFilename, newX, newY );
    textButton = new TextButton( x - 30, y - 30, hintText, 20 );
  }

  void display() {
    if ( buttonImage == null ) {
      buttonImage = loadImage( buttonFilename );
      max_distance = buttonImage.width * 6;
    }

    float distance = dist( mouseX, mouseY, x + buttonImage.width / 2, y + buttonImage.height / 2);
    if ( distance < 30 ) {
      image( buttonImage, x, y );
      textButton.display();
    } else if ( distance < max_distance ) {
      tint(255, map( distance, 50, max_distance, 255, 0 ) );  // Apply transparency without changing color
      image( buttonImage, x, y );
      tint(255, 255);
    }
  }
}
