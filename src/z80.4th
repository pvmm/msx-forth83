Z80 ASSEMBLER
----

decimal 2 capacity 1- thru

----
only forth also
vocabulary Z80

\ save the current context
context @ avoc !

\ z/code is Z80 version of CODE
: z/code  create hide here dup 2- ! context @ avoc ! z80 ;
----
\ set Z80 context
z80 definitions hex

\ old sum word renamed
: \+ + ;

\ Set FORTH context
: [forth]  forth context ! ;

\ Restore previous context
: [prev]  avoc @ context ! ;

\ Define Z80 version of END-CODE
: z/end-code  avoc @ context ! reveal ;
----
\ Undoing C, and ,
: undoC,  dp @ 1- dp ! ;
: undo,   dp @ 2- dp ! ;

\ Split integer into two 8-bit numbers ( n -- c c )
: splitc  dup 8RSHIFT swap 0FF and ;

\ Join 8-bit numbers into integer
: join  dup FF00 and if abort" 8-bit value expected #1" then
    swap dup FF00 and if abort" 8-bit value expected #2" then
    8LSHIFT \+ ;
----
\ register stack and functions
variable reg.0 2 allot          \ maximum of 3 places
variable reg.p reg.0 reg.p !    \ point reg.p to register stack
: 'reg  reg.p @ ;               \ top register stack position
: reg@  reg.p @ 2- @ ;          \ get top register stack value
: reg@mask  reg@ 0F7 and ;      \ make top register valid
: reg!  reg.p ! ;               \ store on register stack

\ empty register stack
: registers>nul  reg.0 reg! ;

\ store register
: >registers
  'reg reg.0 - 4 > if
    registers>nul abort" Register stack overflow" then
  'reg ! 'reg 2+ reg! ;
----
\ register stack and functions (cont)
\ restore register
: registers>
  'reg reg.0 - 0= if abort" Register stack underflow" then
  reg@ 'reg 2- reg! ;

\ drop single register from register stack
: reg>nul  drop registers> drop ;

\ is register stack empty?
: ?reg.empty 'reg reg.0 - 0= ;

\ placeholder for the register (in the stack)
0fffe constant ph
----
\ 8 and 16 bit register identifiers
000 constant reg.B      ( OPCODE+00 )
001 constant reg.C      ( OPCODE+01 )
002 constant reg.D      ( OPCODE+02 )
003 constant reg.E      ( OPCODE+03 )
004 constant reg.H      ( OPCODE+04 )
005 constant reg.L      ( OPCODE+05 )
006 constant reg.(HL)   ( OPCODE+06 )
007 constant reg.A      ( OPCODE+07 )
008 constant reg.BC     ( OPCODE+00 )
010 constant reg.DE     ( OPCODE+10 )
020 constant reg.HL     ( OPCODE+20 )
030 constant reg.(word) ( OPCODE+30 )
030 constant reg.AF     ( OPCODE+30 )
0DD constant reg.IX     ( 0DD, OPCODE+20 )
0FD constant reg.IY     ( 0FD, OPCODE+20 )
----
\ 8 and 16 bit register identifiers (cont)
200 constant reg.(BC)   ( OPCODE+00 )
210 constant reg.(DE)   ( OPCODE+10 )
----
\ registers as CODE parameters
: A     reg.A        >registers ph ;
: B     reg.B        >registers ph ;
: C     reg.C        >registers ph ;
: D     reg.D        >registers ph ;
: E     reg.E        >registers ph ;
: H     reg.H        >registers ph ;
: L     reg.L        >registers ph ;
: (HL)  reg.(HL)     >registers ph ;
: BC    reg.BC       >registers ph ;
: DE    reg.DE       >registers ph ;
: HL    reg.HL       >registers ph ;
----
\ register as CODE parameters (cont)
: AF    reg.AF       >registers ph ;
: IX    reg.IX       >registers ph ;
: IX+   reg.IX join  >registers ph ;
: IY    reg.IY       >registers ph ;
: IY+   reg.IY join  >registers ph ;
: (BC)  reg.BC       >registers ph ;
: (DE)  reg.DE       >registers ph ;
----
\ Detect and check type of register
: ?reg  ?reg.empty if 0 else dup ph = then ;
: ?reg8
  ?reg.empty if 0 else dup ph = reg@ 8 < and reg@ 0 >= and
  then ;
: ?reg16
  ?reg.empty if 0 else ?reg8 not then ;
: ?(reg16)
  ?reg.empty if 0 else dup ph = reg@ 200 and and then ;
: ?reg@ix/y  ?reg if reg@ 0DD and 0DD >= else 0 then ;

\ Consume and convert register identifier into a value
: reg>r  drop registers> 0FF and ; ( ph -- r )

\ Consume and convert IX or IY register into rr+index
: reg>ix+i  drop registers> splitc ;
----
\ Sum operator used on IX + c or c + IY
: + ( param1 param2 -- ph ) 
    ?reg@ix/y if reg>r join >registers ph exit then swap
    ?reg@ix/y if reg>r join >registers ph else
    abort" IX + value or IY + value expected" then ;
----
\ opcode type
: 1MI  create C, does> C@ C, ;
: 2MI  create C, does> C@ \+ C, ;
: 3MI  create C, does> C@ \+ C, C, ;
: 4MI  create C, does> C@ C, C, ;
: 5MI  create C, does> C@ C, C, C, ;
\ 5MI  create C, does> C@ C, , ;
: 6MI  create C, does> C@ C, C, ;
----
\ opcodes 1/2
\ *: any parameter type
\ _: 8 bit register or value
\ __: 16 bit register or value
\ r: 8 bit register
\ rr: 16 bit register
\ byte: 8 bit value
\ word: 16 bit value
000 1MI (NOP)       0C1 2MI (POP)        0C5 2MI (PUSH)
078 2MI (LDA,r)     03E 4MI (LDA,byte)   00A 2MI (LDA,(__))
040 2MI (LDB,r)     006 4MI (LDB,byte)   046 4MI (LDB,(__))
048 2MI (LDC,r)     00E 4MI (LDC,byte)   04E 4MI (LDC,(__))
050 2MI (LDD,r)     016 4MI (LDD,byte)   056 4MI (LDD,(__))
058 2MI (LDE,r)     01E 4MI (LDE,byte)   05E 4MI (LDE,(__))
060 2MI (LDH,r)     066 4MI (LDH,(__))   068 2MI (LDL,r)
06E 4MI (LDL,(__))  070 3MI (LD(IX+_),r) 077 2MI (LD(HL),r)
----
\ opcodes 2/2
0C3 4MI JP
026 4MI (LDH,byte)   02E 4MI (LDL,byte)  036 4MI (LD(HL),byte)
002 1MI (LD(BC),A)   012 1MI (LD(DE),A)  032 4MI (LD(word),A)
03A 4MI (LDA,(word)) 031 2MI (LDSP,word) 076 5MI (LD(IX+_),byte)
----
: (LDA,*)  ?reg8 if reg>r (LDA,r) exit then
           reg@ reg.HL = if reg>nul reg.(HL) (LDA,r) exit then
           ?reg16 if reg>r (LDA,(__)) else (LDA,byte) then ;
: (LDB,*)  ?reg8 if reg>r (LDB,r) exit then
           reg@ reg.HL = if reg>nul reg.(HL) (LDB,r) exit then
           ?reg@ix/y if reg>ix+i C, (LDB,(__)) exit then
           (LDB,byte) ;
: (LDC,*)  ?reg8 if reg>r (LDC,r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LDC,r) else
           (LDC,byte) then then ;
: (LDD,*)  ?reg8 if reg>r (LDD,r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LDD,r) else
           (LDD,byte) then then ;
----
: (LDE,*)  ?reg8 if reg>r (LDE,r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LDE,r) else
           (LDE,byte) then then ;
: (LDH,*)  ?reg8 if reg>r (LDH,r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LDH,r) else
           (LDH,byte) then then ;
: (LDL,*)  ?reg8 if reg>r (LDL,r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LDL,r) else
           (LDL,byte) then then ;
: (LD(HL),*)  ?reg8 if reg>r (LD(HL),r) else
           reg@ reg.HL = if reg>nul reg.(HL) (LD(HL),r) else
           (LD(HL),byte) then then ;
----
: (LD(IX+_),*)
  swap
  ?reg if
    ?reg16 if
      undoC, abort" 8-bit register expected as #1"
    else
      reg>r (LD(IX+_),r)
    then
  else
    dup FF00 and if undoC, abort" 8-bit value expected as #2"
    then swap (LD(IX+_),byte)
  then ;
----
: (LDr,*)
  reg@ reg.A    = if reg>nul (LDA,*) exit then
  reg@ reg.B    = if reg>nul (LDB,*) exit then
  reg@ reg.C    = if reg>nul (LDC,*) exit then
  reg@ reg.D    = if reg>nul (LDD,*) exit then
  reg@ reg.E    = if reg>nul (LDE,*) exit then
  reg@ reg.H    = if reg>nul (LDH,*) exit then
  reg@ reg.L    = if reg>nul (LDL,*) exit then
  reg@ reg.(HL) = if reg>nul (LD(HL),*) exit then ;
: (LDrr,*)
  ?reg@ix/y not if abort" Not implemented yet"
                else reg>ix+i C, (LD(IX+_),*) then ;
----
: (LDw) ;

\ detect type of LD by its parameters
: LD ( param1 param2 -- )
  ?reg8  if (LDr,*) exit then
  ?reg16 if (LDrr,*) else (LDw) then ;
----
: next  >next JP ;
----
\ Revert to FORTH context
FORTH DEFINITIONS
