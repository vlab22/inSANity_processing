// ============ VARIABLES ============ //<>// //<>//

boolean playerHasFlashLight = false;
boolean playerHasBatteries = false;

//Fonts
String MAIN_FONT_32 = "Gaiatype-32.vlw";
String MAIN_FONT_12 = "Gaiatype-12.vlw";

//Global Reference to PApplet to be used inside classes
PApplet thisApplet = this; 

//Waiter, class to wait for a amount of seconds
Waiter waiter;

//Inventory
InventoryPanel invPanel;
InventoryManager invManager;

//Usable Items
UsableItemManager usableItemManager;

// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler = new StateHandler( "inSANity Game" );

State FRONTHOUSE_SCENE; 
State FRONTDOOR_SCENE;
State GROUND_HALLWAY_SCENE; 
State FOREST_SCENE; 
State LIVINGROOM_SCENE;
State LIVINGROOM_CHIMNEY_SCENE;
State HALLWAY2_ATTIC_SCENE;
State SAM_BEDROOM_SCENE;

State TEST_SCENE;

float widthRatio = 1;
float heightRatio = 1;

void setup() {

  //fullScreen(P2D);
  //size( 1920, 1280, P2D );
  size( 1280, 720, P2D );
  noStroke();

  widthRatio = width / 1920.0;
  heightRatio = height / 1080.0;

  Ani.init(this);

  waiter = new Waiter();

  playerHasFlashLight = false;
  playerHasBatteries = false;

  FRONTHOUSE_SCENE = new  FrontHouseScene();
  FRONTDOOR_SCENE = new   FrontDoorScene();
  GROUND_HALLWAY_SCENE = new  GroundHallwayScene();
  LIVINGROOM_SCENE = new LivingRoomScene();
  LIVINGROOM_CHIMNEY_SCENE = new LivingRoomFireplaceScene();
  HALLWAY2_ATTIC_SCENE = new Hallway2AtticScene();
  SAM_BEDROOM_SCENE = new SamBedRoomScene();
  TEST_SCENE = new TestScene();

  //stateHandler.changeStateTo( FRONTHOUSE_SCENE );
  stateHandler.changeStateTo( LIVINGROOM_SCENE );

  invPanel = new InventoryPanel();
  invManager = new InventoryManager(invPanel);
  
  usableItemManager = new UsableItemManager();
}


void draw() {
  float delta = 1 / frameRate;

  stateHandler.executeCurrentStateStep(delta);

  //usableItemManager.step(delta);

  invManager.display(delta);

  waiter.step(delta);

  surface.setTitle(mouseX + ", " + mouseY);
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
    frameCount = -1;
  }
}

void keyTyped() { 
  stateHandler.handleKeyTyped();
}

void mousePressed() { 
  invPanel.handleMousePressed();
  stateHandler.handleMousePressed();
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
