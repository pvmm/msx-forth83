\ BASIC routines

----

decimal 2 capacity 1- thru

----
hex code _clrscr2 ( -- )
	E1 C,				\ POP HL
        \ fd C, 2a c, c0 c, fc c,         \ LD IY, (EXPTBL-1)
	DD C, 2a C, 6a C, 39 C,		\ LD IX, (0x396a) ; 0x396a = CLS
	CD C, 59 C, 01 C,		\ CALL 0x159
	next
end-code
----
hex code _RC0
f3 c, 3a c, c1 c, fc c,	\ DI; LD A, (0xFCC1)
f5 c, 21 c, 00 c, 00 c,	\ PUSH AF; LD HL, 0
cd c, 24 c, 00 c,	\ CALL 0x24      ; ROM page 0
dd c, 2a c, 6a c, 39 c,	\ LD IX, (0x396a) ; 0x396a = CLS
cd c, 59 c, 01 c,	\ CALL 0x159
3a c, 41 c, f3 c,	\ LD A, (0xF341) ; RAM page 0
26 c, 00 c,		\ LD H, 00
cd c, 24 c, 00 c,	\ CALL 0x24
41 A mvi
2f out
next
end-code
----
hex code _RC1
f3 c, 3a c, c1 c, fc c,	\ DI; LD A, (0xFCC1)
f5 c, 21 c, 00 c, 00 c,	\ PUSH AF; LD HL, 0
cd c, 24 c, 00 c,	\ CALL 0x24      ; ROM page 0
f1 c, 26 c, 40 c,	\ POP AF; LD H, 0x40
cd c, 24 c, 00 c,	\ CALL 0x24      ; ROM page 1
dd c, 2a c, 6a c, 39 c,	\ LD IX, (0x396a) ; 0x396a = CLS
cd c, 59 c, 01 c,	\ CALL 0x159
3a c, 41 c, f3 c,	\ LD A, (0xF341) ; RAM page 0
26 c, 00 c,		\ LD H, 00
cd c, 24 c, 00 c,	\ CALL 0x24
3a c, 42 c, f3 c,	\ LD A, (0xF342) ; RAM page 1
26 c, 00 c,		\ LD H, 0x40
cd c, 24 c, 00 c, fb c,	\ CALL 0x24; EI
next
end-code
----
hex code _RUNCOD2 ( -- )
	DB c, A8 c,		\ IN A,(&HA8)  ; Le configuração de slots
	F5 c,			\ PUSH AF      ; Salva configuração
	3E c, A0 c,		\ LD A,SLOT    ; Muda para slot 0
	D3 c, A8 c,		\ OUT (&HA8),A ; as página 0 e 1
	\ ROTINA
	F1 c,			\ POP AF       ; Recupera configuração
	D3 c, A8 c,		\ OUT (&HA8),A ; de slots
	next
end-code
----
\ hex code _lin ( addr -- )
\	E1 C,				\ POP HL
\	DD C, 2a C, 8a C, 39 C,		\ LD IX, (0x398a)
\	CD C, 59 C, 01 C,		\ CALL 0x159
\	next
\ end-code
----
