import java.util.Map;
import java.util.Set;
import java.util.Stack;

class Waiter {

  HashMap<Integer, WaitTime> waiterTime;

  ArrayList<Integer> waiterTimeToRemove;

  HashMap<Integer, WaitTime> waitTimeStack;

  WaitTime[] waiters;
  float[] intervals;
  float[] limits;

  int waitIdCounter;

  public Waiter() {
    waiterTime = new HashMap<Integer, WaitTime>();
    waitTimeStack = new HashMap<Integer, WaitTime>();

    waiterTimeToRemove = new ArrayList<Integer>();
  }

  void step(float delta) {

    if (waitTimeStack.size() > 0) {
      waiterTime.putAll(waitTimeStack);
      waitTimeStack.clear();
    }

    Set<Map.Entry<Integer, WaitTime>> wtEntrySet = waiterTime.entrySet();
    for (Map.Entry me : wtEntrySet) {
      WaitTime w = (WaitTime)me.getValue();
      w.counter += delta;
      if (w.counter > w.limit) {
        w.handler.execute(w.executeId, w.obj);
        waiterTimeToRemove.add(w.hashCode());
      }
    }

    for (int i = 0; i < waiterTimeToRemove.size(); i++) {
      int inx = waiterTimeToRemove.get(i);
      waiterTime.remove(inx);
    }

    waiterTimeToRemove.clear();
  }

  void waitForSeconds(float t, IWaiter handler, int executeId, Object obj) {
    WaitTime w = new WaitTime(handler, t, executeId, obj);

    if (waiterTime.size() > 0) {
      waitTimeStack.put(w.hashCode(), w);
    } else {
      waiterTime.put(w.hashCode(), w);
    }
  }

  class WaitTime {
    IWaiter handler;
    int executeId;
    Object obj;
    float limit;
    float counter;

    public WaitTime(IWaiter w, float interval, int executeId, Object obj) {
      this.handler = w;
      this.limit = interval;
      this.executeId = executeId;
      this.obj = obj;
    }

    String toString() {
      return handler + " : " + limit;
    }
  }
}

interface IWaiter {
    void execute(int executeId, Object obj);
}
