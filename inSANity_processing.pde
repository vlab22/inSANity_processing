// ============ VARIABLES ============

boolean isAppleTaken = false;



// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler;

final State  RIVER_SCENE = new  RiverScene();
final State   LAWN_SCENE = new   LawnScene();
final State  TABLE_SCENE = new  TableScene();
final State FOREST_SCENE = new ForestScene();


void setup() {
    size( 800, 800 );
    noStroke();
    stateHandler = new StateHandler( "Example game" );
    stateHandler.changeStateTo( RIVER_SCENE );
}


void draw() {
    stateHandler.executeCurrentStateStep();
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

void keyTyped()      { stateHandler.handleKeyTyped();      }

void mousePressed()  { stateHandler.handleMousePressed();  } //<>//
void mouseClicked()  { stateHandler.handleMouseClicked();  }
void mouseReleased() { stateHandler.handleMouseReleased(); }
void mouseDragged()  { stateHandler.handleMouseDragged();  }
void mouseMoved()    { stateHandler.handleMouseMoved();    }

void mouseWheel(MouseEvent event) { stateHandler.handleMouseWheel( event ); }
