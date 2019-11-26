class UsableItemManager {

  HashMap<String, UsableItem> usablesMap = new HashMap<String, UsableItem>();

  void enableUsableItem(String itemName, ArrayList<Object> codeObjs) {

    if (usablesMap.containsKey(itemName)) {     
      UsableItem usable = usablesMap.get(itemName);

      if (usable instanceof NotesUsableItem) {
        for (int i = 0; i < codeObjs.size(); i++) {
          ((NotesUsableItem)usable).addPage(codeObjs.get(i));
        }
      } else if (usable instanceof FlashLightUsableItem) {
      }
      usable.setEnabled(!usable.enabled);
    } else {
      createItem(itemName, codeObjs);
    }
  }

  //Instanciate the object of the item
  void createItem(String itemName, ArrayList<Object> codeObjs) {
    UsableItem usable = null; //<>//

    switch (itemName) {
    case "notes_item":
      NotesUsableItem notes = new NotesUsableItem();

      for (int i = 0; i < codeObjs.size(); i++) {
        notes.addPage(codeObjs.get(i));
      }

      notes.setEnabled(!notes.enabled);
      usable = notes;

      break;

    case "batteries_item":
      invManager.tryInstallBatteries();

      break;

    case "flashlight_batteries_item":
      FlashLightUsableItem flash = new FlashLightUsableItem();
      usable = flash;
      
      break;

    default:
    }
    if (usable != null)
      usablesMap.put(itemName, usable);
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
