import de.looksgood.ani.*;

class UITweenShape { //<>//

  ArrayList<Integer> shapesToRemove;
 
  public UITweenShape() {
    shapesToRemove = new ArrayList<Integer>();
  }

  void tweenShape(UIShape shape, String fieldName, int to, float duration, de.looksgood.ani.easing.Easing easing, float delay) {
    Ani.to(shape, duration, delay, fieldName, to, easing);
  }

  void tweenShape(UIShape shape, String fieldName, int to, float duration) {
    tweenShape(shape, fieldName, to, duration, Ani.CUBIC_OUT, 0);
  }

  //void step(float delta) {
  //  for (int i = 0; i < shapes.size(); i++) {
  //    UIShapeTweened s = shapes.get(i);
  //    s.step(delta);
  //    if (s.time > (s.duration + s.delay)) {
  //      s.shape.c = s.c & ~#000000 | (s.to << 24);
  //      s.shape.strokeColor = s.sc & ~#000000 | (s.to << 24);
  //      shapesToRemove.add(i);
  //    }
  //  }

  //  for (int i = shapesToRemove.size() - 1; i > -1; i--) {
  //    int inx = shapesToRemove.get(i);
  //    shapes.remove(inx);
  //  }

  //  shapesToRemove.clear();
  //}

  //class UIShapeTweened {
  //  float duration;
  //  float delay;
  //  float time;
  //  int from;
  //  int to;
  //  int alpha;
  //  UIShape shape;
  //  color c;
  //  color sc;
  //  color cc;

  //  public UIShapeTweened(UIShape _shape, int _from, int _to, float _duration, float _delay) {
  //    shape = _shape;
  //    from = _from;
  //    to = _to;
  //    duration = _duration;
  //    delay = _delay;
  //    c = shape.c;
  //    sc = shape.strokeColor;

  //    shape.c = c & 0xffffff | (from << 24);
  //    shape.strokeColor = sc & 0xffffff | (from << 24);
  //  }

  //  void step(float delta) {

  //    if (time >= delay) {
  //      alpha = round(EaseInOutQuad(time-delay, from, to - from, duration));

  //      shape.c = c & ~#000000 | (alpha << 24);
  //      shape.strokeColor = sc & ~#000000 | (alpha << 24);
  //    }

  //    time += delta;
  //  }
  //}

  //final float BezierBlend(float t)
  //{
  //  return sqrt(t) * (3.0f - 2.0f * t);
  //}

  //final float EaseInOutQuad(float t, int from, int change, float duration) {
  //  t /= duration/2;
  //  if (t < 1) return change/2*t*t + from;
  //  t--;
  //  return -change/2 * (t*(t-2) - 1) + from;
  //}
}
