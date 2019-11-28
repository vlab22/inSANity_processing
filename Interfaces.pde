interface IAnim {
  void onAnimShow(Object obj);
  void onAnimEnd(Object obj);
}
interface IHasHiddenLayer {
  PImage getHiddenImage();
  HiddenCollider[] getHiddenColliders();
  void hiddenColliderHit(HiddenCollider hc);
}
