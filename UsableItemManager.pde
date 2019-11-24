class UsableItemManager {

  HashMap<String, UsableItem> usablesMap = new HashMap<String, UsableItem>();

  void enableUsableItem(String itemName, ArrayList<Object> objs) {

    if (usablesMap.containsKey(itemName)) {     
      UsableItem usable = usablesMap.get(itemName);

      if (usable instanceof NotesUsableItem) {
        for (int i = 0; i < objs.size(); i++) {
          ((NotesUsableItem)usable).addPage(objs.get(i));
        }
      }
      usable.setEnabled(!usable.enabled);
    } else {

      switch (itemName) {
      case "notes_item":
        NotesUsableItem notes = new NotesUsableItem();

        for (int i = 0; i < objs.size(); i++) {
          notes.addPage(objs.get(i));
        }

        usablesMap.put(itemName, notes);

        notes.setEnabled(!notes.enabled);
      default:
      }
    }
  }

  void step(float delta) {

    boolean disableSceneMousePressed = false;

    for (Map.Entry item : usablesMap.entrySet()) {
      UsableItem usable = (UsableItem)item.getValue();

      if (usable.enabled) {
        if (usable.allowSceneMousePressed == false) {
          disableSceneMousePressed = true;
        }
        usable.step(delta);
      }

      stateHandler.currentState.allowMousePressed = !disableSceneMousePressed;
    }
  }

  void handleMousePressed() { 
    for (Map.Entry item : usablesMap.entrySet()) {
      UsableItem usable = (UsableItem)item.getValue();

      if (usable.enabled) {
        usable.handleMousePressed();
      }
    }
  }
}
