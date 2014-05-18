import 'package:unittest/unittest.dart'; 
import 'package:chip8/chip8.dart';

main() {
  var disasm;
  
  group('Chip-8 disassembler:', () {
    
    setUp(() {
      disasm = new Disassembler();      
    });

    tearDown(() {
      disasm = null;
    });
    
    test("Disassembler extracts fields right - 0xABCD", () {
      disasm.extractFields(0xABCD);
      expect(disasm.NNN, 0xBCD);
      expect(disasm.N, 0xD);
      expect(disasm.H, 0xA);
      expect(disasm.X, 0xB);
      expect(disasm.Y, 0xC);
      expect(disasm.KK, 0xCD);
    });
    
    // 0x0nnn
    
    test("Disassembler decodes SYS", () {
      expect(disasm.decode(0x0ABC), Mnemonics.SYS);
    });
    
    test("Disassembler decodes CLS", () {     
      expect( disasm.decode(0x00E0), Mnemonics.CLS);
    });
    
    test("Disassembler decodes RET", () {
      expect(disasm.decode(0x00EE), Mnemonics.RET);
    });
    
    // 0x1nnn
    
    test("Disassembler decodes JP", () {
      expect(disasm.decode(0x1ABC), Mnemonics.JPABS);
      expect(disasm.NNN, 0xABC);
    });
    
    // 0x2nnn
    
    test("Disassembler decodes CALL", () {
      expect(disasm.decode(0x2ABC), Mnemonics.CALL);
      expect(disasm.NNN, 0xABC);
    });
    
    // 0x3nnn
    
    test("Disassembler decodes SEBYTE", () {
      expect(disasm.decode(0x3ABC), Mnemonics.SEBYTE);
      expect(disasm.NNN, 0xABC);      
    });
    
    // 0x4nnn
    
    test("Disassembler decodes SNEBYTE", () {
      expect(disasm.decode(0x4ABC), Mnemonics.SNEBYTE);
      expect(disasm.X, 0xA);      
      expect(disasm.KK, 0xBC);
    });
    
    // 0x5nnn
    
    test("Disassembler decodes SEREGISTER", () {
      expect(disasm.decode(0x5AB0), Mnemonics.SEREGISTER);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    // 0x6nnn
    
    test("Disassembler decodes LDBYTE", () {
      expect(disasm.decode(0x6ABC), Mnemonics.LDBYTE);
      expect(disasm.X, 0xA);      
      expect(disasm.KK, 0xBC);
    });
    
    // 0x7nnn
    
    test("Disassembler decodes ADDBYTE", () {
      expect(disasm.decode(0x7ABC), Mnemonics.ADDBYTE);
      expect(disasm.X, 0xA);      
      expect(disasm.KK, 0xBC);
    });
    
    // 0x8nnn
    
    test("Disassembler decodes LDREGISTER", () {
      expect(disasm.decode(0x8AB0), Mnemonics.LDREGISTER);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes OR", () {
      expect(disasm.decode(0x8AB1), Mnemonics.OR);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes AND", () {
      expect(disasm.decode(0x8AB2), Mnemonics.AND);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes XOR", () {
      expect(disasm.decode(0x8AB3), Mnemonics.XOR);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes ADDREGISTER", () {
      expect(disasm.decode(0x8AB4), Mnemonics.ADDREGISTER);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes SUB", () {
      expect(disasm.decode(0x8AB5), Mnemonics.SUB);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes SHR", () {
      expect(disasm.decode(0x8AB6), Mnemonics.SHR);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes SUBN", () {
      expect(disasm.decode(0x8AB7), Mnemonics.SUBN);
      expect(disasm.X, 0xA);
      expect(disasm.Y, 0xB);
    });
    
    test("Disassembler decodes SHL", () {
      expect(disasm.decode(0x8ABE), Mnemonics.SHL);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    // 0x9nnn
    
    test("Disassembler decodes SNE", () {
      expect(disasm.decode(0x9AB0), Mnemonics.SNE);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
    });
    
    // 0xAnnn
    
    test("Disassembler decodes LDINSTR", () {
      expect(disasm.decode(0xABCD), Mnemonics.LDINSTR);
      expect(disasm.NNN, 0xBCD);      
    });
    
    // 0xBnnn
    
    test("Disassembler decodes JPREL", () {
      expect(disasm.decode(0xBBCD), Mnemonics.JPREL);
      expect(disasm.NNN, 0xBCD);      
    });
    
    // 0xCnnn
    
    test("Disassembler decodes RND", () {
      expect(disasm.decode(0xCDEF), Mnemonics.RND);
      expect(disasm.X, 0xD);      
      expect(disasm.KK, 0xEF);
    });
    
    // 0xDnnn
    
    test("Disassembler decodes DRW", () {
      expect(disasm.decode(0xDABC), Mnemonics.DRW);
      expect(disasm.X, 0xA);      
      expect(disasm.Y, 0xB);
      expect(disasm.N, 0xC);
    });
    
    // 0xEnnn
    
    test("Disassembler decodes SKP", () {
      expect(disasm.decode(0xE39E), Mnemonics.SKP);
      expect(disasm.X, 0x3);
    });
    
    test("Disassembler decodes SKNP", () {
      expect(disasm.decode(0xE3A1), Mnemonics.SKNP);
      expect(disasm.X, 0x3);
    });
    
    // 0xFnnn
    
    test("Disassembler decodes LDDT", () {
      expect(disasm.decode(0xFE07), Mnemonics.LDDT);
      expect(disasm.X, 0xE);
    });
    
    test("Disassembler decodes LDKEY", () {
      expect(disasm.decode(0xFE0A), Mnemonics.LDKEY);
      expect(disasm.X, 0xE);
    });
    
    test("Disassembler decodes SETDT", () {
      expect(disasm.decode(0xFE15), Mnemonics.SETDT);
      expect(disasm.X, 0xE);
    });
    
    test("Disassembler decodes SETSOUND", () {
      expect(disasm.decode(0xFE18), Mnemonics.SETSOUND);
      expect(disasm.X, 0xE);
    });
    
    test("Disassembler decodes ADDI", () {
      expect(disasm.decode(0xFB1E), Mnemonics.ADDI);
      expect(disasm.X, 0xB);
    });
    
    test("Disassembler decodes LDSPRITE", () {
      expect(disasm.decode(0xFC29), Mnemonics.LDSPRITE);
      expect(disasm.X, 0xC);
    });
    
    test("Disassembler decodes LDBCD", () {
      expect(disasm.decode(0xFD33), Mnemonics.LDBCD);
      expect(disasm.X, 0xD);
    });
    
    test("Disassembler decodes PUSH", () {
      expect(disasm.decode(0xFE55), Mnemonics.PUSH);
      expect(disasm.X, 0xE);
    });
    
    test("Disassembler decodes POP", () {
      expect(disasm.decode(0xFF65), Mnemonics.POP);
      expect(disasm.X, 0xF);
    });
    
    
    
    
    
  });
    
}