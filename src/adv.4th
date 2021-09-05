\ adventure game

----

decimal 2 capacity 1- thru

----
HEX

( Store shapes )
SC2TILE TREETOP1  0F C, 3B C, 77 C, 5F C, 7F C, 6F C, 3F C, 18 C,
SC2TILE TREETOP2  F8 C, FC C, F6 C, FA C, FE C, FA C, EC C, B8 C,
SC2TILE TREETRU1  03 C, 03 C, 03 C, 03 C, 03 C, 03 C, 0F C, 08 C,
SC2TILE TREETRU2  B0 C, C0 C, 80 C, 80 C, 80 C, C0 C, 80 C, 80 C,

----
HEX

( Store palettes )
SC2PALETTE TREEPAL1 21 C, 21 C, 21 C, 21 C, 21 C, 21 C, 21 C, 21 C,
SC2PALETTE TREEPAL2 61 C, 61 C, 61 C, 61 C, 61 C, 61 C, 61 C, 61 C,
SC2PALETTE TREEPAL3 21 C, 61 C, 61 C, 61 C, 61 C, 61 C, 61 C, 61 C,

----
HEX

( Store sprites )
SC2SPRITE SPRITE1 18 C, 18 C, 7E C, BD C, BD C, 24 C, 24 C, 66 C,
                  ff C, e8 C, 8e C, ad C, 71 C, a4 C, 24 C, b6 C,
                  ff C, e8 C, 8e C, ad C, 71 C, a4 C, 24 C, b6 C,
                  ff C, e8 C, 8e C, ad C, 71 C, a4 C, 24 C, b6 C,

----
DECIMAL

: SET_TILES
	1 TREETOP1
	2 TREETOP2
	3 TREETRU1
	4 TREETRU2 ;

----
DECIMAL

: SET_PALS
	1 TREEPAL1
	2 TREEPAL1
	3 TREEPAL2
	4 TREEPAL3 ;

----
DECIMAL

: SET_SPRITES
	0 SPRITE1 ;

----
DECIMAL

: PUT_TREE1 ( row col -- )
	2DUP 2DUP 2DUP
	1 ROT ROT PUTTILE		( 1: TREETOP1 )
	2 ROT ROT 1+ PUTTILE		( 2: TREETOP2 )
	3 ROT 1+ ROT PUTTILE 	 	( 3: TREETRU1 )
	4 ROT 1+ ROT 1+ PUTTILE		( 4: TREETRU2 ) ;

----

: WAIT
	CHGET DROP
	INITXT ;

----
DECIMAL

variable pv_FORCLR
variable pv_BAKCLR
variable pv_BDRCLR

: COLORS# ( S -- )
	#FORCLR @ pv_FORCLR !
	#BAKCLR @ pv_BAKCLR !
	#BDRCLR	@ pv_BDRCLR ! ;

: COLORS@ ( -- S )
	pv_FORCLR @ FORCLR!
	pv_BAKCLR @ BAKCLR!
	pv_BDRCLR @ BDRCLR! 
	CHGCLR ;
----
DECIMAL

: COLORS! ( f b b -- )
	15 FORCLR! 1 BAKCLR! 2 BDRCLR! CHGCLR ;
 
: SP16 ( 16k VRAM, screen on, vint, 16x16 sprites, no mag)
	243 1 VDPREG! ;

----
DECIMAL

: TEST-ADV
	COLORS#
	COLORS!
	INIGRP SP16 0 CLS
	SET_TILES SET_PALS SET_SPRITES
	14 15 PUT_TREE1
	14 13 PUT_TREE1
	0 16 16 0 15 PUTSPRITE
	WAIT COLORS@ ;

