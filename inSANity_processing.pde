// ========== DEBUG ============ //<>// //<>// //<>//

boolean resetedByPlayer = false;
boolean DEBUG = false;

// ============ VARIABLES ============ //<>// //<>// //<>// //<>// //<>// //<>//

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

//TextBoxManager
TextBoxManager textManager;

// ============ STATE HANDLER AND STATES ============
StateHandler stateHandler = new StateHandler( "inSANity Game" );

State MAINMENU_SCENE;
State FRONTHOUSE_SCENE; 
State FRONTDOOR_SCENE;
State GROUND_HALLWAY_SCENE; 
State GARAGE_SCENE; 
State GARAGE_SHELF_SCENE;
State LIVINGROOM_SCENE;
State LIVINGROOM_CHIMNEY_SCENE;
State LIVINGROOM_CHIMNEY_PHOTOS_SCENE;
State HALLWAY2_ATTIC_SCENE;
State SAM_BEDROOM_SCENE;
State SAM_BEDROOM_MIRROR_SCENE;
State SAM_BEDROOM_PAINTING_SCENE;
State ATTIC_SCENE;
State CAR_INSIDE_SCENE;
State END_CREDIT_SCENE;

State TEST_SCENE;

// =============== INPUTS =============

boolean allowMousePressed = true;

// ==========

float widthRatio = 1;
float heightRatio = 1;

void setup() {

  fullScreen(P2D);
  //size( 1920, 1280, P2D );
  //size( 1280, 720, P2D );
  noStroke();

  widthRatio = width / 1920.0;
  heightRatio = height / 1080.0;

  allowMousePressed = true;

  Ani.init(this);

  waiter = new Waiter();

  soundManager = new SoundManager();

  MAINMENU_SCENE = new MainMenuScene();
  FRONTHOUSE_SCENE = new  FrontHouseScene();
  FRONTDOOR_SCENE = new   FrontDoorScene();
  GROUND_HALLWAY_SCENE = new  GroundHallwayScene();
  GARAGE_SCENE = new GarageScene();
  GARAGE_SHELF_SCENE = new GarageShelfScene();
  LIVINGROOM_SCENE = new LivingRoomScene();
  LIVINGROOM_CHIMNEY_SCENE = new LivingRoomFireplaceScene();
  LIVINGROOM_CHIMNEY_PHOTOS_SCENE = new LivingRoomFireplaceZoomScene();
  HALLWAY2_ATTIC_SCENE = new Hallway2AtticScene();
  SAM_BEDROOM_SCENE = new SamBedRoomScene();
  SAM_BEDROOM_MIRROR_SCENE = new SamBedRoomMirrorScene();
  SAM_BEDROOM_PAINTING_SCENE = new SamBedRoomPaintingScene();
  ATTIC_SCENE = new AtticScene();
  CAR_INSIDE_SCENE = new CarInsideScene();
  END_CREDIT_SCENE = new EndCreditScene();

  TEST_SCENE = new TestScene();

  invPanel = new InventoryPanel();
  invManager = new InventoryManager(invPanel);

  usableItemManager = new UsableItemManager();

  textManager = new TextBoxManager();

  if (resetedByPlayer || DEBUG == false) {
    //The first Scene
    stateHandler.changeStateTo( MAINMENU_SCENE );
  } else {
    //Scene to DEBUG
    stateHandler.changeStateTo( GROUND_HALLWAY_SCENE );
  }
  if (resetedByPlayer == false && DEBUG == true) {
    //DEBUG, God mode
    invManager.PickUpItem("notes_item", new Object[] {         
      //"notes_item page 4", 
      //"notes_item page 3", 
      //"notes_item page 2", 
      "notes_item page 1"  }, null);
    invManager.PickUpItem("flashlight_item", new Object[] { "flashlight_item item 0" }, null);
    invManager.PickUpItem("batteries_item", new Object[] { "batteries_item item 0" }, null);
    invManager.PickUpItem("garage_key_item", new String[] { "garage_key item 0" }, null);

    ((Hallway2AtticScene)HALLWAY2_ATTIC_SCENE).atticStairsOpen = true;
  }
}


void draw() {
  float delta = 1 / frameRate;

  stateHandler.executeCurrentStateStep(delta);

  //usableItemManager.step(delta);

  invManager.display(delta);

  waiter.step(delta);

  //println("LIVINGROOM_MUSIC.isPlaying", soundManager.LIVINGROOM_MUSIC.player.isPlaying(), "amp", soundManager.LIVINGROOM_MUSIC.amp, "wait", (soundManager.LIVINGROOM_MUSIC.anim != null) ? map(soundManager.LIVINGROOM_MUSIC.amp, 0, 1, 0, soundManager.LIVINGROOM_MUSIC.FADEOUT_DURATION) : "null");

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

  if (DEBUG) {
    if (key == 't') {
      frameCount = -1;
    }

    if (key == 'y') {
      textManager.showText("Random: " + random(0, 10), 2);
    }

    if (key == '1') {
      invManager.PickUpItem("notes_item", new Object[] {         
        "notes_item page 1"  }, null);
    }

    if (key == '2') {
      invManager.PickUpItem("notes_item", new Object[] {         
        "notes_item page 2"  }, null);
    }

    if (key == '3') {
      invManager.PickUpItem("notes_item", new Object[] {         
        "notes_item page 3"  }, null);
    }

    if (key == '4') {
      invManager.PickUpItem("notes_item", new Object[] {         
        "notes_item page 4"  }, null); //<>//
    }

    if (key == '5') {
      invManager.PickUpItem("notes_item", new Object[] {         
        "notes_item page 5"  }, null);
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

class MainMenuScene extends SceneWithTransition {
  ImageButton startButton = new ImageButton( null, round(1308 * widthRatio), round(469 * heightRatio), "title screen_Start start overlay.png" );

  PImage startLight;

  float startLightAlpha = 0;
  Ani blink;

  MainMenuScene() {
    super("title screen_black.png");

    background = loadImage( filename );
    startLight = loadImage("title screen_Start.png");
  }

  void enterState(State oldState) {
    super.enterState(oldState);

    float delay = timeSinceStartInSeconds();

    blink = Ani.to(this, 1, 0.6, "startLightAlpha", 255, Ani.QUAD_IN);


    println(this.getName(), "entertate", frameCount, "delay", delay);
  }

  public void doStepWhileInState(float delta)
  {
    super.doStepWhileInState(delta);

    println(this.getName(), "doStep", frameCount, millis());

    if (frameCount == 4)
      blink.start();

    pushStyle();
    tint(255, startLightAlpha);
    image(startLight, 0, 0, startLight.width * widthRatio, startLight.height * heightRatio);
    popStyle();

    startButton.display();

    this.TransitionDisplay(delta);
  }

  void handleMousePressed() {
    if ( startButton.isPointInside( mouseX, mouseY ) ) {
      changeState( FRONTHOUSE_SCENE );
    }
  }


  void TransitionDisplay(float delta) {

    //usableItemManager.step(delta);

    //invPanel.display(delta);

    //textManager.display(delta);

    if (sceneLeaveTransition.enabled == true) {
      sceneLeaveTransition.display();
    } else if (sceneEnterTransition.enabled == true) {
      sceneEnterTransition.display();
    }
  }

  void changeState(State state) {
    stateHandler.changeStateTo( state );
  }
}
