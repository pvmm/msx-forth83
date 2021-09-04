\ test Screen 2

----

msx also forth definitions

decimal 2 8 thru

----

decimal 

: SC2TILE ( -- ) ( run-time: tile -- )
  create
  does> ( tile addr -- )
    swap 8 * 2dup
    8 ( from to len -- ) >vram
    2dup
    2048 + 8 ( from to len -- ) >vram
    4096 + 8 ( from to len -- ) >vram ;

----

hex

: SC2PALETTE ( -- ) ( run-time: tile -- )
  create
  does> ( tile param-addr -- )
    swap 8 * 2000 + 
    2dup
    8        ( from to-vram len -- ) >vram
    2dup
    800  + 8 ( from to-vram len -- ) >vram
    1000 + 8 ( from to-vram len -- ) >vram ;

----

hex

: SC2SPRITE ( -- )
  create
  does> ( pat# from-addr -- )
    swap 8 * #GRPPAT @ + 8 ( from-addr to-vram len -- ) >vram ;

----

decimal

variable _sprite_attr_draft 2 allot

: PUTSPRITE ( sprite# row col pat# color* -- )
  ['] _sprite_attr_draft 3 + C!
  ['] _sprite_attr_draft 2 + C!
  ['] _sprite_attr_draft 1+  C!
  1- ['] _sprite_attr_draft C!
  ['] _sprite_attr_draft SWAP 4 * #GRPATR @ + 4 ( from-addr to-vram len -- ) >vram ;

----

hex
1800 constant #VDPNAMETABLE

decimal
: PUTTILE ( tile row col -- )
  swap 32 * + #VDPNAMETABLE + vram! ;

decimal
: CLS ( tile -- )
  #VDPNAMETABLE 768 rot ( addr len char -- ) VRAMFILL ;

----

hex
sc2tile tileBK 18 c, 18 c, 3c c, ff c, ff c, 3c c, 18 c, 18 c,
sc2tile tile1 01 c, 01 c, 01 c, 01 c, 01 c, 6d c, 7f c, 7f c,
sc2tile tile2 00 c, c0 c, e0 c, 00 c, 00 c, b6 c, fe c, fe c,
sc2tile tile3 1f c, 16 c, 1f c, 1f c, 1f c, 16 c, 16 c, 01 c,
sc2tile tile4 f8 c, 68 c, f8 c, f8 c, f8 c, 68 c, 68 c, 80 c,

sc2palette pal0 62 c, 62 c, 62 c, 62 c, 62 c, 62 c, 62 c, 62 c,
sc2palette pal1 B2 c, B2 c, B2 c, B2 c, B2 c, B2 c, B2 c, B2 c,

----

decimal

: testinit
  0 cls   ( CLS with tile 0)
  setgrp  ( screen2 !!! 256x192x16 = 32x24 tiles)
  1 14 15 puttile
  2 14 16 puttile
  3 15 15 puttile
  4 15 16 puttile ;

----

decimal

: testtiles ( -- )
  0 tileBK  1 tile1
  2 tile2   3 tile3
  4 tile4  ;

: testpalettes ( -- )
  0 pal0  1 pal1
  2 pal1  3 pal1
  4 pal1  ;

: testwait ( -- )
  chget drop
  settxt ;
----

: test ( -- )
  testinit
  testtiles
  testpalettes
  testwait  ;
