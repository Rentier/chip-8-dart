part of chip8_test;

test_interpreter() {
  Interpreter interpreter;
  
  group('Chip-8 interpreter:', () {
    
  setUp(() {
    interpreter = new Interpreter();      
  });

  tearDown(() {
    interpreter = null;
  });
  
  group('Util', () {
    
    group('Should split byte into bits', () {
      test("0x3C", () {
        // 0x3C   00111100
        List<bool> expectedBits = [false,false,true,true,true,true,false,false];
        expect(interpreter.getBits(0x3C), equals(expectedBits));
      });      
      
      test("0xC3", () {
        // 0xC3   11000011
        List<bool> expectedBits = [true,true,false,false,false,false,true,true];
        expect(interpreter.getBits(0xC3), equals(expectedBits));
      });
      
    });    
  });
    
  // 0x0nnn
    
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
  
  group('Interpreter handles SUB', () {    
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
  
  group('Interpreter handles SHR', () {    
    test("V0(0x2) >> 1 -> V0", () {
      interpreter.registers[0] = 0x2;
      interpreter.exec(0x8006);
      expect(interpreter.registers[0], 0x1);
      expect(interpreter.registers[0xF], 0);
    });
    
    test("V0(0x3) >> 1 -> V0", () {
      interpreter.registers[0] = 0x3;
      interpreter.exec(0x8006);
      expect(interpreter.registers[0], 0x1);
      expect(interpreter.registers[0xF], 1);
    });  
  });
  
  group('Interpreter handles SUBN', () { 
    test("Vx < Vy: V1(0x3) - V0(0x1) -> V0", () {
      interpreter.registers[0] = 0x1;
      interpreter.registers[1] = 0x3;
      interpreter.exec(0x8017);
      expect(interpreter.registers[0], 2);
      expect(interpreter.registers[0xF], 1);
    });
      
    test("Vx > Vy: V1(0x2) - V0(0x3) -> V0", () {
      interpreter.registers[0] = 0x3;
      interpreter.registers[1] = 0x2;
      interpreter.exec(0x8017);
      expect(interpreter.registers[0], 0);
      expect(interpreter.registers[0xF], 0);
    });  
  });
  
  group('Interpreter handles SHL', () {    
    test("V0(0x1) << 1 -> V0", () {
      interpreter.registers[0] = 0x1;
      interpreter.exec(0x800E);
      expect(interpreter.registers[0], 0x2);
      expect(interpreter.registers[0xF], 0);
    });
    
    test("Overflow: V0(0xFF) << 1 -> V0", () {
      interpreter.registers[0] = 0xFF;
      interpreter.exec(0x800E);
      expect(interpreter.registers[0], 0xFF);
      expect(interpreter.registers[0xF], 1);
    });    
  });
    
  // 0x9nnn 
  
  group('Interpreter handles SNEREGISTER', () {    
    test("Should not skip", () {
      // V4(0x42) != V5(0x42)?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.registers[5] = 0x42; // V5 = 0x43
      interpreter.exec(0x9450);
      expect(interpreter.programCounter, 0);
    });  
    
    test("Should skip", () {
      // V4(0x42) != V5(0x43)?
      interpreter.registers[4] = 0x42; // V4 = 0x42
      interpreter.registers[5] = 0x43; // V5 = 0x43
      interpreter.exec(0x9450);
      expect(interpreter.programCounter, 2);
    });
  });  
  
  // 0xAnnn 

  group('Interpreter handles LDINSTR', () {    
    test("Load 0x345 into I", () {
      interpreter.exec(0xA345);
      expect(interpreter.iRegister, 0x345);
    });  
  }); 
  
  // 0xBnnn
  
  group('Interpreter handles JPREL', () {    
    test("Jump 0x345 + V0(0x0)", () {
      interpreter.exec(0xB345);
      expect(interpreter.programCounter, 0x345);
    });  
    
    test("Jump 0x345 + V0(0x1)", () {
      interpreter.registers[0] = 1; // V0 = 1
      interpreter.exec(0xB345);
      expect(interpreter.programCounter, 0x346);
    }); 
  });
  
  // 0xCnnn
  
  group('Interpreter handles RND', () {    
    test("random byte AND 0x42 -> V0", () {
      interpreter.get_random_byte = () { return 0xAB; };
      interpreter.exec(0xC042);
      expect(interpreter.registers[0], 0x2);
    });     
  });
  
  // 0xDnnn
  
  group('Interpreter handles DRW', () {    
    test("Draw stage sprite", () {
      // HEX    BIN        Sprite
      // 0x3C   00111100     ****
      // 0xC3   11000011   **    **
      
      int I = 42;
      
      interpreter.iRegister = I;
      interpreter.ram[I] =  0x3C;
      interpreter.ram[I+1] =  0xC3;
      
      interpreter.exec(0xD003);
          
      expect(interpreter.display.pixelIsSet(0, 0), isFalse);
      expect(interpreter.display.pixelIsSet(1, 0), isFalse);
      expect(interpreter.display.pixelIsSet(2, 0), isTrue);
      expect(interpreter.display.pixelIsSet(3, 0), isTrue);
      expect(interpreter.display.pixelIsSet(4, 0), isTrue);
      expect(interpreter.display.pixelIsSet(5, 0), isTrue);
      expect(interpreter.display.pixelIsSet(6, 0), isFalse);
      expect(interpreter.display.pixelIsSet(7, 0), isFalse);
      
      expect(interpreter.display.pixelIsSet(0, 1), isTrue);
      expect(interpreter.display.pixelIsSet(1, 1), isTrue);
      expect(interpreter.display.pixelIsSet(2, 1), isFalse);
      expect(interpreter.display.pixelIsSet(3, 1), isFalse);
      expect(interpreter.display.pixelIsSet(4, 1), isFalse);
      expect(interpreter.display.pixelIsSet(5, 1), isFalse);
      expect(interpreter.display.pixelIsSet(6, 1), isTrue);
      expect(interpreter.display.pixelIsSet(7, 1), isTrue);
    });    
    
    test("Draw stage sprite with overlap", () {
      
    });
  });
  
  // 0xEnnn
  
  group('should handle SKP', () {    
    test("Should not skip", () {
      // Is Key 5 Pressed?
      interpreter.registers[5] = 0x5; // V5 = 0x43
      interpreter.exec(0xE59E);
      expect(interpreter.programCounter, 0);
    });  
    
    test("should skip", () {
      // Is Key 5 Pressed?
      interpreter.registers[5] = 0x5; // V5 = 0x43
      interpreter.keys[5] = true;
      
      interpreter.exec(0xE59E);      
      expect(interpreter.programCounter, 2);
    });
  });   
  
  group('should handle SKNP', () {     
    test("Should not skip", () {
      // Is Key 5 Pressed?
      interpreter.registers[5] = 0x5; // V5 = 0x43
      interpreter.keys[5] = true;
      
      interpreter.exec(0xE5A1);      
      expect(interpreter.programCounter, 0);
    });
    
    test("should skip", () {
      // Is Key 5 Pressed?
      interpreter.registers[5] = 0x5; // V5 = 0x43
      interpreter.exec(0xE5A1);
      expect(interpreter.programCounter, 2);
    });
  }); 
  
  skip_group('should handle LDKEY', () {    
    test("should be tested", () {
      fail('Not yet implemented');
    });  
  }); 
  
  group('should handle LDDT', () {    
    test("Load DT(0x42) into V5", () {
      interpreter.delayTimer = 0x42;
      interpreter.exec(0xF507);
      expect(interpreter.registers[5], 0x42);
    });  
  }); 
  
  group('should handle SETDT', () {
    test("Load V5(0x42) into DT", () {
      interpreter.registers[5] = 0x42;
      interpreter.exec(0xF515);
      expect(interpreter.delayTimer, 0x42);
    });  
  }); 
  
  group('should handle SETSOUND', () {
    test("Load V5(0x42) into ST", () {
      interpreter.registers[5] = 0x42;
      interpreter.exec(0xF518);
      expect(interpreter.soundTimer, 0x42);
    });  
  });
  
  group('should handle ADDI', () {    
    test("V4(0x42) + I(0x8) -> I", () {
      interpreter.registers[4] = 0x42;
      interpreter.iRegister = 0x8;      
      interpreter.exec(0xF41E);      
      expect(interpreter.iRegister, 0x4A);
    });    
  });  
  
  skip_group('should handle LDSPRITE', () {    
    test("should be tested", () {
      fail('Not yet implemented');
    });  
  });
  
  group('should handle LDBCD', () {    
    test("162 -> 1 6 2", () {
      interpreter.registers[4] = 162;
      int I = 0x200;
      interpreter.iRegister = I;

      interpreter.exec(0xF433);   
      
      expect(interpreter.ram[I], 2);
      expect(interpreter.ram[I+1], 6);
      expect(interpreter.ram[I+2], 1);
    });    
  });
  
  group('should handle PUSH', () {    
    test("write values in registers and push them", () {
      int A = 0x42, 
          B = 0x23, 
          C = 0xAB,
          D = 0x01,
          I = 0x200;      
      
      interpreter.iRegister = I;
      interpreter.registers[0] = A;
      interpreter.registers[1] = B;
      interpreter.registers[2] = C;
      interpreter.registers[3] = D;
      
      interpreter.exec(0xF355);
      
      expect(interpreter.ram[I], A);
      expect(interpreter.ram[I+1], B);
      expect(interpreter.ram[I+2], C);
      expect(interpreter.ram[I+3], D);
    });  
  });
  
  group('should handle POP', () {    
    test("write values in ram and pop them into registers", () {
      int A = 0x42, 
          B = 0x23, 
          C = 0xAB,
          D = 0x01,
          I = 0x200;      
      
      interpreter.iRegister = I;
      interpreter.ram[I] = A;
      interpreter.ram[I+1] = B;
      interpreter.ram[I+2] = C;
      interpreter.ram[I+3] = D;
      
      interpreter.exec(0xF365);
      
      expect(interpreter.registers[0], A);
      expect(interpreter.registers[1], B);
      expect(interpreter.registers[2], C);
      expect(interpreter.registers[3], D);
    });  
  });
  
  });

}  