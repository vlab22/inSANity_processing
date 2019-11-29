import java.util.TreeMap; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.util.*;

class NotesUsableItem extends DetailsItensScreen implements IHasHiddenLayer, IWaiter {

  float x = 642 * widthRatio;
  float y = 108 * heightRatio;

  Ani[] anim = new Ani[0];
  Ani[] animPageFade = new Ani[0];
  Ani[] animPageFlip = new Ani[0];

  NavigableMap<Integer, UISprite> pages;
  Iterator<Map.Entry<Integer, UISprite>> pageEntries;

  HashMap<Integer, ArrayList<UISprite>> hiddenWords = new HashMap<Integer, ArrayList<UISprite>>();
  HashMap<Integer, HiddenCollider[]> hiddenWordsColliders = new HashMap<Integer, HiddenCollider[]>();

  int currentPageNumber;
  UISprite currentPage;
  UISprite lastPage;

  ImageButton rightArrow;
  ImageButton leftArrow;
  ImageButton closeButton;

  int rightArrowX;
  int rightArrowY;

  int leftArrowX;
  int leftArrowY;

  int closeButtonX;
  int closeButtonY;

  boolean closeButtonColliderEnabled = true;

  boolean isDisabling = false;

  final float FADE_DURATION = 0.25;
  final float PAGE_FLIP_DURATION = 0.25;

  HashMap<Integer, PImage> hiddenImages = new HashMap<Integer, PImage>();

  int hiddenWordsFound = 0;

  final int MAX_WORDS_FOUND_TO_END = 15;

  boolean itemSoundEnabled = true; //in the game ends, disable sound

  TextBoxWithFader placeText = new TextBoxWithFader();

  NotesUsableItem() {
    allowSceneMousePressed = false;
    name = "notes_item";
    alpha = 0;

    pages = new TreeMap<Integer, UISprite>();

    rightArrowX = round(639 * widthRatio);
    rightArrowY = round(474 * heightRatio);

    leftArrowX = round(-21 * widthRatio);
    leftArrowY = round(474 * heightRatio);

    closeButtonX = round(627 * widthRatio);
    closeButtonY = round(0 * heightRatio);

    rightArrow = new ImageButton( "Notes nav arrow right.png", rightArrowX, rightArrowY, "Notes nav arrow right outline.png" );
    leftArrow = new ImageButton( "Notes nav arrow left.png", leftArrowX, leftArrowY, "Notes nav arrow left outline.png" );
    closeButton = new ImageButton( "Close Button.png", closeButtonX, closeButtonY, "Close Button overlay.png" );

    //Creates hidden words sprites
    hiddenWords.put(1, new ArrayList<UISprite>() {
      {
        add(new UISprite(679, 299, "notes_item page 1 - word 0 - hidden.png")); //I need
        add(new UISprite(936, 347, "notes_item page 1 - word 1 - hidden.png")); //to
        add(new UISprite(1084, 442, "notes_item page 1 - word 2 - hidden.png")); //feel
        add(new UISprite(757, 587, "notes_item page 1 - word 3 - hidden.png")); //safe
      }
    }
    );
    hiddenWords.put(2, new ArrayList<UISprite>() {
      {
        add(new UISprite(669, 290, "notes_item page 2 - word 0 - hidden.png")); //I
        add(new UISprite(1116, 348, "notes_item page 2 - word 1 - hidden.png")); //want
        add(new UISprite(996, 495, "notes_item page 2 - word 2 - hidden.png")); //you
        add(new UISprite(1134, 484, "notes_item page 2 - word 3 - hidden.png")); //gone
      }
    }
    );
    hiddenWords.put(3, new ArrayList<UISprite>() {
      {
        add(new UISprite(710, 455, "notes_item page 3 - word 0 - hidden.png")); //Stop
        add(new UISprite(714, 516, "notes_item page 3 - word 1 - hidden.png")); //beating
        add(new UISprite(839, 519, "notes_item page 3 - word 2 - hidden.png")); //me
      }
    }
    );
    hiddenWords.put(4, new ArrayList<UISprite>() {
      {
        add(new UISprite(750, 286, "notes_item page 4 - word 0 - hidden.png")); //is
        add(new UISprite(855, 409, "notes_item page 4 - word 1 - hidden.png")); //violence
        add(new UISprite(785, 463, "notes_item page 4 - word 2 - hidden.png")); //the
        add(new UISprite(909, 520, "notes_item page 4 - word 3 - hidden.png")); //answer
      }
    }
    );
    hiddenWords.put(5, new ArrayList<UISprite>());

    //Disable hidden sprites
    for (Map.Entry<Integer, ArrayList<UISprite>> entry : hiddenWords.entrySet()) {
      setEnabledPageHiddenWordsSprites(entry.getKey(), false);
    }


    //Create hiddenCollider of words
    hiddenWordsColliders.put(1, new HiddenCollider[] {
      new HiddenCollider(this, "page 1 0", 681, 242, 200, 200), 
      new HiddenCollider(this, "page 1 1", 890, 291, 200, 200), 
      new HiddenCollider(this, "page 1 2", 1038, 379, 200, 200), 
      new HiddenCollider(this, "page 1 3", 727, 534, 200, 200), 
      });

    hiddenWordsColliders.put(2, new HiddenCollider[] {
      new HiddenCollider(this, "page 2 0", 616, 239, 200, 200), //I
      new HiddenCollider(this, "page 2 1", 1071, 278, 200, 200), //want
      new HiddenCollider(this, "page 2 2", 941, 429, 200, 200), //you 
      new HiddenCollider(this, "page 2 3", 1081, 423, 200, 200), //gone
      });

    hiddenWordsColliders.put(3, new HiddenCollider[] {
      new HiddenCollider(this, "page 3 0", 658, 399, 200, 200), //Stop
      new HiddenCollider(this, "page 3 1", 665, 445, 200, 200), //beating
      new HiddenCollider(this, "page 3 2", 766, 446, 200, 200), //me 
      });
    hiddenWordsColliders.put(4, new HiddenCollider[]{
      new HiddenCollider(this, "page 4 0", 685, 212, 200, 200), //is
      new HiddenCollider(this, "page 4 1", 826, 340, 200, 200), //violence
      new HiddenCollider(this, "page 4 2", 719, 387, 200, 200), //the
      new HiddenCollider(this, "page 4 3", 880, 466, 200, 200), //answer
      });
    hiddenWordsColliders.put(5, new HiddenCollider[]{
      new HiddenCollider(this, "page 5 0", 717, 253, 487, 685), //kill kill kill
      });
  }

  void addPage(Object obj) {
    String str = (String)obj;
    String[] data = str.split(" ");
    String type = data[1];
    int index = Integer.parseInt(data[2]);

    switch(type) {
    case "page":
      currentPageNumber = index;

      if (pages.containsKey(index)) {
        currentPage = pages.get(index);
      } else {
        UISprite sprite = new UISprite(0, 0, str + ".png");
        sprite.enabled = false;
        sprite.alpha = 0;

        pages.put(index, sprite);
        pageEntries = pages.entrySet().iterator();

        currentPage = sprite;

        //Add Hidden Image
        UISprite hiddenSprite = new UISprite(0, 0, str + " hidden.png");
        hiddenSprite.image.resize(round(hiddenSprite.image.width * widthRatio), round(hiddenSprite.image.height * heightRatio));
        hiddenImages.put(index, hiddenSprite.image);

        for (Map.Entry<Integer, UISprite> entry : pages.entrySet()) {
          //println("pages:", entry.getKey());
        }
      }
      break;
    default:
    }
  }

  void display(float delta) {
    super.display(delta);

    if (lastPage != null) {
      lastPage.x = round(x);
      lastPage.y = round(y);
      lastPage.display(delta);
    }

    currentPage.x = round(x);
    currentPage.y = round(y);
    currentPage.display(delta);

    //Draw current hidden words if enabled
    for (UISprite sprite : hiddenWords.get(currentPageNumber)) {
      sprite.display(delta);
    }

    rightArrow.x = round(x + rightArrowX);
    rightArrow.y = round(y + rightArrowY);

    leftArrow.x = round(x + leftArrowX);
    leftArrow.y = round(y + leftArrowY);

    closeButton.x = round(x + closeButtonX);
    closeButton.y = round(y + closeButtonY);

    placeText.display();

    rightArrow.display();
    leftArrow.display();
    closeButton.display();
  }

  void step(float delta) {
    display(delta);

    for (Map.Entry<Integer, UISprite> entry : pages.entrySet()) {
      //println(entry.getKey(), entry.getValue().alpha, entry.getValue().enabled);
    }

    if (keyPressed && key == 'c') {
      setEnabled(false);
    }
  }

  void handleMousePressed() { 
    super.handleMousePressed();

    if (rightArrow.isPointInside(mouseX, mouseY)) {
      Map.Entry<Integer, UISprite> nextPage = pages.higherEntry(currentPageNumber);
      if (nextPage != null) {

        currentPageNumber = nextPage.getKey();
        println("currentPageIndex:", currentPageNumber);

        lastPage = currentPage;

        UITweenSprite.tweenSprite(lastPage, "alpha:0", PAGE_FLIP_DURATION, 0, Ani.CUBIC_IN, this, "onEnd:foo");

        currentPage = nextPage.getValue();
        currentPage.enabled = true;
        UITweenSprite.tweenSprite(currentPage, "alpha:255", PAGE_FLIP_DURATION, 0, this, "onEnd:foo");

        invManager.checkAndEnableHiddenImageForFlashLight(this);

        soundManager.PAGE_FLIP[0].play();
      }
    } else if (leftArrow.isPointInside(mouseX, mouseY)) {
      Map.Entry<Integer, UISprite> prevPage = pages.lowerEntry(currentPageNumber);
      if (prevPage != null) {

        currentPageNumber = prevPage.getKey();
        println("currentPageIndex:", currentPageNumber);

        lastPage = currentPage;

        UITweenSprite.tweenSprite(lastPage, "alpha:0", PAGE_FLIP_DURATION, 0, Ani.CUBIC_IN, this, "onEnd:foo");

        currentPage = prevPage.getValue();
        currentPage.enabled = true;
        UITweenSprite.tweenSprite(currentPage, "alpha:255", PAGE_FLIP_DURATION, 0, this, "onEnd:foo");

        invManager.checkAndEnableHiddenImageForFlashLight(this);

        soundManager.PAGE_FLIP[1].play();
      }
      println("leftArrow clicked");
    } else if (closeButtonColliderEnabled == true && closeButton.isPointInside(mouseX, mouseY)) {
      closeButtonColliderEnabled = false;
      setEnabled(false);
    }
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
      endFadeAnim(animPageFade);
      page.alpha = lastPageAlpha;
      animPageFade = Ani.to(page, FADE_DURATION, 0, "alpha:255", Ani.CUBIC_OUT);
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
      endFadeAnim(animPageFade);
      page.alpha = lastPageAlpha;
      animPageFade = Ani.to(page, FADE_DURATION, 0, "alpha:0", Ani.CUBIC_OUT, this, "onEnd:disable");

      isDisabling = true;
    }

    closeButtonColliderEnabled = val;

    if (itemSoundEnabled == true)
      soundManager.PICKUP_PAGE[(val == true) ? 1 : 0].play();

    if (val == true) {
      invManager.checkAndEnableHiddenImageForFlashLight(this);
    }
  }

  private void disable() {
    enabled = false;
    pages.get(currentPageNumber).enabled = false;
    isDisabling = false;

    invManager.checkAndEnableHiddenImageForFlashLight(stateHandler.currentState);
  }

  private void disablePage() {
    pages.get(currentPageNumber).enabled = false;
  }

  public void foo() {
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

  UISprite getHiddenWordSprite(int wordIndex) {
    return hiddenWords.get(currentPageNumber).get(wordIndex);
  }

  void setEnabledCurrentPageHiddenWordsSprites(boolean val) {
    ArrayList<UISprite> sprites = hiddenWords.get(currentPageNumber);
    for (int i = 0; i < sprites.size(); i++) {
      sprites.get(i).enabled = val;
    }
  }

  void setEnabledPageHiddenWordsSprites(int pageNumber, boolean val) {
    ArrayList<UISprite> sprites = hiddenWords.getOrDefault(pageNumber, new ArrayList<UISprite>()); //ugly hahaha, tired of "ifs"
    for (int i = 0; i < sprites.size(); i++) {
      sprites.get(i).enabled = val;
    }
  }

  PImage getHiddenImage() {
    return hiddenImages.getOrDefault(currentPageNumber, null);
  }

  HiddenCollider[] getHiddenColliders() {
    return hiddenWordsColliders.get(currentPageNumber);
  }

  //Each hiddenCollider, after hit, is disable and a COUNTER (notes.hiddenWordsFound) is incremented
  //If reachs 15, unlocks the CAR_SCENE (actually unlocks the button that navigate to CAR_SCENE)

  //If hit a hiddenCollider in wordPage 5 (the final page, only avaiable inside the car) so triggers the Final
  //Before some actions allowMousePressed is set to false to lock all mousePressed input
  void hiddenColliderHit(HiddenCollider hc) {

    hc.enabled = false;

    int wordPage = Integer.parseInt(hc.name.split(" ")[1]); //the page is the second value in string, example "page 2 0"
    int wordIndex = Integer.parseInt(hc.name.split(" ")[2]); //the index is the third value in string, example "page 2 0"

    if (wordPage == 5) {
      //Final Page Goes To EndScene

      soundManager.LIMBO_SOUND.play();
      allowMousePressed = false;

      waiter.waitForSeconds(5, this, 3, this);
    } else {
      UISprite hiddenWordSprite = this.getHiddenWordSprite(wordIndex);
      hiddenWordSprite.enabled = true;

      this.hiddenWordsFound++;

      println("hiddenWordsFound", this.hiddenWordsFound);

      if (this.hiddenWordsFound >= this.MAX_WORDS_FOUND_TO_END) {

        //Unlock CAR
        GarageScene garage = (GarageScene)GARAGE_SCENE;
        garage.carPlaceEnabled = true;

        placeText.setFadeDuration(3);
        placeText.textBox.setText("I want to leave this house right now!\r\nI can't handle it anymore!");
        placeText.enabled = true;
        placeText.show();

        allowMousePressed = false; //lock player input mouse while playing messages

        waiter.waitForSeconds(3, this, 0, this);

        println("Car collider enabled");
      }
    }
  }

  void execute(int executeId, Object obj) {


    //Run to garage messages
    if (executeId == 0) {

      placeText.hide();
      waiter.waitForSeconds(0.5, this, 1, obj); //wait text fadeout
    } else if (executeId == 1) {

      if (stateHandler.currentState.name.equals("GarageScene") == false) {
        placeText.textBox.setText("I need to reach the garage right now!."); //<>// //<>//
        placeText.show();

        waiter.waitForSeconds(3, this, 2, obj); //wait text fadeout
      } else {
        placeText.disableAfterHide = true;
        placeText.hide();
        NotesUsableItem notes = (NotesUsableItem)obj;
        allowMousePressed = true;
      }
    } else if (executeId == 2) {
      placeText.disableAfterHide = true;
      placeText.hide();
      NotesUsableItem notes = (NotesUsableItem)obj;
      allowMousePressed = true;
    }

    //END Game Sequence
    else if (executeId == 3) {
      NotesUsableItem notes = (NotesUsableItem)obj;
      notes.itemSoundEnabled = false; //not play annoying sound when close
      notes.setEnabled(false);

      waiter.waitForSeconds(2, this, 4, notes);
    } else if (executeId == 4) {
      SceneWithTransition scene = (SceneWithTransition)stateHandler.currentState;
      invPanel.closepanel();
      scene.changeState(END_CREDIT_SCENE);
    }
  }
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

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

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

abstract class UsableItem {
  String name;
  boolean enabled = false;
  boolean allowSceneMousePressed = true;

  abstract void setEnabled(boolean val);
  abstract void step(float delta);
  void handleMousePressed() {
  }
}
