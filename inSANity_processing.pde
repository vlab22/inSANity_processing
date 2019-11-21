// ============ VARIABLES ============ //<>//

boolean isAppleTaken = false;

//Global Reference to PApplet to be used inside classes
PApplet thisApplet = this; 

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

  FRONTHOUSE_SCENE = new  FrontHouseScene();
  FRONTDOOR_SCENE = new   FrontDoorScene();
  GROUND_HALLWAY_SCENE = new  GroundHallwayScene();
  FOREST_SCENE = new ForestScene();
  LIVINGROOM_SCENE = new LivingRoomScene();
  LIVINGROOM_CHIMNEY_SCENE = new LivingRoomChimneyScene();
  HALLWAY2_ATTIC_SCENE = new Hallway2AtticScene();
  SAM_BEDROOM_SCENE = new SamBedRoomScene();
  TEST_SCENE = new TestScene();

  //stateHandler.changeStateTo( FRONTHOUSE_SCENE );
  stateHandler.changeStateTo( GROUND_HALLWAY_SCENE );
}


void draw() {
  float delta = 1 / frameRate;
  stateHandler.executeCurrentStateStep(delta);

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
}

void keyTyped() { 
  stateHandler.handleKeyTyped();
}

void mousePressed() { 
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
