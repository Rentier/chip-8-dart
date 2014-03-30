import 'dart:typed_data';

class Chip8 {
  // http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
  
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
  ByteBuffer registers;
  
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
  
  Chip8() {
    ram = new Uint8List(4096).buffer;
    registers = new Uint8List(16).buffer;
    iRegister = 0;    
    delayTimerRegister = 0;
    soundTimerRegister = 0;
    programCounter = 0;
    stackPointer = 0;
  }
  
  decodeAndDispatch() {
    
  }
  
  
  
}