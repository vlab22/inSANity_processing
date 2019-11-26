import java.util.Arrays; //<>// //<>// //<>// //<>// //<>//

enum ItemCategory {
  TOOL, 
    NOTE,
}

class InventoryManager implements IWaiter { 

  final int MAX_QUANTITY = 4; 

  final float PICKUP_MOVING_DURATION = 0.2;

  HashMap<String, InventoryItem> itemsMap;
  ArrayList<InventoryItem> items;

  final HashMap<String, ItemCategory> itemsCategories = new HashMap<String, ItemCategory>();
  final HashMap<String, Boolean> allowMultiples = new HashMap<String, Boolean>();
  final HashMap<String, String> itemsDisplayNames = new HashMap<String, String>();

  ArrayList<UISprite> movingSprites;
  ArrayList<Ani[]> movingAnims;

  InventoryPanel inventoryPanel;

  InventoryManager(InventoryPanel pInventoryPanel) {

    allowMultiples.put("notes_item", true);
    allowMultiples.put("flashlight_item", false);
    allowMultiples.put("flashlight_batteries_item", false);
    allowMultiples.put("batteries_item", false);

    itemsDisplayNames.put("notes_item", "Old Notes");
    itemsDisplayNames.put("flashlight_item", "Flash/Black Light");
    itemsDisplayNames.put("flashlight_batteries_item", "Flash/Black Light");
    itemsDisplayNames.put("batteries_item", "Batteries");

    itemsCategories.put("notes_item", ItemCategory.NOTE);
    itemsCategories.put("flashlight_item", ItemCategory.TOOL);
    itemsCategories.put("flashlight_batteries_item", ItemCategory.TOOL);
    itemsCategories.put("batteries_item", ItemCategory.TOOL);

    inventoryPanel = pInventoryPanel;

    itemsMap = new HashMap<String, InventoryItem>();
    items = new ArrayList<InventoryItem>(MAX_QUANTITY);

    movingSprites = new ArrayList<UISprite>();
    movingAnims = new ArrayList<Ani[]>();
  }

  void PickUpItem(String itemName, Object[] objs, UISprite sprite) {

    boolean allow = allowMultiples.get(itemName);
    int freeSlot = -1;
    InventoryItem item = null;

    if (allow) {
      for (int i = 0; i < items.size(); i++) {
        if (items.get(i) != null) {
          if (items.get(i).name == itemName) {
            item = items.get(i);
            freeSlot = i;
            item.quantity += objs.length;
            item.slot = freeSlot;
            item.objs.addAll(Arrays.asList(objs));
          }
        }
      }
    }

    if (freeSlot == -1) {
      freeSlot = (items.size() < MAX_QUANTITY) ? items.size() : -1;
    }

    if (item == null && freeSlot > -1) {
      item = new InventoryItem();
      item.name = itemName;
      item.displayName = itemsDisplayNames.get(itemName);
      item.multi = allow;
      item.quantity += (objs.length == 0) ? 1 : objs.length;
      item.slot = freeSlot;
      item.category = itemsCategories.get(itemName);
      item.objs.addAll(Arrays.asList(objs));

      itemsMap.put(item.name, item);
      items.add(freeSlot, item);
    }

    if (freeSlot > -1) {

      boolean lastOpened = inventoryPanel.opened;
      if (inventoryPanel.opened == false) {
        inventoryPanel.openPanel();
      }

      if (sprite != null) {
        movingSprites.add(sprite);
        float toX = inventoryPanel.x + freeSlot * 155 * widthRatio + 155 * widthRatio * 0.5;
        float toY = inventoryPanel.y + 179 * heightRatio * 0.5 - sprite.h * 0.5;
        Ani[] ani = Ani.to(sprite, PICKUP_MOVING_DURATION, lastOpened ? 0 : inventoryPanel.OPEN_CLOSE_ANIM_DURATION, "x:" + toX + ", y:" + toY + ", alpha:0", Ani.QUAD_OUT, this, "onEnd:moveSpriteEnd");
        movingAnims.add(ani);
      }

      //Play pickup sound
      soundManager.playPickUpItem(item.name);

      waiter.waitForSeconds(PICKUP_MOVING_DURATION, this, 0, item);
    }
  }

  void joinItems(String item1name, String item2name) {
    //Get Slot of item1
    InventoryItem item1 = findItemByName(item1name);
    InventoryItem item2 = findItemByName(item2name);

    //Anim item1 to item2
    InventoryPanelItem panelItem1 = inventoryPanel.panelItems[item1.slot];
    InventoryPanelItem panelItem2 = inventoryPanel.panelItems[item2.slot];
    UISprite item1Sprite = panelItem1.sprite;

    float toPosX = 2 * widthRatio + (item2.slot - item1.slot) * item1Sprite.w;

    println(toPosX, item2.slot);

    panelItem1.collisionEnabled = false;
    panelItem2.collisionEnabled = false;

    Ani.to(item1Sprite, 0.8, 0, "x:" + toPosX + ", alpha:0", Ani.QUAD_OUT);

    waiter.waitForSeconds(1, this, 1, new InventoryItem[]{item1, item2});
  }

  void execute(int executeId, Object obj) {
    if (executeId == 0) {
      InventoryItem item = (InventoryItem)obj;
      inventoryPanel.addItem(item, item.slot);
    } else if (executeId == 1) {
      //Join items

      InventoryItem item1 = ((InventoryItem[])obj)[0];
      InventoryItem item2 = ((InventoryItem[])obj)[1];

      //Battery with flashlight
      if (item1.name == "batteries_item" && item2.name == "flashlight_item") {
        String itemName = "flashlight_batteries_item";

        InventoryItem item = new InventoryItem();
        item.name = itemName;
        item.displayName = itemsDisplayNames.get(itemName);
        item.multi = false;
        item.quantity = 1;
        item.slot = item2.slot;
        item.category = itemsCategories.get(itemName);
        item.onOffState = true;
        item.objs.addAll(Arrays.asList(new String[]{"flashlight_batteries_item item 0"}));

        inventoryPanel.panelItems[item1.slot] = null;
        inventoryPanel.panelItems[item2.slot] = null;

        items.add(item.slot, item);

        items.set(item1.slot, null);
        items.set(item2.slot, null);

        itemsMap.remove(item1.name);
        itemsMap.remove(item2.name);
        itemsMap.put(item.name, item);

        inventoryPanel.addItem(item, item.slot);

        usableItemManager.createItem(item.name, item.objs);
      }

      println(item1.name, item2.name);
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

  public void tryInstallBatteries() {
    if (findItemByName("flashlight_item") != null) {
      //Has flashlight in inventory
      joinItems("batteries_item", "flashlight_item");
      soundManager.INSERT_BATTERIES_SOUND.play(); //<>//
    }
  }

  public InventoryItem findItemByName(String itemName) {
    return itemsMap.getOrDefault(itemName, null);
  }

  void checkAndEnableHiddenImageForFlashLight(Object obj) {
    //try {
    if (findItemByName("flashlight_batteries_item") != null) {

      FlashLightUsableItem flash = (FlashLightUsableItem)usableItemManager.usablesMap.get("flashlight_batteries_item");

      if (obj instanceof IHasHiddenLayer) {
        IHasHiddenLayer ihl = ((IHasHiddenLayer)obj);
        PImage hiddenImage = ihl.getHiddenImage();
        flash.hiddenImage = hiddenImage;
        flash.hiddenColliders = ihl.getHiddenColliders();
      } else {
        flash.hiddenImage = null;
        flash.hiddenColliders = new HiddenCollider[0];
      }
    }
    //}
    //catch (Exception e) {
    //  println("exception at checkAndEnableHiddenImageForFlashLight");
    //  e.printStackTrace();
    //}
  }
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

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

      pushMatrix();
      InventoryPanelItem panelItem = panelItems[i];
      UISprite sprite = panelItem.sprite;

      float posX = 2 * widthRatio + i * sprite.w;
      float posY = 26 * heightRatio; 

      translate(posX, posY);
      panelItem.display(delta, x + posX, y + posY);
      popMatrix();
    }

    popMatrix();
  }

  void addItem(InventoryItem item, int slot) {
    InventoryPanelItem panelItem;
    if (item.onOffState) {
      panelItem = new InventoryPanelItemWithOnOffState(item, itemQuantityFont, TEXT_QUANTITY_FONT_SIZE);
    } else {
      panelItem = new InventoryPanelItem(item, itemQuantityFont, TEXT_QUANTITY_FONT_SIZE);
    }
    panelItems[slot] = panelItem;
  }

  void handleMousePressed() {
    if (isPointInsideEnableButton(mouseX, mouseY)) {
      if (opened == false) {
        openPanel();
      } else {
        closepanel();
      }
    }

    //Handle inventory item clicked ================================ 

    for (int i = 0; i < panelItems.length; i++) {
      if (panelItems[i] == null)
        continue;

      InventoryPanelItem panelItem = panelItems[i];
      if (panelItem.collisionEnabled && panelItem.bounds.isPointInside(mouseX, mouseY)) {

        //Create/Enable Inv Item
        usableItemManager.enableUsableItem(panelItem.item.name, panelItem.item.objs);

        if (panelItem instanceof InventoryPanelItemWithOnOffState) {
          InventoryPanelItemWithOnOffState panelItemOnOff = (InventoryPanelItemWithOnOffState)panelItem;
          panelItemOnOff.on = !panelItemOnOff.on;
        }

        println("invitem", panelItem.item.name, "clicked");
        break;
      }
    }
  }

  void openPanel() {
    opened = true;
    Ani.to(this, OPEN_CLOSE_ANIM_DURATION, 0, "y", openY, Ani.CUBIC_OUT);
  }

  void closepanel() {
    opened = false;
    Ani.to(this, OPEN_CLOSE_ANIM_DURATION, 0, "y", closeY, Ani.CUBIC_OUT);
  }

  boolean isPointInsideEnableButton( int px, int py ) {
    return isPointInRectangle( px, py, x, y, bgImage.colliderW, bgImage.colliderH);
  }
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

class InventoryItem {
  String name;
  String displayName;
  boolean multi;
  int quantity;
  int slot;
  ItemCategory category;

  boolean onOffState = false;

  ArrayList<Object> objs = new ArrayList<Object>();
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

class InventoryPanelItem {
  InventoryItem item;
  UISprite sprite;
  UISprite outlineSprite;

  Bounds bounds;

  Ani anim;

  PFont itemFont;
  int itemFontSize = 12;

  boolean collisionEnabled = true;

  InventoryPanelItem(InventoryItem pItem, PFont pItemFont, int pItemFontSize) {
    item = pItem;
    sprite = new UISprite(0, 0, item.name + ".png");
    outlineSprite = new UISprite(sprite.x, sprite.y, item.name + " outline.png");
    outlineSprite.alpha = 0;

    bounds = new Bounds(sprite.x, sprite.y, sprite.w, sprite.h, 20 * widthRatio, 20 * heightRatio, -20 * 2 * widthRatio, -20 * 2 * heightRatio);

    itemFont = pItemFont;
    itemFontSize = pItemFontSize;
  }

  void display(float delta, float panelX, float panelY) {
    bounds.updateBounds(sprite.x + panelX, sprite.y + panelY);

    outlineSprite.display(delta);
    sprite.display(delta);

    if (item.multi) {
      fill(255);
      textFont(itemFont, itemFontSize * heightRatio);
      textAlign(LEFT, CENTER);
      float textSize = textWidth(str(item.quantity));

      text(item.quantity, sprite.w - textSize - 4 * widthRatio, sprite.h - (itemFontSize + 4) * heightRatio);
    }

    if (collisionEnabled && bounds.isPointInside(mouseX, mouseY)) {
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
    //popMatrix();
    fill(1, 1, 1, 100);
    noStroke();
    rect(bounds.x, bounds.y, bounds.w, bounds.h);
    //pushMatrix();
  }

  void onUp() {
    //println("update outline", outlineSprite.alpha, frameCount);
  }
}

class InventoryPanelItemWithOnOffState extends InventoryPanelItem {

  UISprite onSprite;
  boolean on = false;

  InventoryPanelItemWithOnOffState(InventoryItem pItem, PFont pItemFont, int pItemFontSize) {
    super(pItem, pItemFont, pItemFontSize);

    onSprite = new UISprite(0, 0, item.name + " on.png");
  }

  void display(float delta, float panelX, float panelY) {
    bounds.updateBounds(sprite.x + panelX, sprite.y + panelY);

    outlineSprite.display(delta);

    if (on) {
      onSprite.display(delta);
    } else {
      sprite.display(delta);
    }

    if (item.multi) {
      fill(255);
      textFont(itemFont, itemFontSize * heightRatio);
      textAlign(LEFT, CENTER);
      float textSize = textWidth(str(item.quantity));

      text(item.quantity, sprite.w - textSize - 4 * widthRatio, sprite.h - (itemFontSize + 4) * heightRatio);
    }

    if (collisionEnabled && bounds.isPointInside(mouseX, mouseY)) {
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
    //popMatrix();
    fill(1, 1, 1, 100);
    noStroke();
    rect(bounds.x, bounds.y, bounds.w, bounds.h);
    //pushMatrix();
  }
}

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

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

interface IAction {
  void execute(Object obj);
}
