Z80 ASSEMBLER
----

decimal 2 capacity 1- thru

----
HEX CONTEXT ASSEMBLER
----
\ register stack and functions
variable reg.p
variable reg.0 1 allot           \ maximum of 2 places
reg.0 reg.p !                    \ point reg.p to register stack
: 'reg  reg.p ;                  \ top register stack position
: reg@  reg.p @ ;                \ top register stack value
: reg!  reg.p ! ;                \ store on register stack

: >registers                     \ store register
  'reg reg.0 - 2 > if abort" Register stack overflow" then
  reg@ ! reg@ 2+ reg! ;
: registers>                     \ restore register
  reg.0 'reg - 0= if abort" Register stack underflow" then
  'reg 2- reg! 'reg @ ; 
: ?reg.empty 'reg reg.0 - 0= ;   \ if register stack empty?
: reg>nul  registers> drop ;     \ drop from register stack
----
\ 8 and 16 bit register identifiers
000 constant reg.B    ( OPCODE+00 )
001 constant reg.C    ( OPCODE+01 )
002 constant reg.D    ( OPCODE+02 )
003 constant reg.E    ( OPCODE+03 )
004 constant reg.H    ( OPCODE+04 )
005 constant reg.L    ( OPCODE+05 )
006 constant reg.(HL) ( OPCODE+06 )
007 constant reg.A    ( OPCODE+07 )
100 constant reg.BC   ( OPCODE+00 )
110 constant reg.DE   ( OPCODE+10 )
120 constant reg.HL   ( OPCODE+20 )
130 constant reg.AF   ( OPCODE+30 )
1DD constant reg.IX   ( 0DD, OPCODE+20 )
1FD constant reg.IY   ( 0FD, OPCODE+20 )
----
\ 8 and 16 bit register identifiers (cont)
200 constant reg.(BC) ( OPCODE+00 )
210 constant reg.(DE) ( OPCODE+10 )
----
\ registers as CODE parameters
: A     0ffff reg.A    >registers ;
: B     0ffff reg.B    >registers ;
: C     0ffff reg.C    >registers ;
: D     0ffff reg.D    >registers ;
: E     0ffff reg.E    >registers ;
: H     0ffff reg.H    >registers ;
: L     0ffff reg.L    >registers ;
: (HL)  0ffff reg.(HL) >registers ;
: BC    0ffff reg.BC   >registers ;
: DE    0ffff reg.DE   >registers ;
: HL    0ffff reg.HL   >registers ;
: AF    0ffff reg.AF   >registers ;
: IX    0ffff reg.IX   >registers ;
: IY    0ffff reg.IY   >registers ;
----
\ register as CODE parameters (cont)
: (BC)  0ffff reg.(BC) >registers ;
: (DE)  0ffff reg.(DE) >registers ;
----
\ detect and check type of register
: ?reg  
  ?reg.empty not 0ffff = and ;
: ?reg8
  ?reg.empty not 0ffff = and reg@ 8 < and reg@ 0 >= and ;
: ?reg16
  ?reg.empty not 0ffff = and reg@ 100 and and ;

\ consume and convert register identifier into a value
: reg>r  register> 0FF and ; ( RegID -- r )
----
\ opcode type
: 1MI  create C, does> C@ C, ;
: 2MI  create C, does> C@ + C, ;
: 3MI  create C, does> C@ SWAP 8* + C, ;
: 4MI  create C, does> C@ C, C, ;
: 5MI  create C, does> C@ C, , ;
----
\ _: 8 bit register or value
\ __: 16 bit register or value
\ r: 8 bit register
\ rr: 16 bit register
\ byte: 8 bit value
\ word: 16 bit value

000 1MI (NOP)          0C1 2MI (POP)        0C5 2MI (PUSH)
00A 2MI (LDA,(rr))     040 2MI (LDB,r)      048 2MI (LDC,r)
050 2MI (LDD,r)        058 2MI (LDE,r)      060 2MI (LDH,r)
068 2MI (LDL,r)        070 2MI (LD(IX+i),_) 077 2MI (LD(HL),r)
078 2MI (LDA,r)        03E 4MI (LDA,byte)   006 4MI (LDB,byte)
00E 4MI (LDC,byte)     016 4MI (LDD,byte)   01E 4MI (LDE,byte)
026 4MI (LDH,byte)     02E 4MI (LDL,byte)   036 4MI (LD(HL),byte)
002 1MI (LD(BC),A)     012 1MI (LD(DE),A)   032 4MI (LD(word),A)
03A 4MI (LDA,(word))   031 2MI (LDSP,word)
----
\ detect type of LD by its parameters
: LD ( -- )
  ?reg8 if LDr then
  ?reg16 if LDrr else
  LDw then ;
----
\ transfer 8 bits to/from register
: LDr  0ffff = not if abort" Operator not a register" then
  drop
  reg@ A    = if reg>nul (LDA) then
  reg@ B    = if reg>nul (LDB) then
  reg@ C    = if reg>nul (LDC) then
  reg@ D    = if reg>nul (LDD) then
  reg@ E    = if reg>nul (LDE) then
  reg@ H    = if reg>nul (LDH) then
  reg@ L    = if reg>nul (LDL) then
  reg@ (HL) = if reg>nul (LD(HL)) else
  abort" Invalid operator" then ;
----
\ transfer 16 bits to/from register
: LDrr  0ffff = not if abort" Operator not a register" then
  drop
  reg@ (HL) = if reg>nul (LD(HL)) then
  reg@ (IX) = if reg>nul (LD(IX)) then
  reg@ (IY) = if reg>nul (LD(IY)) then
  reg@ BC   = if reg>nul (LDBC) then
  reg@ DE   = if reg>nul (LDDE) then
  reg@ HL   = if reg>nul (LDHL) then
  reg@ SP   = if reg>nul (LDSP) then
  reg@ IX   = if reg>nul (LDIX) then
  reg@ IY   = if reg>nul (LDIY) else
                 reg>nul (LD(word)) then ;
----
: LDw ;

