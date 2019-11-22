class InventoryPanel {

  int x;
  int y;

  int openY = 899;
  int closeY = 1055;

  UIImageShape bgImage;

  InventoryPanel() {
    openY = round(899 * heightRatio);
    closeY = round(1055 * heightRatio);

    x = 0;
    y = closeY;

    bgImage = new UIImageShape(0, 0, "Inventory Layout Panel.png");
  }

  void display(float delta) {
    
    //y = round(map(mouseY, 0, height, openY, 1200));
    println(y);
    
    pushMatrix();
    translate(x, y);
    bgImage.display(delta);
    popMatrix();
  }
}
