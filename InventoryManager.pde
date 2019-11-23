class InventoryManager implements IWaiter { //<>// //<>// //<>//

  final int MAX_QUANTITY = 4; 

  final float PICKUP_MOVING_DURATION = 0.2;

  HashMap<String, Integer> inventoryItems;
  InventoryItem[] items;

  final HashMap<String, Boolean> allowMultiples = new HashMap<String, Boolean>();

  ArrayList<UISprite> movingSprites;
  ArrayList<Ani[]> movingAnims;

  InventoryPanel inventoryPanel;

  InventoryManager(InventoryPanel pInventoryPanel) {

    allowMultiples.put("diary_item", true);
    allowMultiples.put("flashlight_item", false);
    allowMultiples.put("battery_item", false);

    inventoryPanel = pInventoryPanel;

    inventoryItems = new HashMap<String, Integer>();
    items = new InventoryItem[MAX_QUANTITY];

    movingSprites = new ArrayList<UISprite>();
    movingAnims = new ArrayList<Ani[]>();
  }

  void PickUpItem(String itemName, UISprite sprite) {

    boolean allow = allowMultiples.get(itemName);
    int freeSlot = -1;
    InventoryItem item = null;

    if (allow) {
      for (int i = 0; i < items.length; i++) {
        if (items[i] != null) {
          if (items[i].name == itemName) {
            freeSlot = i;
            items[i].quantity += 1;
            item = items[i];
          }
        }
      }
    } 

    if (freeSlot == -1) {
      for (int i = 0; i < items.length; i++) {
        if (items[i] == null) {
          freeSlot = i;
          break;
        }
      }
    }

    if (item == null) {
      item = new InventoryItem();
      item.name = itemName;
      item.multi = allow;
      item.quantity = 1;
      item.slot = freeSlot;
    }

    if (freeSlot > -1) {
      items[freeSlot] = item;

      movingSprites.add(sprite);

      float toX = inventoryPanel.x + freeSlot * 155 * widthRatio + 155 * widthRatio * 0.5;
      float toY = inventoryPanel.y + 179 * heightRatio * 0.5 - sprite.h * 0.5;
      Ani[] ani = Ani.to(sprite, PICKUP_MOVING_DURATION, 0, "x:" + toX + ", y:" + toY + ", alpha:0", Ani.QUAD_OUT, this, "onEnd:moveSpriteEnd");
      movingAnims.add(ani);

      waiter.waitForSeconds(PICKUP_MOVING_DURATION, this, 0, item);
    }
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      InventoryItem item = (InventoryItem)obj;
      inventoryPanel.addItem(item, item.slot);
    }
  }

  void display(float delta) {
    for (int i = 0; i < movingSprites.size(); i++) {
      movingSprites.get(i).display(delta);
    }
  }

  void moveSpriteEnd() {

    boolean isPlaying = false;

    for (int i = 0; i < movingAnims.size(); i++) {
      for (int j = 0; j < movingAnims.get(i).length; j++) {
        Ani ani = movingAnims.get(i)[j];
        if (ani.isPlaying() || ani.isDelaying()) {
          isPlaying = true;
          break;
        }
      }
      if (isPlaying == true) {
        break;
      }
    }

    if (isPlaying == false) {
      for (int i = 0; i < movingSprites.size(); i++) {
        movingSprites.get(i).enabled = false;
      }

      movingAnims.clear();
      movingSprites.clear();
    }
  }
}

class InventoryPanel {

  int x;
  int y;

  int openY = 899;
  int closeY = 1055;

  final float OPEN_CLOSE_ANIM_DURATION = 0.2;

  UISprite bgImage;

  boolean opened = false;

  InventoryPanelItem[] panelItems;

  PFont itemQuantityFont;
  final int TEXT_QUANTITY_FONT_SIZE = 22;

  InventoryPanel() {

    panelItems = new InventoryPanelItem[4];

    openY = round((900) * heightRatio);
    closeY = round(1055 * heightRatio);

    x = 0;
    y = closeY;

    bgImage = new UISprite(0, 0, "Inventory Layout Panel.png");
    bgImage.colliderW = round(140 * widthRatio);
    bgImage.colliderH = round(27 * heightRatio);

    itemQuantityFont = loadFont(MAIN_FONT_32);
  }

  void display(float delta) {
    pushMatrix();
    translate(x, y);
    bgImage.display(delta);

    for (int i = 0; i < panelItems.length; i++) {
      if (panelItems[i] == null)
        continue;

      InventoryPanelItem panelItem = panelItems[i];
      UISprite sprite = panelItem.sprite;

      float posX = 2 * widthRatio + i * sprite.w;
      float posY = 26 * heightRatio; 

      translate(posX, posY);
      panelItem.display(delta, x + posX, y + posY);
    }

    popMatrix();
  }

  void addItem(InventoryItem item, int slot) {
    InventoryPanelItem panelItem = new InventoryPanelItem(item, itemQuantityFont, TEXT_QUANTITY_FONT_SIZE);
    panelItems[slot] = panelItem;
  }

  void handleMousePressed() {
    if (isPointInsideEnableButton(mouseX, mouseY)) {
      if (opened == false) {
        opened = true;
        Ani.to(this, OPEN_CLOSE_ANIM_DURATION, 0, "y", openY, Ani.CUBIC_OUT);
      } else {
        opened = false;
        Ani.to(this, OPEN_CLOSE_ANIM_DURATION, 0, "y", closeY, Ani.CUBIC_OUT);
      }

      println("insd");
    }
  }

  boolean isPointInsideEnableButton( int px, int py ) {
    return isPointInRectangle( px, py, x, y, bgImage.colliderW, bgImage.colliderH);
  }

  boolean isPointInsidePanelItem( int px, int py, InventoryPanelItem panelItem ) {

    return isPointInRectangle( px, py, x, y, bgImage.colliderW, bgImage.colliderH);
  }
}

class InventoryItem {
  String name;
  boolean multi;
  int quantity;
  int slot;
}

class InventoryPanelItem {
  InventoryItem item;
  UISprite sprite;
  UISprite outlineSprite;

  Bounds bounds;

  Ani anim;

  PFont itemFont;
  int itemFontSize = 12;

  InventoryPanelItem(InventoryItem pItem, PFont pItemFont, int pItemFontSize) {
    item = pItem;
    item.quantity = 99;
    sprite = new UISprite(0, 0, item.name + ".png");
    outlineSprite = new UISprite(sprite.x, sprite.y, item.name + " outline.png");
    outlineSprite.alpha = 0;

    bounds = new Bounds(sprite.x, sprite.y, sprite.w, sprite.h, 20 * widthRatio, 20 * heightRatio, -20 * 2 * widthRatio, -20 * 2 * heightRatio);

    itemFont = pItemFont;
    itemFontSize = pItemFontSize;
  }

  void display(float delta, float panelX, float panelY) {
    bounds.updateBounds(panelX, panelY);

    outlineSprite.display(delta);
    sprite.display(delta);

    if (item.multi) {
      fill(255);
      textFont(itemFont, itemFontSize * heightRatio);
      textAlign(LEFT, CENTER);
      float textSize = textWidth(str(item.quantity));

      text(item.quantity, sprite.w - textSize - 4 * widthRatio, sprite.h - (itemFontSize + 4) * heightRatio);
    }

    if (bounds.isPointInside(mouseX, mouseY)) {
      if (outlineSprite.alpha <= 0 && (anim == null || anim.isPlaying() == false)) {
        if (anim != null) anim.end();
        anim = Ani.to(outlineSprite, 0.4, 0, "alpha", 255, Ani.CUBIC_OUT, this, "onUpdate:onUp");
        anim.start();
      }
    } else if (outlineSprite.alpha > 0 && (anim != null && anim.getEnd() == 255)) {
      anim.end();
      anim = Ani.to(outlineSprite, 0.4, 0, "alpha", 0, Ani.CUBIC_OUT, this, "onUpdate:onUp");
      anim.start();
    }

    //Debug Bounds
    popMatrix();
    fill(1, 1, 1, 30);
    noStroke();
    rect(bounds.x, bounds.y, bounds.w, bounds.h);
    pushMatrix();
  }

  void onUp() {
    //println("update outline", outlineSprite.alpha, frameCount);
  }
}

class Bounds {
  float x;
  float y;
  float w;
  float h;

  float offsetX;
  float offsetY;
  private float offsetW;
  private float offsetH;

  private float initialX;
  private float initialY;

  Bounds(float pX, float pY, float pW, float pH) {
    this(pX, pY, pW, pH, 0, 0, 0, 0);
  }

  Bounds(float pX, float pY, float pW, float pH, float pOffsetX, float pOffsetY, float pOffsetW, float pOffsetH) {
    x = pX + pOffsetX;
    y = pY + pOffsetY;
    w = pW + pOffsetW;
    h = pH + pOffsetH;

    initialX = x;
    initialY = y;

    offsetW = pOffsetW;
    offsetH = pOffsetH;
  }

  void updateBounds(float parentX, float parentY) {
    x = initialX + parentX + offsetX;
    y = initialY + parentY + offsetY;
  }

  void addOffsetWH(float pOffsetW, float pOffsetH) {
    offsetW = pOffsetW;
    offsetH = pOffsetH;

    w = w + offsetW;
    h = h + offsetH;
  }

  boolean isPointInside( int px, int py ) {
    return isPointInRectangle( px, py, x, y, w, h);
  }
}
