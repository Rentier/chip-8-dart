library chip8_test;

import 'package:unittest/unittest.dart'; 
import 'package:chip8/chip8.dart';

part 'disassembler_test.dart';
part 'interpreter_test.dart';
part 'display_test.dart';

main() {
  test_display();  
  test_disassembler();  
  test_interpreter();
}
