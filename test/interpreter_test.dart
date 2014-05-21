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
    
  skip_group('0x0NNN', () {
  
    test("Interpreter handles CLS", () {
      fail("nye");
    });
    
    test("Interpreter handles RET", () {
      fail("nye");
    });
  
  });
  
  group('0x1NNN', () {
  
    test("Interpreter handles JPABS", () {
      interpreter.exec(0x1ABC);
      expect(interpreter.programCounter, 0xABC);
    });
  
  });
  
  // 0x3nnn
  
  group('Interpreter handles SEBYTE', () {
    
    test("Should not skip", () {
      // V2(0xAB) != 0xCD?
      interpreter.registers[2] = 0xAB;
      interpreter.exec(0x34CD);
      expect(interpreter.programCounter, 0);
    });
    
    test("Should skip", () {
      // V4(0x42) != 0x42?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.exec(0x3442);
      expect(interpreter.programCounter, 2);
    });
  
  });
  
  // 0x4nnn
  
  group('Interpreter handles SNEBYTE', () {
    
    test("Should not skip", () {
      // V4(0x42) != 0x42?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.exec(0x4442);
      expect(interpreter.programCounter, 0);
    });
    
    test("Should skip", () {
      // V2(0xAB) != 0xCD?
      interpreter.registers[2] = 0xAB;
      interpreter.exec(0x42CD);
      expect(interpreter.programCounter, 2);
    });
  
  });  
  
  // 0x5nnn
  
  group('Interpreter handles SEREGISTER', () {
    
    test("Should not skip", () {
      // V4(0x42) == V5(0x43)?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.registers[5] = 0x43; // V5 = 0x43
      interpreter.exec(0x5450);
      expect(interpreter.programCounter, 0);
    });
    
    test("Should skip", () {
      // V4(0x42) == V5(0x42)?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.registers[5] = 0x42; // V5 = 0x43
      interpreter.exec(0x5450);
      expect(interpreter.programCounter, 2);
    });
  
  });  
  
  // 0x6nnn 
  
  group('Interpreter handles LDBYTE', () {
    
    test("Load 0x42 into V3", () {
      interpreter.exec(0x6342);
      expect(interpreter.registers[3], 0x42);
    });
  
  }); 
  
  // 0x7nnn 
  
  group('Interpreter handles ADDBYTE', () {
      
      test("0 + 0 -> V0", () {
        interpreter.exec(0x7000);
        expect(interpreter.registers[0], 0x00);
      });
      
      test("0x42 + 0 -> V3", () {

        interpreter.exec(0x7342);
        expect(interpreter.registers[3], 0x42);
      });
      
      test("1 + 2 -> V3", () {
        interpreter.registers[3] = 1;
        interpreter.exec(0x7302);
        expect(interpreter.registers[3], 3);
      });
    
    }); 
  
  // 0x8nnn 
  
  group('Interpreter handles LDREGISTER', () {
    
    test("Move 0x42 from V1 to V3", () {
      interpreter.registers[1] = 0x42;
      interpreter.exec(0x8310);
      expect(interpreter.registers[3], 0x42);
    });
  
  });  
  
  group('Interpreter handles OR', () {
    
    test("V7(0x42) OR V8(0x23) -> V3", () {
      interpreter.registers[7] = 0x42;
      interpreter.registers[8] = 0x23;
      interpreter.exec(0x8781);
      expect(interpreter.registers[7], 0x63);
    });
  
  });  
  
  group('Interpreter handles AND', () {
    
    test("V7(0x42) AND V8(0x23) -> V3", () {
      interpreter.registers[7] = 0x42;
      interpreter.registers[8] = 0x23;
      interpreter.exec(0x8782);
      expect(interpreter.registers[7], 0x2);
    });
  
  });
  
  group('Interpreter handles XOR', () {
    
    test("V7(0x42) XOR V8(0x23) -> V3", () {
      interpreter.registers[7] = 0x42;
      interpreter.registers[8] = 0x23;
      interpreter.exec(0x8783);
      expect(interpreter.registers[7], 0x61);
    });
  
  });
  
  group('Interpreter handles ADDREGISTER', () {
    
    test("No carry: V0(0x1) + V1(0x2) -> V0", () {
      interpreter.registers[0] = 0x1;
      interpreter.registers[1] = 0x2;
      interpreter.exec(0x8014);
      expect(interpreter.registers[0], 0x3);
      expect(interpreter.registers[0xF], 0);
    });
    
    test("Carry: V0(0xFF) + V1(0x2) -> V0", () {
      interpreter.registers[0] = 0xFF;
      interpreter.registers[1] = 0x2;
      interpreter.exec(0x8014);
      expect(interpreter.registers[0], 0xFF);
      expect(interpreter.registers[0xF], 1);
    });
  
  });
  
  group('Interpreter handles ADDREGISTER', () {
    
    test("Vx > Vy: V0(0x3) - V1(0x2) -> V0", () {
      interpreter.registers[0] = 0x3;
      interpreter.registers[1] = 0x2;
      interpreter.exec(0x8015);
      expect(interpreter.registers[0], 0x1);
      expect(interpreter.registers[0xF], 1);
    });
    
    test("Vx < Vy: V0(0x1) - V1(0x3) -> V0", () {
      interpreter.registers[0] = 0x1;
      interpreter.registers[1] = 0x3;
      interpreter.exec(0x8015);
      expect(interpreter.registers[0], 0);
      expect(interpreter.registers[0xF], 0);
    });
  
  });
    
  });

}  