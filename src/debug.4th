\ debugdevice

----

decimal 2 capacity 1- thru

----
hex code _debugmode ( byte -- )
	E1 C,  		\ POP HL
	7D C,  		\ LD A, L
	D3 C, 2E C,	\ OUT 2E, A
	00 C, 00 C,	\ NOP NOP
	next
end-code

: debugmode cr ." Sending byte " dup . ." to debug device at #2e..." _debugmode ;

----
hex code _debugc ( byte -- )
	E1 C,  		\ POP HL
	7D C,  		\ LD A, L
	D3 C, 2F C,	\ OUT 2F, A
	next
end-code

: debugc cr ." Sending " dup emit ."  to debug device at #2f..." _debugc ;
----
hex code _debugu ( u -- )
	E1 C,  		\ POP HL
	7C C,  		\ LD A, H
	D3 C, 2F C,	\ OUT 2F, A
	7D C,  		\ LD A, L
	D3 C, 2F C,	\ OUT 2F, A
	next
end-code

: debugu cr ." Sending " dup . ." ..." _debugu ;
----
: debugtest
	hex 1f debugmode
	decimal 65 debugc ;
