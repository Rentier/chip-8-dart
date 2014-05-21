part of chip8;

class Interpreter {
  // http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
  
  Disassembler disasm;
  
  /*
   * Storage place for the 4 nibbles which represent
   * an decoded opcode
   */
  ByteBuffer nibbles;
  
  /*
   * The Chip-8 language is capable of accessing up to 4KB 
   * (4,096 bytes) of RAM, from location 0x000 (0) to 0xFFF 
   * (4095). The first 512 bytes, from 0x000 to 0x1FF, are
   *  where the original interpreter was located, and should 
   *  not be used by programs.
   */
  ByteBuffer ram;
  
  /*
   * Chip-8 has 16 general purpose 8-bit registers, 
   * usually referred to as Vx, where x is a 
   * hexadecimal digit (0 through F).
   */
  Uint8ClampedList registers;
  
  /*
   * There is also a 16-bit register called I. This register 
   * is generally used to store memory addresses, so 
   * only the lowest (rightmost) 12 bits are usually used.
   */
  int iRegister;

  /*
   * The delay timer is active whenever the delay 
   * timer register (DT) is non-zero.
   */
  int delayTimerRegister;
  
  /*
   * The sound timer is active whenever the sound 
   * timer register (ST) is non-zero.
   */
  int soundTimerRegister;
  
  /*
   *  Stores the currently executing address
   */
  int programCounter;
  
  /*
   * The stack pointer is used to point to the 
   * topmost level of the stack.
   */
  int stackPointer;
  
  InstanceMirror mirror;
  
  Interpreter() {
    disasm = new Disassembler();
    ram = new Uint16List(4096).buffer;
    registers = new Uint8ClampedList(16);
    iRegister = 0;    
    delayTimerRegister = 0;
    soundTimerRegister = 0;
    programCounter = 0;
    stackPointer = 0;
    mirror = reflect(this);
  }  
  
  void exec(int opcode) {
    Mnemonics m = disasm.decode(opcode);
    Symbol s = new Symbol(getMethodName(m));
    mirror.invoke(s, []);
  }
  
  String getMethodName(Mnemonics m) {
    return "handle_" + m._value;
  }
  
  int x() {
    return disasm.X;
  }
  
  int y() {
    return disasm.Y;
  }
  
  int Vx() {
    return registers[x()];  
  }
  
  int Vy() {
    return registers[disasm.Y];  
  }
  
  int kk() {
    return disasm.KK;
  }
  
  void skip_instruction(){
    programCounter += 2;
  }

  // 0x1NNN

  /*
   * Jump to location nnn.
   */
  void handle_JPABS() {
    programCounter = disasm.NNN;
  }
  
  // 0x2NNN
  
  // 0x3NNN
  
  /**
   * Skip next instruction if Vx = kk.
   */
  void handle_SEBYTE() {
    if(Vx() == kk()) {
      skip_instruction(); 
    }
  }
  
  // 0x4NNN
  
  /**
   * Skip next instruction if Vx != kk.
   */
  void handle_SNEBYTE() {
    if(Vx() != kk()) {
      skip_instruction();
    }
  }
  
  // 0x5NNN
  
  /**
   * Skip next instruction if Vx = Vy.
   */
  void handle_SEREGISTER() {
    if(Vx() == Vy()) {
      skip_instruction();
    }
  }
  
  // 0x6NNN
  
  /*
   * Set Vx = kk.
   */
  void handle_LDBYTE() {
    registers[x()] = disasm.KK;
  }
  
  // 0x7NNN
  
  /**
   * Set Vx = Vx + kk.
   */
  void handle_ADDBYTE() {
    registers[x()] = registers[x()] + kk();
  }
  
  // 0x8NNN
  
  /**
   * Set Vx = Vy.
   */
  void handle_LDREGISTER() {
    registers[x()] = registers[y()];
  }
  
  /**
   * Set Vx = Vx OR Vy.
   */
  void handle_OR() {
    registers[x()] = registers[x()] | registers[y()];
  }
  
  /**
   * Set Vx = Vx AND Vy.
   */
  void handle_AND() {
    registers[x()] = registers[x()] & registers[y()];
  }
  
  /**
   * Set Vx = Vx XOR Vy.
   */
  void handle_XOR() {
    registers[x()] = registers[x()] ^ registers[y()];
  }
  
  /**
   * Set Vx = Vx + Vy, set VF = carry.
   */
  void handle_ADDREGISTER() {    
    int sum = registers[x()] + registers[y()];
    registers[x()] = sum;    
    registers[0xF] = sum > 0xFF ? 1 : 0;    
  }
  
  /**
   * Set Vx = Vx - Vy, set VF = NOT borrow.
   */
  void handle_SUB() {    
    registers[0xF] = registers[x()] > registers[y()] ? 1 : 0;
    registers[x()] = registers[x()] - registers[y()];
  }


  
}