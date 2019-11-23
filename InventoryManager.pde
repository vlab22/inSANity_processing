class InventoryManager implements IWaiter { //<>//

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

      if (panelItem.item.multi) {
        textFont(itemQuantityFont, TEXT_QUANTITY_FONT_SIZE * heightRatio);
        textAlign(CENTER, CENTER);
        float textSize = textWidth(str(panelItem.item.quantity));

        text(panelItem.item.quantity, sprite.w - textSize - 4 * widthRatio, sprite.h - (TEXT_QUANTITY_FONT_SIZE + 4) * heightRatio);
      }
    }

    popMatrix();
  }

  void addItem(InventoryItem item, int slot) {
    InventoryPanelItem panelItem = new InventoryPanelItem(item);
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

  InventoryPanelItem(InventoryItem pItem) {
    int slot = pItem.slot;
    item = pItem;
    sprite = new UISprite(0, 0, item.name + ".png");
    outlineSprite = new UISprite(sprite.x, sprite.y, item.name + " outline.png");
    bounds = new Bounds(sprite.x, sprite.y, sprite.w, sprite.h);
  }

  void display(float delta, float panelX, float panelY) {
    bounds.updateBounds(panelX, panelY);
    sprite.display(delta);

    popMatrix();
    rect(bounds.x, bounds.y, bounds.w, bounds.h);
    pushMatrix();
    
    if (bounds.isPointInside(mouseX, mouseY)) {
      
    }
  }
}

class Bounds {
  float x;
  float y;
  float w;
  float h;

  Bounds(float pX, float pY, float pW, float pH) {
    x = pX;
    y = pY;
    w = pW;
    h = pH;
  }

  void updateBounds(float parentX, float parentY) {
    x = parentX;
    y = parentY;
  }

  boolean isPointInside( int px, int py ) {
    return isPointInRectangle( px, py, x, y, w, h);
  }
}