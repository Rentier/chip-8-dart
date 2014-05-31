part of chip8;

class Disassembler {
  
  /*
   *   nnn or addr - A 12-bit value, the lowest 12 bits of the instruction
   *   n - A 4-bit value, the lower 4 bits of the low byte of the instruction
   *   h - A 4-bit value, the upper 4 bits of the high byte of the instruction
   *   x - A 4-bit value, the lower 4 bits of the high byte of the instruction
   *   y - A 4-bit value, the upper 4 bits of the low byte of the instruction
   *   kk or byte - An 8-bit value, the lowest 8 bits of the instruction
   */
   int NNN;      
   int N;
   int H;        
   int X;        
   int Y;        
   int KK;
   int code;
   
   extractFields(int opcode) {
     NNN = opcode & 0x0FFF;
     N = opcode & 0x000F;
     H = (opcode & 0xF000) >> 12;
     X = (opcode & 0x0F00) >> 8;
     Y = (opcode & 0x00F0) >> 4;
     KK = (opcode & 0x00FF);
   }
   
   decode(int opcode) {
     extractFields(opcode);
     switch(H) {
      case 0: return decodeZeroCode(opcode);
      case 1: return Mnemonics.JPABS;
      case 2: return Mnemonics.CALL;
      case 3: return Mnemonics.SEBYTE;
      case 4: return Mnemonics.SNEBYTE;
      case 5: 
        assert(N == 0);
        return Mnemonics.SEREGISTER;
      case 6: return Mnemonics.LDBYTE;
      case 7: return Mnemonics.ADDBYTE;
      case 8: return decodeEightCode(opcode);
      case 9: 
        assert(N == 0);
        return Mnemonics.SNEREGISTER;
      case 0xA: return Mnemonics.LDINSTR;
      case 0xB: return Mnemonics.JPREL;
      case 0xC: return Mnemonics.RND;
      case 0xD: return Mnemonics.DRW;
      case 0xE: return decodeECode(opcode);
      case 0xF: return decodeFCode(opcode);
      default: invalidOpcode(opcode);
    }
   }
   
   decodeZeroCode(int opcode) {
     assert(H == 0);
     switch(opcode) {
       case 0x00E0:  return Mnemonics.CLS;
       case 0x00EE:  return Mnemonics.RET;
       default: return Mnemonics.SYS;
     }
   }
   
   decodeEightCode(int opcode) {
     assert(H == 8);
     switch(N) {
       case 0:  return Mnemonics.LDREGISTER;
       case 1:  return Mnemonics.OR;
       case 2:  return Mnemonics.AND;
       case 3:  return Mnemonics.XOR;
       case 4:  return Mnemonics.ADDREGISTER;
       case 5:  return Mnemonics.SUB;
       case 6:  return Mnemonics.SHR;
       case 7:  return Mnemonics.SUBN;
       case 0xE:  return Mnemonics.SHL;
       default: invalidOpcode(opcode);
     }
   }
   
   decodeECode(int opcode) {
     assert(H == 0xE);
     switch(KK) {
       case 0x9E:  return Mnemonics.SKP;
       case 0xA1:  return Mnemonics.SKNP;
       default: invalidOpcode(opcode);
     }
   }
   
   decodeFCode(int opcode) {
     assert(H == 0xF);
     switch(KK) {
       case 0x07:  return Mnemonics.LDDT;
       case 0x0A:  return Mnemonics.LDKEY;
       case 0x15:  return Mnemonics.SETDT;
       case 0x18:  return Mnemonics.SETSOUND;
       case 0x1E:  return Mnemonics.ADDI;
       case 0x29:  return Mnemonics.LDSPRITE;
       case 0x33:  return Mnemonics.LDBCD;
       case 0x55:  return Mnemonics.PUSH;
       case 0x65:  return Mnemonics.POP;
       default: invalidOpcode(opcode);
     }
   }
   
   invalidOpcode(int opcode) {
     throw("Invalid opcode: 0x" + opcode.toRadixString(16));
   }
}

  
