class UsableItemManager {

  HashMap<String, UsableItem> usablesMap = new HashMap<String, UsableItem>();

  void enableUsableItem(String itemName) {
    if (usablesMap.containsKey(itemName)) {
      
      UsableItem usable = usablesMap.get(itemName);
      usable.setEnabled(!usable.enabled);
      
    } else {
      switch (itemName) {
      case "notes_item":
        NotesUsableItem notes = new NotesUsableItem();
        notes.setEnabled(!notes.enabled);
        usablesMap.put(itemName, notes);
      default:
      }
    }
  }

  void step(float delta) {
    for(Map.Entry item : usablesMap.entrySet()) {
      UsableItem usable = (UsableItem)item.getValue();
      
      if (usable.enabled)
        usable.step(delta);
    }
  }
}
