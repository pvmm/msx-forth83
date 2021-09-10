\ adventure game

----

decimal 2 capacity 1- thru

----

: WAIT  CHGET DROP INITXT ;

----
DECIMAL

variable 'FORCLR
variable 'BAKCLR
variable 'BDRCLR

: COLORS# ( S -- )
	#FORCLR @ 'FORCLR !
	#BAKCLR @ 'BAKCLR !
	#BDRCLR	@ 'BDRCLR ! ;

: COLORS@ ( -- S )
	'FORCLR @ FORCLR!
	'BAKCLR @ BAKCLR!
	'BDRCLR @ BDRCLR! 
	CHGCLR ;
----
: \nul 2dup + 0 swap c! ;
: push"  decimal 34 parse \nul ;
----
hex code _clrscr ( -- )
	E1 C,				\ POP HL
	DD C, 2a C, 6a C, 39 C,		\ LD IX, (0x396a)
	CD C, 59 C, 01 C,		\ CALL 0x159
	next
end-code
----
: clrscr push" " \nul drop _clrscr ;
----
hex code _line ( addr -- )
	E1 C,				\ POP HL
	DD C, 2a C, 8a C, 39 C,		\ LD IX, (0x398a)
	CD C, 59 C, 01 C,		\ CALL 0x159
	next
end-code
----
DECIMAL

: COLORS! ( f b b -- )
	15 FORCLR! 1 BAKCLR! 2 BDRCLR! CHGCLR ;
----
DECIMAL

: TEST-ADV
	COLORS#
	COLORS!
	push" " .S
	WAIT COLORS@ ;

\ 2 64 64 1 15 PUTSPRITE
