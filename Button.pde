

class ImageButton {
    int x;
    int y;

    String buttonFilename;
    PImage buttonImage;
    
    ImageButton( String buttonImageFilename, int newX, int newY ) {
        buttonFilename = buttonImageFilename;
        x = newX;
        y = newY;
    }
    
    void display() {
        if ( buttonImage == null ) {
             buttonImage = loadImage( buttonFilename );

        }
        image( buttonImage, x, y );
        //noFill();
        //stroke( 255, 0, 255 );
        //rect( x, y, buttonImage.width, buttonImage.height );
    }
    
   boolean isPointInside( int px, int py ) {
       return isPointInRectangle( px, py, x, y, buttonImage.width, buttonImage.height );
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
       return isPointInRectangle( px, py, x - offset, y - offset ,
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
        }  else if ( distance < max_distance ) {
            tint(255, map( distance, 50, max_distance, 255, 0 ) );  // Apply transparency without changing color
            image( buttonImage, x, y );
            tint(255, 255);
        }
    }
}
