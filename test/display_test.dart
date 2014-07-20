part of chip8_test;

test_display() {
  Display display;
  
  group('Chip-8 display:', () {
    
    List points = 
       [
        // Edges
        [0, 0],
        [63, 0],
        [0, 31],
        [63, 31],
        [10, 20],
        // Misc
        [42, 24],
        [13, 5]
        ];
    
    setUp(() {
      display = new Display();
    });

    tearDown(() {
      display = null;
    });
    
    test("should set Pixel", () {      
      points.forEach((p) => display.togglePixel(p[0], p[1]));      
      points.forEach((p) => expect(display.pixelIsSet(p[0], p[1]), isTrue));
    });
    
    test("should clear display", () {
      points.forEach((p) => display.togglePixel(p[0], p[1]));    
      
      display.clear();
      
      display.pixel.forEach((i) => expect(i, isFalse));
    });
    
  });
  
}