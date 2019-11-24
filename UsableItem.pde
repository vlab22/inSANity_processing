import java.util.TreeMap;

class NotesUsableItem extends DetailsItensScreen implements IAction { //<>//

  float x = 642 * widthRatio;
  float y = 108 * heightRatio;

  Ani[] anim = new Ani[0];

  Map<Integer, UISprite> pages;

  int currentPage;

  boolean isDisabling = false;

  final float FADE_DURATION = 0.25;

  NotesUsableItem() {
    allowSceneMousePressed = false;
    name = "notes_item";
    alpha = 0;

    pages = new TreeMap<Integer, UISprite>();
  }

  void addPage(Object obj) {
    String str = (String)obj;
    String[] data = str.split(" ");
    String type = data[1];
    int index = Integer.parseInt(data[2]);

    switch(type) {
    case "page":
      UISprite sprite = new UISprite(0, 0, str + ".png");
      sprite.enabled = false;
      currentPage = index;
      pages.put(index, sprite);

      for (Map.Entry<Integer, UISprite> entry : pages.entrySet()) {
        println("pages:", entry.getKey());
      }

      break;
    default:
    }
    
    pages.get(currentPage).enabled = true;
  }

  void display(float delta) {
    super.display(delta);

    //for (Map.Entry<Integer, UISprite> entry : pages.entrySet()) {
     ((UISprite)pages.get(currentPage)).display(delta); //<>//
    //}
  }

  void step(float delta) {
    display(delta);

    //println("alpha", alpha, "enabled", enabled, anim.length, frameCount);
    //println("ani size:", Ani.size(), "overwrite:", Ani.getOverwriteMode());
  }

  void setEnabled(boolean val) {

    println("val", val, "isDisabling", isDisabling);

    if (val == true || (val == false && isDisabling == true)) {
      int lastAlpha = alpha;
      endFadeAnim();
      alpha = lastAlpha;
      anim = Ani.to(this, FADE_DURATION, 0, "alpha:200", Ani.CUBIC_OUT);
      enabled = true;
      isDisabling = false;
    } else {
      int lastAlpha = alpha;
      endFadeAnim();
      alpha = lastAlpha;
      isDisabling = true;
      anim = Ani.to(this, FADE_DURATION, 0, "alpha:0", Ani.CUBIC_OUT, this, "onEnd:disable");
    }
  }

  private void disable() {
    enabled = false;
    isDisabling = false;
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

  private void endFadeAnim() {
    for (int i = 0; i < anim.length; i++) {
      //anim[i].setCallback("onEnd:foo");
      anim[i].end();
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
}
