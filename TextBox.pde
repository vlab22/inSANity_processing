class TextBoxManager implements IWaiter, IAnim { //<>//

  HashSet<TextItem> textBoxesMap = new HashSet<TextItem>();
  HashSet<TextBoxWithFader> itemsToHideRemove = new HashSet<TextBoxWithFader>();

  final float DEFAULT_FADE_IN_DURATION = 0.2;
  final float DEFAULT_FADE_OUT_DURATION = 0.2;

  final float DEFAULT_DURATION = 3;


  void step(float delta) {
    for (TextItem textItem : textBoxesMap) {
      TextBoxWithFader box = textItem.box;
      box.display();
      
      if (textItem.timeCounter >= textItem.duration && !itemsToHideRemove.contains(textItem.box)) {
        itemsToHideRemove.add(textItem.box);
        box.hide();
      }
      
      textItem.timeCounter += delta;
    }
  }

  void showText(String text, float duration) {
    TextBoxWithFader box = new TextBoxWithFader();
    box.textBox.setText(text);
    
    TextItem textItem = new TextItem(box, duration);
    
    textBoxesMap.add(textItem);
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
    }
  }

  void onAnimShow(Object obj) {
  }
  void onAnimEnd(Object obj) {
    
  }

  class TextItem {
    TextBoxWithFader box;
    float duration;
    
    float timeCounter = 0;
    
    TextItem(TextBoxWithFader pBox, float pDuration) {
      box = pBox;
      duration = pDuration;
    }
  }
}

class TextBoxWithFader {  //<>// //<>// //<>// //<>//

  private int alpha;

  private float fadeInDuration;
  private float fadeOutDuration;
  private float delay;

  TextBox textBox;

  private Ani anim;

  private IAnim animHandler;

  boolean enabled = true;
  boolean disableAfterHide;

  TextBoxWithFader() {
    textBox = new TextBox();
    alpha = 0;

    textBox.bgColor = (textBox.bgColor & 0xffffff) | (alpha << 24);
    textBox.borderColor = (textBox.borderColor & 0xffffff) | (alpha << 24);
    textBox.textColor = (textBox.textColor & 0xffffff) | (alpha << 24);

    this.fadeInDuration = 0.5;
    this.fadeOutDuration = 0.5;
    this.delay = 0.2;

    this.enabled = false;

    anim = new Ani(this, fadeInDuration, 0, "alpha", 255, Ani.QUAD_OUT, this, "onUpdate:update");
    anim.end();
  }

  TextBoxWithFader(float pFadeInDuration, float delay) {
    this();
    this.fadeInDuration = pFadeInDuration;
    this.delay = delay;
  }

  TextBoxWithFader(String text, float showDuration, float delay) {
    this( showDuration, delay);
    textBox.setText(text);
  }

  TextBoxWithFader(String text, float showDuration, float hideDuration, float delay) {
    this(text, showDuration, delay);
    this.fadeOutDuration = hideDuration;
  }

  TextBoxWithFader(String text, float showDuration, float hideDuration, float delay, boolean disableAfterHide) {
    this(text, showDuration, hideDuration, delay);
    this.disableAfterHide = disableAfterHide;
  }

  TextBoxWithFader(String text, float showDuration, float hideDuration, float delay, boolean disableAfterHide, IAnim handler) {
    this(text, showDuration, hideDuration, delay, disableAfterHide);
    animHandler = handler;
  }

  TextBoxWithFader(String text) {
    this(text, 1, 0.2, 0.2, true);
  }

  TextBoxWithFader(String text, boolean disableAfterHide) {
    this(text, 1, 0.2, 0.2, disableAfterHide);
  }

  void show() {
    println("textbox show", alpha, frameCount, "text:", textBox.text);
    this.enabled = true;
    setFrom(alpha);
    setTo(255);
    setFadeInDuration(fadeInDuration);
    setDelay(delay);
    anim.setCallback("onEnd:onShow");
    anim.start();
  }

  void hide() {
    println("textbox hide", alpha, frameCount, "text:", textBox.text);
    if (alpha > 0) {
      anim.end();
      setFrom(alpha);
      setTo(0);
      setFadeInDuration(fadeOutDuration);
      setDelay(0);
      anim.setCallback("onEnd:onHide");
      anim.start();
    }
  }

  void display() {
    if (enabled)
      textBox.display();
  }

  void update() {
    textBox.bgColor = (textBox.bgColor & 0xffffff) | (alpha << 24);
    textBox.borderColor = (textBox.borderColor & 0xffffff) | (alpha << 24);
    textBox.textColor = (textBox.textColor & 0xffffff) | (alpha << 24);
  }

  void onShow() {
    if (animHandler != null)
      animHandler.onAnimShow(this);
  }

  void onHide() {
    println("textbox onHide", alpha, frameCount, "disableAfterHide", disableAfterHide, "text:", textBox.text);
    if (disableAfterHide) {
      this.enabled = false;
    }
    if (animHandler != null)
      animHandler.onAnimEnd(this);
  }

  void setFrom(int from) {
    anim.setBegin(from);
  }

  void setTo(int to) {
    anim.setEnd(to);
  }

  void setFadeInDuration(float duration) {
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
    //font = createFont("Gaiatype", textSize, true);
    font = loadFont(MAIN_FONT_32);

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
    boxPosition = new PVector(width/2 - boxWidth/2, height - boxHeight - 170 * heightRatio);
  }
}
