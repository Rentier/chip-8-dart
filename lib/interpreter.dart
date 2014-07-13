part of chip8;

class Interpreter {
  // http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
  
  Disassembler disasm;
  
  Display display;
   
  /*
   * The Chip-8 language is capable of accessing up to 4KB 
   * (4,096 bytes) of RAM, from location 0x000 (0) to 0xFFF 
   * (4095). The first 512 bytes, from 0x000 to 0x1FF, are
   *  where the original interpreter was located, and should 
   *  not be used by programs.
   */
  Uint8List ram;
  
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
  int delayTimer;
  
  /*
   * The sound timer is active whenever the sound 
   * timer register (ST) is non-zero.
   */
  int soundTimer;
  
  /*
   *  Stores the currently executing address
   */
  int programCounter;
  
  /*
   * The stack pointer is used to point to the 
   * topmost level of the stack.
   */
  int stackPointer;
  
  Mnemonics m;
  
  List<bool> keys;
  
  InstanceMirror mirror;
  
  static Random rng = new Random();
  
  static final List<int> CHIP8_FONTSET = [ 
    0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
    0x20, 0x60, 0x20, 0x20, 0x70, // 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
    0x90, 0x90, 0xF0, 0x10, 0x10, // 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
    0xF0, 0x10, 0x20, 0x40, 0x40, // 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, // A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
    0xF0, 0x80, 0x80, 0x80, 0xF0, // C
    0xE0, 0x90, 0x90, 0x90, 0xE0, // D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
    0xF0, 0x80, 0xF0, 0x80, 0x80  // F
  ];
  
  static int HEX = 16;
  
  Interpreter() {
    disasm = new Disassembler();
    display = new Display();
    
    initRam();  
    initStack();

    registers = new Uint8ClampedList(16);
    
    keys = new List<bool>.filled(16, false);
    
    iRegister = 0;    
    delayTimer = 0;
    soundTimer = 0;
    programCounter = 0;
    
    mirror = reflect(this);
  }
  
  initRam() {
    ram = new Uint8List(4096);
    for(int i = 0; i < CHIP8_FONTSET.length; i++) {
      ram[i] = CHIP8_FONTSET[i];
    }
  }
  
  initStack() {
    stackPointer = 0;  
  }
  
  loadRom(Uint8List rom) {
    for(int i = 0; i < rom.length; i++) {
      ram[0x200 + i] = rom[i];
      print(m.toString() + " " + rom[i].toRadixString(16));
    }
    programCounter = 0x200;
  }
  
  void exec(int opcode) {
    m = disasm.decode(opcode);
    Symbol s = new Symbol(getMethodName(m));
    mirror.invoke(s, []);
  }
  
  String getMethodName(Mnemonics m) {
    return "handle_" + m._value;
  }
  
  void stepForward() {
    int opcode = ram[pc()] << 8;
    opcode += ram[pc() + 1];
    print(opcode.toRadixString(HEX));
    exec(opcode);
    programCounter += 2;
  }
  
  /*
   * Getter Candy
   */
  
  int x() {
    return disasm.X;
  }
  
  int y() {
    return disasm.Y;
  }
  
  int n() {
    return disasm.N;
  }
  
  int nnn() {
    return disasm.NNN;
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
  
  int pc() {
    return programCounter;
  }
  
  /*
   * 
   */
  
  void skip_instruction(){
    programCounter += 2;
  }
  
  // Make randomness easily testable by overriding this function
  var get_random_byte = () { return rng.nextInt(0xFF + 1); }; 
  
  /**
   * Returns list of bits of a byte 
   */
  List<bool> getBits(int byte) {
    List<bool> bits = new List<bool>(8);
    int mask = 0x01;
    for(int i = 0; i < 8; i++) {
      var bit = (byte & mask) >> i;
      bits[i] = bit == 0 ? false : true;
      mask <<= 1;
    }
    return bits;
  }
  
  // 0x0NNN
  
  void handle_SYS() {
     programCounter = disasm.NNN;
  }

  // 0x1NNN

  /**
   * Jump to a machine code routine at nnn.
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
  
  /**
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
  
  /**
   * Set Vx = Vx >> 1.
   */
  void handle_SHR() {    
    registers[0xF] = registers[x()] & 0x1;
    registers[x()] = registers[x()] ~/ 2;
  }
  
  /**
   * Set Vx = Vy - Vx, set VF = NOT borrow.
   */
  void handle_SUBN() {
    registers[0xF] = registers[y()] > registers[x()] ? 1 : 0;
    registers[x()] = registers[y()] - registers[x()];
  }
  
  /**
   * Set Vx = Vx << 1.
   */
  void handle_SHL() {   
    registers[0xF] = (registers[x()] & 0x80) == 0 ? 0 : 1; // 1000 0000
    registers[x()] = registers[x()] * 2;
  }
  
  // 0x9nnn 
  
  /**
   * Skip next instruction if Vx != Vy.
   */
  void handle_SNEREGISTER() {
    if(Vx() != Vy()) {
      skip_instruction();
    }
  }
  
  // 0xAnnn 
  
  /**
   * Set I = nnn.
   */
  void handle_LDINSTR() {
    iRegister = nnn();
  } 
  
  // 0xBnnn 
  
  /**
   * Set I = nnn.
   */
  void handle_JPREL() {
    programCounter = nnn() + registers[0];
  }
  
  // 0xCnnn 
  
  /**
   * Set Vx = random byte AND kk.
   */
  void handle_RND() {
    registers[Vx()] = get_random_byte() & kk();
  }
  
  // 0xDnnn
  
  /**
   * Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
   */
  void handle_DRW() {
    for(int y = 0; y < n(); y++) {
      int b = ram[iRegister + y];
      List<bool> bits = getBits(b);
      
      for(int x = 0; x < 8; x++) {
        if(bits[x]) display.togglePixel(Vx() + x, y + Vy());
      }
      
    }
  }
  
  // 0xENNN
  
  /**
   * Skip next instruction if key with the value of Vx is pressed.
   */
  void handle_SKP() {
    if(keys[Vx()]) {
      skip_instruction();
    }
  }
  
  /**
   * Skip next instruction if key with the value of Vx is not pressed.
   */
  void handle_SKNP() {
    if(!keys[Vx()]) {
      skip_instruction();
    }
  }
  
  /**
  * Set Vx = delay timer value.
  */
  void handle_LDDT() {
    registers[x()] = delayTimer;
  }
  
  /**
  * Set delay timer = Vx.
  */
  void handle_SETDT() {
    delayTimer = Vx();
  }
  
  /**
  * Set sound timer = Vx.
  */
  void handle_SETSOUND() {
    soundTimer = Vx();  
  }
  
  /**
   * Set I = I + Vx.
   */
  void handle_ADDI() {    
    iRegister += Vx();  
  }  

  /**
   * Store BCD representation of Vx in memory locations I, I+1, and I+2.
   */
  void handle_LDBCD() {   
    // http://www.dragonwins.com/domains/getteched/de248/bin2bcd.htm
    
    int DIGITS = 3;
    int VMAX = 100;
    
    List<int> bcd = new List<int>(3);
    
    int x = Vx();
    
    int i = DIGITS-1;
    int v = VMAX;
    
    while (i > 0) {
        bcd[i] = 0;
        while (x >= v) {
            x = x - v;
            bcd[i] = bcd[i] + 1;
        }
        v = v ~/ 10;
        i = i - 1;
    }
    bcd[0] = x;
    
    ram[iRegister] = bcd[0];
    ram[iRegister+1] = bcd[1];
    ram[iRegister+2] = bcd[2];
  }

  /**
   * Store registers V0 through Vx in memory starting at location I.
   */
  void handle_PUSH() {   
    for(int i = 0; i <= x(); i++) {
      ram[iRegister + i] = registers[i];  
    }
  }
  
  /**
   * Store registers V0 through Vx in memory starting at location I.
   */
  void handle_POP() {   
    for(int i = 0; i <= x(); i++) {
      registers[i] = ram[iRegister + i];  
    }
  }
  
}