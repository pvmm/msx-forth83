\ adventure game

----

decimal 2 capacity 1- thru

----
hex

( Store shapes )
SC2TILE TREETOP1 00f C, 03b C, 077 C, 05f C, 07f C, 06f C, 03f C, 018 C,
SC2TILE TREETOP2 0f8 C, 0fc C, 0f6 C, 0fa C, 0fe C, 0fa C, 0ec C, 0b8 C,
SC2TILE TREETRU1 003 C, 003 C, 003 C, 003 C, 003 C, 003 C, 00f C, 008 C,
SC2TILE TREETRU2 0b0 C, 0c0 C, 080 C, 080 C, 080 C, 0c0 C, 080 C, 080 C,

----
hex

( Store palettes )
SC2PALETTE TREEPAL1 021 C, 021 C, 021 C, 021 C, 021 C, 021 C, 021 C, 021 C,
SC2PALETTE TREEPAL2 061 C, 061 C, 061 C, 061 C, 061 C, 061 C, 061 C, 061 C,
SC2PALETTE TREEPAL3 021 C, 061 C, 061 C, 061 C, 061 C, 061 C, 061 C, 061 C,

----
hex

( Store sprites )
SC2SPRITE SPRIT1 018 C, 018 C, 07E C, 0bd C, 0bd C, 024 C, 024 C, 066 C,
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 
SC2SPRITE SPRIT2 0e7 C, 0e7 C, 081 C, 042 C, 042 C, 0db C, 0db C, 099 C,
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 
	ff c, ff c, ff c, ff c, ff c, ff c, ff c, ff c, 

----
decimal

: SET_TILES
	1 TREETOP1
	2 TREETOP2
	3 TREETRU1
	4 TREETRU2 ;
----
decimal

: SET_PALS
	1 TREEPAL1
	2 TREEPAL1
	3 TREEPAL2
	4 TREEPAL3 ;

----
decimal

: PUT_TREE1 ( row col -- )
	2DUP 2DUP 2DUP
	1 ROT ROT PUTTILE		( 1: TREETOP1 )
	2 ROT ROT 1+ PUTTILE		( 2: TREETOP2 )
	3 ROT 1+ ROT PUTTILE 	 	( 3: TREETRU1 )
	4 ROT 1+ ROT 1+ PUTTILE		( 4: TREETRU2 ) ;

----

: WAIT  CHGET DROP INITXT ;

----
decimal

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
decimal

: COLORS! ( f b b -- )
	15 FORCLR! 1 BAKCLR! 2 BDRCLR! CHGCLR ;
----
hex

: SP16 \ 16k vram, screen on, 16x16 sprite, no mag
	e2 1 VDPREG! ;

: SP8  \ 16k vram, screen on, 8x8 sprite, no mag
	e0 1 VDPREG! ;
----
decimal

: TEST-ADV
	COLORS#
	COLORS!
	INIGRP
	0 CLS SP16
	SET_TILES SET_PALS
	14 15 PUT_TREE1
	14 13 PUT_TREE1
	0 SPRIT1 1 SPRIT2 ( move pattern to vram )
	0 50 0 0 15 PUTSPRITE
	1 0 50 1 14 PUTSPRITE
	WAIT COLORS@ ;
----
decimal

: TEST-ADV8
	COLORS#
	COLORS!
	INIGRP
	0 CLS SP8
	SET_TILES SET_PALS
	14 15 PUT_TREE1
	14 13 PUT_TREE1
	0 SPRIT1 1 SPRIT2 ( move pattern to vram )
	0 50 0 0 14 PUTSPRITE
	1 0 50 1 14 PUTSPRITE
	WAIT COLORS@ ;
----
