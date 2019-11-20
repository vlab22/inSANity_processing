// ============ State template classes ============

// Do not change anything here unless you know what
// you are doing!
//
// check for usage tabs with a State at the end


class State
{
    private String name;

    protected State( String stateName )
    {
        name = stateName;
        println( "new State() : " + name );
    }


    protected State()
    {
        String className = this.getClass().getSimpleName();
        name = className;
        println( "new State() : " + name );
   }


    String getName() { return name; }

    public void enterState( State oldState ) {}    
    public void doStepWhileInState()         {} 
    public void leaveState( State newState ) {} 

    public void handleMousePressed()  {} //<>//
    public void handleMouseClicked()  {}
    public void handleMouseReleased() {}
    public void handleMouseDragged()  {}
    public void handleMouseMoved()    {}

    public void handleMouseWheel( MouseEvent mouseEvent ) {}

    public void handleKeyTyped()    {}
    public void handleKeyPressed()  {}
    public void handleKeyReleased() {}

}


// ============ Embedded State ============

// if you want to embed a program with everything
// within a single class, this makes it easy peasy
// you still can use enterState end leaveState

class EmbeddedState extends State {
    EmbeddedState( String stateName )
    {
        super( stateName );
        setup();
    }

    protected EmbeddedState() {
        super();
    }

    public void doStepWhileInState()
    {
        draw();
        loop(); // to prevent stuck programs because the original
                // program contained noLoop()
    }

    void setup() {}
    void draw()  {}

    void mousePressed()  {}
    void mouseClicked()  {}
    void mouseReleased() {}
    void mouseDragged()  {}
    void mouseMoved()    {}

    void mouseWheel( MouseEvent event ) {}

    void keyTyped()    {}
    void keyPressed()  {}
    void keyReleased() {}

    void handleMousePressed()  { mousePressed();  } //<>//
    void handleMouseClicked()  { mouseClicked();  }
    void handleMouseReleased() { mouseReleased(); }
    void handleMouseDragged()  { mouseDragged();  }
    void handleMouseMoved()    { mouseMoved();    }

    void handleMouseWheel(MouseEvent mouseEvent) { mouseWheel( mouseEvent ); }

    void handleKeyTyped()    { keyTyped();    }
    void handleKeyPressed()  { keyPressed();  }
    void handleKeyReleased() { keyReleased(); }

}


// ============ StateHandler ============

// Handles everything from keeping the state
// executing a single step, calling enterState
// and leaveState and passing on events
// (mousePressed etc.) to the current state

class StateHandler
{
    private String  name;
    private State   currentState      = null;
    private State   nextState         = null;
    private long    nsAtStateStart;

    protected StateHandler( String handlerName )
    {
        name = handlerName;
    }


    String getName()             { return name; }

    String getStateName()        { return currentState != null ? currentState.getName() : "" ;  }
    long   secondsInState()      { return ( System.nanoTime() - nsAtStateStart ) / 1000000000 ; }
    long   milliSecondsInState() { return ( System.nanoTime() - nsAtStateStart ) /    1000000 ; }


    void handleMousePressed()  { if ( currentState != null ) currentState.handleMousePressed();  }
    void handleMouseClicked()  { if ( currentState != null ) currentState.handleMouseClicked();  }
    void handleMouseReleased() { if ( currentState != null ) currentState.handleMouseReleased(); }
    void handleMouseDragged()  { if ( currentState != null ) currentState.handleMouseDragged();  }
    void handleMouseMoved()    { if ( currentState != null ) currentState.handleMouseMoved();    }

    void handleMouseWheel(MouseEvent event) { currentState.handleMouseWheel( event ); }


    void handleKeyTyped()    { if ( currentState != null ) currentState.handleKeyTyped();    }
    void handleKeyPressed()  { if ( currentState != null ) currentState.handleKeyPressed();  }
    void handleKeyReleased() { if ( currentState != null ) currentState.handleKeyReleased(); }

    void executeCurrentStateStep()
    {
        if ( currentState != null ) {
            currentState.doStepWhileInState();
            changeStateIfNecessary();
            traceIfChanged( name , getStateName() );  // remove for no tracing
        }
    }


    public void changeStateTo( State newState )
    {
        if ( currentState != newState && newState != null ) {
            nsAtStateStart = System.nanoTime();
            nextState = newState;
            changeStateIfNecessary();
        }
    }

   
    private void changeStateIfNecessary()
    {
        if ( nextState != null ) {
            if ( currentState != null ) {
                currentState.leaveState( nextState );
            }
            nextState.enterState( currentState );
            currentState = nextState;
            nextState = null;
        }
    }
}
