// ============ VARIABLES ============ //<>//

boolean isAppleTaken = false;



// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler = new StateHandler( "Example game" );
;

State  RIVER_SCENE; 
State   LAWN_SCENE;
State  TABLE_SCENE; 
State FOREST_SCENE; 

void setup() {
  size( 800, 800, P2D );
  noStroke();

  Ani.init(this);

  RIVER_SCENE = new  RiverScene();
  LAWN_SCENE = new   LawnScene();
  TABLE_SCENE = new  TableScene();
  FOREST_SCENE = new ForestScene();

  stateHandler.changeStateTo( RIVER_SCENE );
}


void draw() {
  float delta = 1 / frameRate;
  stateHandler.executeCurrentStateStep(delta);
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
