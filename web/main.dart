import 'dart:html';

import 'package:chip8/chip8.dart';

final int FACTOR = 100;

void main() {
  Interpreter interpreter = new Interpreter();
  Display display = interpreter.display;
  
  CanvasElement canvas = querySelector("#area");
  initCanvas(canvas);
  
  int pixelSize = canvas.width ~/ Display.WIDTH; 
  var context = canvas.context2D;
  
  // aspect ratio
  assert( canvas.width / Display.WIDTH == canvas.height / Display.HEIGHT);
  
  int I = 42;
  
  interpreter.iRegister = I;
  interpreter.ram.setUint8(I, 0xF0);
  interpreter.ram.setUint8(I + 1, 0x90);
  interpreter.ram.setUint8(I + 2, 0x90);
  interpreter.ram.setUint8(I + 3, 0x90);
  interpreter.ram.setUint8(I + 4, 0xF0);

  interpreter.exec(0xD005);

  drawDisplay(context, interpreter.display, pixelSize);
}

initCanvas(CanvasElement canvas) {
  canvas.setAttribute("width", getWidth().toString());
  canvas.setAttribute("height", getHeight().toString());  
}

getWidth() {
  return Display.WIDTH * FACTOR;
}

getHeight() {
  return Display.HEIGHT * FACTOR;  
}

drawDisplay(CanvasRenderingContext2D context, Display display, int size) {
  for(int x = 0; x < Display.WIDTH; x++) {
    for(int y = 0; y < Display.HEIGHT; y++) {
      if(display.pixelIsSet(x, y)) {
        drawPixel(context, x, y, size);
      }      
    }
  }
}

drawPixel(CanvasRenderingContext2D context, x, y, size) {
  context..fillStyle = "black"
         ..strokeStyle = "green"
         ..fillRect(x * size,y * size, size, size);

}


