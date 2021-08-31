HEX

(store shapes)
SC2TILE TREETOP1 0F C,3B C,77 C,5F C,7F C,6F C,3F C,18 C,
SC2TILE TREETOP2 F8 C,FC C,FE C,FE C,E6 C,FE C,FC C,B8 C,
SC2TILE TREETRU1 03 C,03 C,03 C,03 C,03 C,03 C,0F C,08 C,
SC2TILE TREETRU2 B0 C,C0 C,80 C,80 C,80 C,C0 C,80 C,80 C,

(store palettes)
SC2PALETTE TREEPAL1 02 C, 02 C, 02 C, 02 C, 02 C, 02 C, 02 C,
SC2PALETTE TREEPAL2 06 C, 06 C, 06 C, 06 C, 06 C, 06 C, 06 C,
SC2PALETTE TREEPAL3 02 C, 06 C, 06 C, 06 C, 06 C, 06 C, 06 C,

: SET_TILES
    1 TREETOP1
    2 TREETOP2
    3 TREETRU1
    4 TREETRU2

: SET_PALS
    1 TREEPAL1
    2 TREEPAL1
    3 TREEPAL2
    4 TREEPAL3
    
: PUT_TREE1 (ROW COL -- )
    1 2DUP 2 2DUP 3 2DUP 4 .S
    ROT 1+ ROT 1+ PUTTILE   (4: TREETRU2)
    ROT 1+ ROT    PUTTILE   (3: TREETRU1)
    ROT ROT 1+    PUTTILE   (2: TREETOP2)
    ROT ROT       PUTTILE ; (1: TREETOP1)

: WAIT
    CHGET DROP
    SETTEXT ;
    
: RUN
    0 CLS
    SETGRP
    14 15 PUT_TREE
    WAIT ;
    
RUN
