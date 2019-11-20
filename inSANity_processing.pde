// ============ VARIABLES ============ //<>//

boolean isAppleTaken = false;



// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler = new StateHandler( "Example game" );

State  FRONTHOUSE_SCENE; 
State   FRONTDOOR_SCENE;
State  GROUND_HALLWAY_SCENE; 
State FOREST_SCENE; 

float widthRatio;
float heightRatio;

void setup() {

  //fullScreen(P2D);
  size( 1280, 720, P2D );
  noStroke();

  widthRatio = 1280.0 / 1920;
  heightRatio = 720.0 / 1080;

  Ani.init(this);

  FRONTHOUSE_SCENE = new  FrontHouseScene();
  FRONTDOOR_SCENE = new   FrontDoorScene();
  GROUND_HALLWAY_SCENE = new  GroundHallwayScene();
  FOREST_SCENE = new ForestScene();

  stateHandler.changeStateTo( FRONTHOUSE_SCENE );
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
