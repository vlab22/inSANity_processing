class TextBoxWithFader {  //<>//

  private int alpha;

  private float showDuration;
  private float hideDuration;
  private float delay;

  TextBox textBox;

  private Ani anim;

  private IAnim animHandler;

  TextBoxWithFader() {
    textBox = new TextBox();
    alpha = 0;

    textBox.bgColor = (textBox.bgColor & 0xffffff) | (alpha << 24);
    textBox.borderColor = (textBox.borderColor & 0xffffff) | (alpha << 24);
    textBox.textColor = (textBox.textColor & 0xffffff) | (alpha << 24);

    anim = new Ani(this, 0.2, 0, "alpha", 255, Ani.QUAD_OUT, this, "onUpdate:update");
  }

  TextBoxWithFader(float duration, float delay) {
    this();
    this.showDuration = duration;
    this.hideDuration = duration * 0.5;
    this.delay = delay;
  }

  TextBoxWithFader(String text, float duration, float delay) {
    this( duration, delay);
    textBox.setText(text);
  }

  TextBoxWithFader(String text, float duration, float delay, IAnim handler) {
    this(text, duration, delay);
    animHandler = handler;
  }

  void show() {
    setFrom(0);
    setTo(255);
    setDuration(showDuration);
    setDelay(delay);
    anim.setCallback("onEnd:onShow");
    anim.start();
  }

  void hide() {
    setFrom(255);
    setTo(0);
    setDuration(hideDuration);
    setDelay(0);
    anim.setCallback("onEnd:onHide");
    anim.start();
  }

  void display() {
    textBox.display();
  }

  void update() {
    textBox.bgColor = (textBox.bgColor & 0xffffff) | (alpha << 24);
    textBox.borderColor = (textBox.borderColor & 0xffffff) | (alpha << 24);
    textBox.textColor = (textBox.textColor & 0xffffff) | (alpha << 24);

    println("text box alpha: " + alpha);
  }

  void onShow() {
    if (animHandler != null)
      animHandler.onAnimShow();
  }

  void onHide() {
    if (animHandler != null)
      animHandler.onAnimEnd(animHandler);
  }

  void setFrom(int from) {
    anim.setBegin(from);
  }

  void setTo(int to) {
    anim.setEnd(to);
  }

  void setDuration(float duration) {
    anim.setDuration(duration);
  }

  void setDelay(float delay) {
    anim.setDelay(delay);
  }
}

class TextBox {

  private PFont font;
  private String text = ""; 
  private float textSize = 32;

  color textColor = #FFFFFF;
  color bgColor = #111111;
  color borderColor = #FFFFFF;

  float strokeWeight = 2;

  float boxWidth = 300;
  float boxHeight = 50;
  PVector boxPosition;

  int paddingH = 10;  // horizontal padding
  int paddingV = 10;  // vertical padding

  boolean autoCenter = true;

  TextBox() {
    font = createFont("Gaiatype", textSize, true);

    text = "The quick brown fox\r\njumps over the lazy dog!";

    updateBoxSize();

    boxPosition = new PVector(width/2 - boxWidth/2, height - boxHeight - 100 * heightRatio);
  }

  void display() {

    updateBoxSize();

    pushMatrix();
    translate(boxPosition.x, boxPosition.y);
    fill(bgColor);
    stroke(borderColor);
    strokeWeight(strokeWeight);
    rectMode(CORNER);
    rect(0, 0, boxWidth, boxHeight);

    fill(textColor);

    textAlign(LEFT, TOP);
    text(text, paddingH * widthRatio, paddingV * heightRatio);

    popMatrix();
  }

  void setText(String text) {
    this.text = text;
    centralize();
  }

  void setTextSize(float size) {
    textSize = size;
    font = createFont("Gaiatype", textSize, true);
    centralize();
  }

  private void updateBoxSize() {
    textFont(font, textSize * heightRatio);
    float textWidth = textWidth(text);
    int lineCount = text.split("\r\n|\r|\n").length;
    float textHeight = (lineCount > 1) ? lineCount * textSize * heightRatio + (lineCount - 1) * 10 * heightRatio : textSize * heightRatio;

    boxWidth = textWidth + 2 * paddingH * widthRatio;
    boxHeight = textHeight + 2 * paddingV * heightRatio;
  }

  void centralize() {
    updateBoxSize();
    boxPosition = new PVector(width/2 - boxWidth/2, height - boxHeight - 100 * heightRatio);
  }
}
