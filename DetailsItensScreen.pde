class NotesUsableItem extends DetailsItensScreen implements IAction { //<>// //<>//

  Ani[] anim = new Ani[0];

  boolean isDisabling = false;

  NotesUsableItem() {
    alpha = 0;
  }

  void step(float delta) {
    display(delta);
    println("alpha", alpha, "enabled", enabled, anim.length, frameCount);
  }

  void setEnabled(boolean val) {

    println("val", val, "isDisabling", isDisabling);

    if (val == true || (val == false && isDisabling == true)) {
      int lastAlpha = alpha;
      endFadeAnim();
      alpha = lastAlpha;
      anim = Ani.to(this, 2, 0, "alpha:200", Ani.CUBIC_OUT);
      enabled = true;
      isDisabling = false;
    } else {
      int lastAlpha = alpha;
      endFadeAnim();
      alpha = lastAlpha;
      isDisabling = true;
      anim = Ani.to(this, 2, 0, "alpha:0", Ani.CUBIC_OUT, this, "onEnd:disable");
    }
    //}
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
      anim[i].setCallback("onEnd:foo");
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

  abstract void setEnabled(boolean val);
  abstract void step(float delta);
}
