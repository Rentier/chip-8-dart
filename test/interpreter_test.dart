library chip8_test;

import 'package:chip8/chip8.dart';  
import 'package:unittest/unittest.dart'; 

main() {
  var interpreter;
  
  group('Chip-8 interpreter:', () {
    
    setUp(() {
      interpreter = new Interpreter();      
    });

    tearDown(() {
      interpreter = null;
    });
    
    test("Interpreter has 4096 bit of RAM", () {
      expect(interpreter.ram.lengthInBytes, 4096);
    });
    
    test("Interpreter has 16 8-bit registers", () {
      expect(interpreter.registers.length, 16);
      expect(interpreter.registers.lengthInBytes, 16);
    });
    
    test("Interpreter has I-Register", () {
      expect(interpreter.iRegister, isNotNull);
    });
    
    test("Interpreter has delay timer register", () {
      expect(interpreter.delayTimerRegister, isNotNull);
    });
    
    test("Interpreter has sound timer register", () {
      expect(interpreter.soundTimerRegister, isNotNull);
    });
    
    test("Interpreter has program counter", () {
      expect(interpreter.programCounter, isNotNull);
    });
    
    test("Interpreter has stack pointer", () {
      expect(interpreter.stackPointer, isNotNull);
    });
    
    test("Interpreter can extract nibbles from opcodes properly", () {
      interpreter.extractNibble(0xABCD);
      expect(interpreter, isNotNull);
    });
    
    
  });

}  