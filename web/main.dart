import 'dart:html';
import 'dart:typed_data';
import 'dart:async';

import 'package:chip8/chip8.dart';

final int FACTOR = 100;

var LOG = window.console;
bool loaded = false;
bool running = false;

void main() {    
  Interpreter interpreter = new Interpreter();
  Display display = interpreter.display;
  
  CanvasElement canvas = querySelector("#area");
  var element = querySelector('#counter');

  initCanvas(canvas);
  
  int pixelSize = canvas.width ~/ Display.WIDTH; 
  var context = canvas.context2D;
  
  // aspect ratio
  assert( canvas.width / Display.WIDTH == canvas.height / Display.HEIGHT);
  
  int I = 0;
  
  interpreter.iRegister = I;
  
  LOG.info("Load Rom");
  getRomFromServer('SCTEST').then( (rom) {
    LOG.info("ROM info: ");
    LOG.info(rom.length);
    
    if(rom != null) {
      interpreter.loadRom(rom);
    } else {
      LOG.error("ROM is null!");
    }
       
    interpreter.exec(0xD005);
    
    int counter = 0;
    
    display.clear();
  
    new Timer.periodic(new Duration(milliseconds:16), (_) {
      interpreter.stepForward();
      drawDisplay(context, interpreter.display, pixelSize);
      //element.text = "0x" + interpreter.programCounter.toRadixString(16) + " " + interpreter.m.toString();

    });
  });
}

void initCanvas(CanvasElement canvas) {
  canvas.setAttribute("width", getWidth().toString());
  canvas.setAttribute("height", getHeight().toString());  
}

int getWidth() {
  return Display.WIDTH * FACTOR;
}

int getHeight() {
  return Display.HEIGHT * FACTOR;  
}

void drawDisplay(CanvasRenderingContext2D context, Display display, int size) {
  for(int x = 0; x < Display.WIDTH; x++) {
    for(int y = 0; y < Display.HEIGHT; y++) {
      if(display.pixelIsSet(x, y)) {
        drawPixel(context, x, y, size);
      }      
    }
  }
}

void drawPixel(CanvasRenderingContext2D context, x, y, size) {
  context..fillStyle = "black"
         ..strokeStyle = "green"
         ..fillRect(x * size,y * size, size, size);
}


Future<Uint8List> getRomFromServer(String name) {
  var request = new HttpRequest();
  Uint8List rom;
  var completer = new Completer<Uint8List>();  
  
  request..open('GET', 'roms/' + name)
         ..responseType = 'arraybuffer'
         ..onLoadEnd.listen((e) => completer.complete(requestComplete(request)))
         ..send(''); 

  print("Request finished");
  
  return completer.future;
}

Uint8List requestComplete(HttpRequest req) {
  LOG.info("requestComplete ");

  if(req.status == 200) {
    return new Uint8List.view(req.response  as ByteBuffer);    
  } else {
    throw new Exception("Could not retrieve ROM");
  }
}




