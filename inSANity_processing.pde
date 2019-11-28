// ============ VARIABLES ============ //<>// //<>// //<>// //<>// //<>// //<>// //<>//

//Fonts
String MAIN_FONT_32 = "Gaiatype-32.vlw";
String MAIN_FONT_12 = "Gaiatype-12.vlw";

//Global Reference to PApplet to be used inside classes
PApplet thisApplet = this; 

//Waiter, class to wait for a amount of seconds and than run a method after it
Waiter waiter;

//Inventory
InventoryPanel invPanel;
InventoryManager invManager;

//Usable Items
UsableItemManager usableItemManager;

//SoundManager
SoundManager soundManager;

// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler = new StateHandler( "inSANity Game" );

State FRONTHOUSE_SCENE; 
State FRONTDOOR_SCENE;
State GROUND_HALLWAY_SCENE; 
State GARAGE_SCENE; 
State GARAGE_SHELF_SCENE;
State LIVINGROOM_SCENE;
State LIVINGROOM_CHIMNEY_SCENE;
State HALLWAY2_ATTIC_SCENE;
State SAM_BEDROOM_SCENE;
State SAM_BEDROOM_MIRROR_SCENE;
State ATTIC_SCENE;
State CAR_INSIDE_SCENE;
State END_CREDIT_SCENE;

State TEST_SCENE;

// =============== INPUTS =============

boolean allowMousePressed = true;

// ==========

float widthRatio = 1;
float heightRatio = 1;

// ========== DEBUG ============

boolean resetedByPlayer = false;
boolean DEBUG = true;

void setup() {

  //fullScreen(P2D);
  //size( 1920, 1280, P2D );
  size( 1280, 720, P2D );
  noStroke();

  widthRatio = width / 1920.0;
  heightRatio = height / 1080.0;

  allowMousePressed = true;

  Ani.init(this);

  waiter = new Waiter();

  soundManager = new SoundManager();

  FRONTHOUSE_SCENE = new  FrontHouseScene();
  FRONTDOOR_SCENE = new   FrontDoorScene();
  GROUND_HALLWAY_SCENE = new  GroundHallwayScene();
  GARAGE_SCENE = new GarageScene();
  GARAGE_SHELF_SCENE = new GarageShelfScene();
  LIVINGROOM_SCENE = new LivingRoomScene();
  LIVINGROOM_CHIMNEY_SCENE = new LivingRoomFireplaceScene();
  HALLWAY2_ATTIC_SCENE = new Hallway2AtticScene();
  SAM_BEDROOM_SCENE = new SamBedRoomScene();
  SAM_BEDROOM_MIRROR_SCENE = new SamBedRoomMirrorScene();
  ATTIC_SCENE = new AtticScene();
  CAR_INSIDE_SCENE = new CarInsideScene();
  END_CREDIT_SCENE = new EndCreditScene();

  TEST_SCENE = new TestScene();

  invPanel = new InventoryPanel();
  invManager = new InventoryManager(invPanel);

  usableItemManager = new UsableItemManager();

  if (resetedByPlayer || DEBUG == false) {
    //The first Scene
    stateHandler.changeStateTo( FRONTHOUSE_SCENE );
  } else {
    //Scene to DEBUG
    stateHandler.changeStateTo( HALLWAY2_ATTIC_SCENE );
  }
  if (resetedByPlayer == false && DEBUG == true) {
    //DEBUG, God mode
    invManager.PickUpItem("notes_item", new Object[] {         
      "notes_item page 4", 
      "notes_item page 3", 
      "notes_item page 2", 
      "notes_item page 1"  }, null);
    invManager.PickUpItem("flashlight_item", new Object[] { "flashlight_item item 0" }, null);
    invManager.PickUpItem("batteries_item", new Object[] { "batteries_item item 0" }, null);

    ((Hallway2AtticScene)HALLWAY2_ATTIC_SCENE).atticStairsOpen = true;
  }
}


void draw() {
  float delta = 1 / frameRate;

  stateHandler.executeCurrentStateStep(delta);

  //usableItemManager.step(delta);

  invManager.display(delta);

  waiter.step(delta);

  surface.setTitle(mouseX + ", " + mouseY);

  //println("-------------");
  //for (int i = 0; i < soundManager.sounds.length; i++) {
  //  println(i, soundManager.sounds[i].player.isPlaying());
  //}

  fill(255, 255, 0);
  textAlign(LEFT);
  textSize(16);
  text("Fps: " + frameRate, 35, 35);
}


// ============ EVENT HANDLERS ============

// only put stuff in here that is valid for all states
// otherwise use the handleKeyPressed in the state itself

void keyPressed() {
  stateHandler.handleKeyPressed();
}


void keyReleased() {
  stateHandler.handleKeyReleased();

  if (key == 'r') {
    //Hard reset
    frameCount = -1;
    resetedByPlayer = true;
  }
  if (key == 't') {
    frameCount = -1;
  }
  if (key == 'd') {
    println("======================");
    println("======================");
    println("Usables");
    for (Map.Entry<String, UsableItem> entry : usableItemManager.usablesMap.entrySet()) {
      println(entry.getKey(), entry.getValue().name);
    }

    println("======================");
    println("Inv Items itemsMap");
    for (Map.Entry<String, InventoryItem> entry : invManager.itemsMap.entrySet()) {
      println(entry.getKey(), entry.getValue().name);
    }

    println("======================");
    println("Inv Items items");
    for (int i = 0; i < invManager.items.size(); i++) {
      InventoryItem item = invManager.items.get(i);
      println(( item != null ? item.name : null));
    }
  }
}

void keyTyped() { 
  stateHandler.handleKeyTyped();
}

void mousePressed() { 
  if (allowMousePressed == true) {
    invPanel.handleMousePressed();
    usableItemManager.handleMousePressed();
    stateHandler.handleMousePressed();
  }
}
void mouseClicked() { 
  stateHandler.handleMouseClicked();
}
void mouseReleased() { 
  stateHandler.handleMouseReleased();
}
void mouseDragged() { 
  stateHandler.handleMouseDragged();
}
void mouseMoved() { 
  stateHandler.handleMouseMoved();
}

void mouseWheel(MouseEvent event) { 
  stateHandler.handleMouseWheel( event );
}
