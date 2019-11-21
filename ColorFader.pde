static class ColorFader {
  int from = 0;
  int to = 255;
  
  float duration = 1;
  float delay = 0;
  
  int[] alphas;
  
  ColorFader(color[] colors) {
    alphas = new int[colors.length];
    for(int i = 0; i < colors.length; i++) {
      alphas[i] = (colors[i] >> 24) & 0xFF;
    }
  }
  
  void fade() {
  }
  
  
//  static HashMap<Integer, HasFade> fades = new HashMap<Integer, HasFade>();

//  static void createFade(HasFade fade, int from, int to, float duration, float delay) {
//    fades.put(fade.hashCode(), fade);
//  }

//  static void createFadeOut(HasFade fade, int from, int to, float duration, float delay) {
//  }

//  static void createFadeInOut(HasFade fade, int from, int to, float duration, float delay) {
//  }

//  static void createFadeInOut(HasFade fade, int from, int to, float duration, float delay, float delayBeforeFadeout) {
//  }

//  static void run() {
//    for (Map.Entry me : fades.entrySet()) {
//    }
//  }

//  interface HasFade {
//    color[] getColors();
//    void setColors(color[] colors);
//  }
}

  interface IHasFade {
    color[] getColors();
    void setColors(color[] colors);
  }
