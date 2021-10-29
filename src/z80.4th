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
\ Undoing C, and , when errors are detected
: undoC,  dp @ 1- dp ! ;
: undo,   dp @ 2- dp ! ;

\ Split integer into two 8-bit numbers ( n -- c c )
: splitc  dup 8RSHIFT swap 0FF and ;

\ Join 8-bit numbers into integer
: join  dup FF00 and if abort" 8-bit value expected #1" then
    swap dup FF00 and if abort" 8-bit value expected #2" then
    8LSHIFT \+ ;
----
\ operand stack and functions
variable opr.p0 2 allot         \ maximum of 3 places
variable opr.p opr.p0 opr.p !   \ point opr.p to operand stack
: 'opr  opr.p @ ;               \ top operand stack position
: opr@  opr.p @ 2- @ ;          \ get top operand stack value
: reg@mask  opr@ 0F7 and ;      \ convert top value to register
: opr!  opr.p ! ;               \ store on operand stack

\ empty operand stack
: operands>nul  opr.p0 opr! ;

\ store register
: >operands
  'opr opr.p0 - 4 > if
    operands>nul abort" Operand stack overflow" then
  'opr ! 'opr 2+ opr! ;
----
\ operand stack and functions (cont)
\ restore register
: operands>
  'opr opr.p0 - 0= if abort" Operand stack underflow" then
  opr@ 'opr 2- opr! ;

\ drop single register from register stack
: opr>nul  drop operands> drop ;

\ is register stack empty?
: ?opr.empty 'opr opr.p0 - 0= ;

\ stack placeholder for register and address
0fffe constant >REG<    0fffd constant >ADDR<
----
variable (DEBUG) 1 (DEBUG) !
variable LCOUNT 0 LCOUNT !
: ()  (DEBUG) @ if LCOUNT @ 28 emit 0 u.r 29 emit then
      LCOUNT @ 1+ LCOUNT ! ;
----
\ TODO: store last depth for comparisons
variable address 0 address !
: {  address @ if abort" Nesting } not allowed" else 1 address ! then ;
: }  depth 0= if 0 address ! abort" Missing address" then
     address @ if 0 address ! >operands >ADDR<
     else abort" Matching } is missing" then ;

\ First parameter position in the operand stack
variable firstparam -1 firstparam !

\ Locate first parameter in the operand stack
: >loc<  depth firstparam ! ;

\ Reset parameter position when done
: reset!  -1 firstparam ! ;
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
: A     >loc< reg.A        >operands >REG< ;
: B     >loc< reg.B        >operands >REG< ;
: C     >loc< reg.C        >operands >REG< ;
: D     >loc< reg.D        >operands >REG< ;
: E     >loc< reg.E        >operands >REG< ;
: H     >loc< reg.H        >operands >REG< ;
: L     >loc< reg.L        >operands >REG< ;
: (HL)  >loc< reg.(HL)     >operands >REG< ;
: BC    >loc< reg.BC       >operands >REG< ;
: DE    >loc< reg.DE       >operands >REG< ;
: HL    >loc< reg.HL       >operands >REG< ;
----
\ register as CODE parameters (cont)
: AF    >loc< reg.AF       >operands >REG< ;
: IX    >loc< reg.IX       >operands >REG< ;
: IX+   >loc< reg.IX join  >operands >REG< ;
: IY    >loc< reg.IY       >operands >REG< ;
: IY+   >loc< reg.IY join  >operands >REG< ;
: (BC)  >loc< reg.BC       >operands >REG< ;
: (DE)  >loc< reg.DE       >operands >REG< ;
----
\ Detect and check type of register
: ?reg  ?opr.empty if 0 else dup >REG< = then ;
: ?reg8
  ?opr.empty if 0 else dup >REG< = opr@ 8 < and opr@ 0 >= and
  then ;
: ?reg16
  ?opr.empty if 0 else ?reg8 not then ;
: ?(reg16)
  ?opr.empty if 0 else dup >REG< = opr@ 200 and and then ;
: ?reg@ix/y  ?reg if opr@ 0DD and 0DD >= else 0 then ;

\ Consume and convert register identifier into a value
: opr>r  drop operands> 0F7 and ; ( >REG< -- r )

\ Consume and convert IX or IY register into rr+index
: opr>ix+i  drop operands> splitc ;
----
\ Sum operator used on IX + c or c + IY
: + ( param1 param2 -- >REG< ) 
    ?reg@ix/y if opr>r join >operands >REG< exit then swap
    ?reg@ix/y if opr>r join >operands >REG< else
    abort" IX + value or IY + value expected" then ;
----
\ opcode type
: 1MI  create C, does> C@ C, reset! ;
: 2MI  create C, does> C@ \+ C, reset! ;
: 3MI  create C, does> C@ \+ C, C, reset! ;
: 4MI  create C, does> C@ C, C, reset! ;
: 5MI  create C, does> C@ C, C, C, reset! ;
\ 5MI  create C, does> C@ C, , reset! ;
: 6MI  create C, does> C@ C, C, reset! ;
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
: (LDA,*)  ?reg8 if opr>r (LDA,r) exit then
           opr@ reg.HL = if opr>nul reg.(HL) (LDA,r) exit then
           ?reg16 if opr>r (LDA,(__)) else (LDA,byte) then ;
: (LDB,*)  ?reg8 if opr>r (LDB,r) exit then
           opr@ reg.HL = if opr>nul reg.(HL) (LDB,r) exit then
           ?reg@ix/y if opr>ix+i C, (LDB,(__)) exit then
           (LDB,byte) ;
: (LDC,*)  ?reg8 if opr>r (LDC,r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LDC,r) else
           (LDC,byte) then then ;
: (LDD,*)  ?reg8 if opr>r (LDD,r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LDD,r) else
           (LDD,byte) then then ;
----
: (LDE,*)  ?reg8 if opr>r (LDE,r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LDE,r) else
           (LDE,byte) then then ;
: (LDH,*)  ?reg8 if opr>r (LDH,r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LDH,r) else
           (LDH,byte) then then ;
: (LDL,*)  ?reg8 if opr>r (LDL,r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LDL,r) else
           (LDL,byte) then then ;
: (LD(HL),*)  ?reg8 if opr>r (LD(HL),r) else
           opr@ reg.HL = if opr>nul reg.(HL) (LD(HL),r) else
           (LD(HL),byte) then then ;
----
: (LD(IX+_),*)
  swap
  ?reg if
    ?reg16 if
      undoC, abort" 8-bit register expected as #1"
    else
      opr>r (LD(IX+_),r)
    then
  else
    dup FF00 and if undoC, abort" 8-bit value expected as #2"
    then swap (LD(IX+_),byte)
  then ;
----
: (LDr,*)
  opr@ reg.A    = if opr>nul (LDA,*) exit then
  opr@ reg.B    = if opr>nul (LDB,*) exit then
  opr@ reg.C    = if opr>nul (LDC,*) exit then
  opr@ reg.D    = if opr>nul (LDD,*) exit then
  opr@ reg.E    = if opr>nul (LDE,*) exit then
  opr@ reg.H    = if opr>nul (LDH,*) exit then
  opr@ reg.L    = if opr>nul (LDL,*) exit then
  opr@ reg.(HL) = if opr>nul (LD(HL),*) exit then ;
: (LDrr,*)
  ?reg@ix/y not if abort" Not implemented yet"
                else opr>ix+i C, (LD(IX+_),*) then ;
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
