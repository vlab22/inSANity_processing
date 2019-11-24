import java.util.TreeMap; //<>// //<>//

class NotesUsableItem extends DetailsItensScreen implements IAction {

  float x = 642 * widthRatio;
  float y = 108 * heightRatio;

  Ani[] anim = new Ani[0];
  Ani[] animPage = new Ani[0];

  Map<Integer, UISprite> pages;

  int currentPageIndex;
  UISprite currentPage;

  ImageButton rightArrow;
  ImageButton leftArrow;

  int rightArrowX;
  int rightArrowY;

  int leftArrowX;
  int leftArrowY;

  boolean isDisabling = false;

  final float FADE_DURATION = 2;

  NotesUsableItem() {
    allowSceneMousePressed = false;
    name = "notes_item";
    alpha = 0;

    pages = new TreeMap<Integer, UISprite>();

    rightArrowX = round(639 * widthRatio);
    rightArrowY = round(474 * heightRatio);

    leftArrowX = round(-21 * widthRatio);
    leftArrowY = round(474 * heightRatio);

    rightArrow = new ImageButton( "Notes nav arrow right.png", rightArrowX, rightArrowY, "Notes nav arrow right outline.png" );
    leftArrow = new ImageButton( "Notes nav arrow left.png", leftArrowX, leftArrowY, "Notes nav arrow left outline.png" );
  }

  void addPage(Object obj) {
    String str = (String)obj;
    String[] data = str.split(" ");
    String type = data[1];
    int index = Integer.parseInt(data[2]);

    switch(type) {
    case "page":
      currentPageIndex = index;

      if (pages.containsKey(index)) {
        currentPage = pages.get(index);
      } else {
        UISprite sprite = new UISprite(0, 0, str + ".png");
        sprite.enabled = false;
        sprite.alpha = 0;

        pages.put(index, sprite);
        currentPage = sprite;

        for (Map.Entry<Integer, UISprite> entry : pages.entrySet()) {
          println("pages:", entry.getKey());
        }
      }
      break;
    default:
    }
  }

  void display(float delta) {
    super.display(delta);

    currentPage.x = round(x);
    currentPage.y = round(y);
    currentPage.display(delta);

    rightArrow.x = round(x + rightArrowX);
    rightArrow.y = round(y + rightArrowY);

    leftArrow.x = round(x + leftArrowX);
    leftArrow.y = round(y + leftArrowY);
    
    rightArrow.display();
    leftArrow.display();
  }

  void step(float delta) {
    display(delta);
  }
  
  void handleMousePressed() { 
    super.handleMousePressed();
  }

  void setEnabled(boolean val) {

    println("val", val, "isDisabling", isDisabling);

    UISprite page = currentPage;

    if (val == true || (val == false && isDisabling == true)) {
      //Fade In BG
      int lastAlpha = alpha;
      endFadeAnim(anim);
      alpha = lastAlpha;
      anim = Ani.to(this, FADE_DURATION, 0, "alpha:200", Ani.CUBIC_OUT);
      enabled = true;

      //Fade in Current Page
      int lastPageAlpha = page.alpha;
      endFadeAnim(animPage);
      page.alpha = lastPageAlpha;
      animPage = Ani.to(page, FADE_DURATION, 0, "alpha:255", Ani.CUBIC_OUT);
      page.enabled = true;

      isDisabling = false;
    } else {
      //Fade Out BG
      int lastAlpha = alpha;
      endFadeAnim(anim);
      alpha = lastAlpha;
      anim = Ani.to(this, FADE_DURATION, 0, "alpha:0", Ani.CUBIC_OUT);

      //Fade Out Current Page
      int lastPageAlpha = page.alpha;
      endFadeAnim(animPage);
      page.alpha = lastPageAlpha;
      animPage = Ani.to(page, FADE_DURATION, 0, "alpha:0", Ani.CUBIC_OUT, this, "onEnd:disable");

      isDisabling = true;
    }
  }

  private void disable() {
    enabled = false;
    pages.get(currentPageIndex).enabled = false;
    isDisabling = false;
  }

  private void disablePage() {
    pages.get(currentPageIndex).enabled = false;
  }

  private void foo() {
  }

  void execute(Object obj) {
  }

  private boolean isPlaying() {
    for (int i = 0; i < anim.length; i++) {
      if (anim[i].isPlaying() || anim[i].isDelaying()) {
        return true;
      }
    }

    return false;
  }

  private void endFadeAnim(Ani[] ani) {
    for (int i = 0; i < ani.length; i++) {
      ani[i].setCallbackObject(this);
      ani[i].setCallback("onEnd:foo");
      ani[i].end();
    }
  }
}

abstract class DetailsItensScreen extends UsableItem {
  color bgColor = color(1);
  int alpha = 0;

  void display(float delta) {
    bgColor = bgColor & 0xffffff | alpha << 24;

    fill(bgColor);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
  }
}

abstract class UsableItem {
  String name;
  boolean enabled = false;
  boolean allowSceneMousePressed = true;

  abstract void setEnabled(boolean val);
  abstract void step(float delta);
  void handleMousePressed() { }
}
