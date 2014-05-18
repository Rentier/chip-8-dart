part of chip8;

class Mnemonics {
    final _value;
    
    const Mnemonics._internal(this._value);
    toString() => 'Enum.$_value';

    static const SYS = const Mnemonics._internal('SYS');
    static const CLS = const Mnemonics._internal('CLS');
    static const RET = const Mnemonics._internal('RET');
    
    static const JPABS = const Mnemonics._internal('JPABS');
    
    static const CALL = const Mnemonics._internal('CALL');
    
    static const SEBYTE = const Mnemonics._internal('SEBYTE');
    
    static const SNEBYTE = const Mnemonics._internal('SNEBYTE');
    
    static const SEREGISTER = const Mnemonics._internal('SEREGISTER');
    
    static const LDBYTE = const Mnemonics._internal('LDBYTE');
    
    static const ADDBYTE = const Mnemonics._internal('ADDBYTE');
    
    static const LDREGISTER = const Mnemonics._internal('LDREGISTER');
    static const OR = const Mnemonics._internal('OR');
    static const AND = const Mnemonics._internal('AND');
    static const XOR = const Mnemonics._internal('XOR');
    static const ADDREGISTER = const Mnemonics._internal('ADDREGISTER');
    static const SUB = const Mnemonics._internal('SUB');
    static const SHR = const Mnemonics._internal('SHR');
    static const SUBN = const Mnemonics._internal('SUBN');
    static const SHL = const Mnemonics._internal('SHL');
    
    static const SNE = const Mnemonics._internal('SNE');
    
    static const LDINSTR = const Mnemonics._internal('LDINSTR');
    
    static const JPREL = const Mnemonics._internal('JPREL');
    
    static const RND = const Mnemonics._internal('RND');
    
    static const DRW = const Mnemonics._internal('DRW');
    
    static const SKP = const Mnemonics._internal('SKP');
    static const SKNP = const Mnemonics._internal('SKNP');
    
    static const LDDT = const Mnemonics._internal('LDDT');
    static const LDKEY = const Mnemonics._internal('LDKEY');
    static const SETDT = const Mnemonics._internal('SETDT');
    static const SETSOUND = const Mnemonics._internal('SETSOUND');
    static const ADDI = const Mnemonics._internal('ADDI');
    static const LDSPRITE = const Mnemonics._internal('LDSPRITE');
    static const LDBCD = const Mnemonics._internal('LDBCD');
    static const PUSH = const Mnemonics._internal('PUSH');
    static const POP = const Mnemonics._internal('POP');
    
    
    
    
    
}
