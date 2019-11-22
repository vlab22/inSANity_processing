/*
* Effect of screen transition, FADE to black is the default
 */

import de.looksgood.ani.*;

public abstract class StateTransition {
  float duration = 0.200;
  float delay = 0;

  public Object callBackObject;
  public String callBackName = "onEnd:leaveStateAfterTransition";

  boolean enabled;
  boolean isPlaying;

  protected Ani animation;

  abstract void execute();
  abstract boolean isPlaying();
}

public class SceneTransition extends StateTransition {
  color c = color(1,1,1);
  int w;
  int h;

  int alpha = 0;
  int start = 0;
  int to = 255;
  de.looksgood.ani.easing.Easing easing = AniConstants.QUAD_OUT;

  public SceneTransition() {
    w = width;
    h = height;
    callBackObject = stateHandler;
  }

  public void execute() {
    c = (c & 0xffffff) | (start << 24);
    alpha = start;
    
    isPlaying = true;
    enabled = true;
    animation = Ani.to(this, duration, delay, "alpha", float(to), easing, callBackObject, callBackName);
  }

  public void display() {
    if (enabled) {
      noStroke();
      fill((c & 0xffffff) | (alpha << 24));
      rectMode(CORNER);
      rect(0, 0, w, h);
    }
  }

  boolean isPlaying() {
    boolean ret = animation != null && (animation.isPlaying() || animation.isDelaying());
    return ret;
  }
}
