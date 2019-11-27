interface IAnim {
  void onAnimShow();
  void onAnimEnd(Object obj);
}
interface IHasHiddenLayer {
  PImage getHiddenImage();
  HiddenCollider[] getHiddenColliders();
  void hiddenColliderHit(HiddenCollider hc);
}
