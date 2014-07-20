part of chip8;

class Display {
  
  /*  x ->
   *  --------------------------
   * y|(0,0)             (63,0)|
   * ||                        |
   * v|                        |
   *  |                        |
   *  |(0,31)           (63,31)|
   *  --------------------------
   */ 
  
  static final int WIDTH = 64;
  static final int HEIGHT = 32;
  
  static final bool UNSET = false;
  static final bool SET = true;
  
  /**
   * Pixel data in row-major order
   */
  List<bool> pixel;
  
  Display() {
    pixel = new List<bool>.filled(WIDTH * HEIGHT, false);
  }

  void togglePixel(int x, int y) {
    int i = translateIndex(x, y);
    pixel[i] = SET;
  }
  
  bool pixelIsSet(int x, int y) {
    int i = translateIndex(x, y);
    return  pixel[i] == SET;
  }
  
  void clear() {
    for(int i = 0 ; i < pixel.length; i++) {
      pixel[i] = UNSET;
    }
  }
  
  int translateIndex(int x, int y) {
    return y * WIDTH + x;
  }
  
  toString() {
    StringBuffer sb = new StringBuffer();
    for(int y = 0; y < HEIGHT; y++) {
      for(int x = 0 ; x < WIDTH; x++) {      
        if( pixelIsSet(x,y) ) sb.write('*');
        else sb.write(' ');
      }
      sb.write('\n');
    }

    return sb.toString();
  }
  
  
}
 