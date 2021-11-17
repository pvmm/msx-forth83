Testing Z80 assembler
----

decimal 2 capacity 1- thru

----
z80 definitions hex

: memcmp (S addr1 addr2 len -- )
 ." comparing" 0 ?do over @ over @ <>
 if ." address:" 1 u.r ." differ, I=" I 0 u.r true abort then
 1+ swap 1+ swap ." ." loop ." match!" ;

\ overwrite ED editor with hex number 0xED
0ed constant ed
----
\ LD binary 1/4
CREATE (LD.bin)
   \ (LDA,*)
   7F c, 78 c, 79 c, 7A c, 7B c, 7C c, 7D c, 7E c, 7E c, 0A c,
   0A c, 1A c, 1A c, 3A c, FF c, FF c, DD c, 7E c, 00 c, FD c,
   7E c, 01 c, 3E c, 01 c,
   \ (LDB,*) tests (24)
   47 c, 40 c, 41 c, 42 c, 43 c, 44 c, 45 c, 46 c, 46 c, DD c,
   46 c, 02 c, FD c, 46 c, 03 c, 06 c, 02 c, 
   \ (LDc,*) tests (41)
   4F c, 48 c, 49 c, 4A c, 4B c, 4C c, 4D c, 4E c, 4E c, DD c,
   4E c, 04 c, FD c, 4E c, 05 c, 0E c, 03 c,
----
\ LD binary 2/4
   \ (LDD,*)
   57 c, 50 c, 51 c, 52 c, 53 c, 54 c, 55 c, 56 c, 56 c, DD c,
   56 c, 06 c, FD c, 56 c, 07 c, 16 c, 04 c,
   \ (LDE,*) tests (75)
   5F c, 58 c, 59 c, 5A c, 5B c, 5C c, 5D c, 5E c, 5E c, DD c,
   5E c, 08 c, FD c, 5E c, 09 c, 1E c, 05 c,
   \ (LDH,*) tests (92)
   67 c, 60 c, 61 c, 62 c, 63 c, 64 c, 65 c, 66 c, 66 c, DD c,
   66 c, 0A c, FD c, 66 c, 0B c, 26 c, 06 c,                         
   \ (LDL,*) tests (109)
   6F c, 68 c, 69 c, 6A c, 6B c, 6C c, 6D c, 6E c, 6E c, DD c,
   6E c, 0C c, FD c, 6E c, 0D c, 2E c, 07 c,
----
\ LD binary 3/4
\ (LD(HL),*)
 77 c, 70 c, 71 c, 72 c, 73 c, 74 c, 75 c, 36 c, 08 c,
\ (LD(IX+i),*)
 dd c, 77 c, 0e c, dd c, 70 c, 0f c, dd c, 71 c, 10 c, dd c,
 72 c, 11 c, dd c, 73 c, 12 c, dd c, 74 c, 13 c, dd c, 75 c,
 14 c, dd c, 76 c, 14 c, 08 c,
\ (LD(IY+i),*)
 fd c, 77 c, 16 c, fd c, 70 c, 17 c, fd c, 71 c, 18 c, fd c,
 72 c, 19 c, fd c, 73 c, 1a c, fd c, 74 c, 1b c, fd c, 75 c,
 1c c, fd c, 76 c, 1d c, 09 c,
\ (LDrr,*)
 02 c, 02 c, 01 c, fe c, ff c, 11 c, fd c, ff c, 12 c, 12 c,
 21 c, fc c, ff c, 31 c, fb c, ff c, dd c, 21 c, fa c, ff c,
 fd c, 21 c, f9 c, ff c, 2a c, f8 c, ff c, ed c, 4b c, f7 c,
 ff c, ed c, 5b c, f6 c, ff c, dd c, 2a c, f5 c, ff c, fd c,
----
\ LD binary 4/4
   2a c, f4 c, ff c, ed c, 7b c, f3 c, ff c,
\ (LDw,rr)
   22 c, f2 c, ff C,
   ED c, 43 c, F1 c, FF c, ED c, 53 c, F0 c, FF c, DD c, 22 c,
   EF c, FF c, FD c, 22 c, EE c, FF c, ED c, 73 c, ED c, FF c,
   F9 c, DD c, F9 c, FD c, F9 c,

\ calculate last entry size
here 1- ' (ld.bin) >body - constant (ld.bin).l
----
\ Testing all LoaD opcodes
hex z/code (LD.assembled)
----
 A        A  LD   \ A       -> A
 B        A  LD   \ B       -> A
 C        A  LD   \ C       -> A
 D        A  LD   \ D       -> A
 E        A  LD   \ E       -> A
 H        A  LD   \ H       -> A
 L        A  LD   \ L       -> A
 HL       A  LD   \ (HL)    -> A
 (HL)     A  LD   \ (HL)    -> A
 BC       A  LD   \ (BC)    -> A
 (BC)     A  LD   \ (BC)    -> A
 DE       A  LD   \ (DE)    -> A
 (DE)     A  LD   \ (DE)    -> A
 ( FFFF ) A  LD   \ (FFFF)  -> A
 00 IX +  A  LD   \ (IX+00) -> A
 IY 01 +  A  LD   \ (IY+01) -> A
----
 01       A  LD   \ 01      -> A
 A        B  LD   \ A       -> B
 B        B  LD   \ B       -> B
 C        B  LD   \ C       -> B
 D        B  LD   \ D       -> B
 E        B  LD   \ E       -> B
 H        B  LD   \ H       -> B
 L        B  LD   \ L       -> B
 HL       B  LD   \ (HL)    -> B
 (HL)     B  LD   \ (HL)    -> B
 IX 02 +  B  LD   \ (IX+02) -> B
 03 IY +  B  LD   \ (IY+03) -> B
 02       B  LD   \ 02      -> B
 A        C  LD   \ A       -> C
 B        C  LD   \ B       -> C
 C        C  LD   \ C       -> C
----
 D        C  LD   \ D       -> C
 E        C  LD   \ E       -> C
 H        C  LD   \ H       -> C
 L        C  LD   \ L       -> C
 HL       C  LD   \ (HL)    -> C
 (HL)     C  LD   \ (HL)    -> C
 04 IX +  C  LD   \ (IX+04) -> C
 IY 05 +  C  LD   \ (IY+05) -> C
 03       C  LD   \ 03      -> C
 A        D  LD   \ A       -> D
 B        D  LD   \ B       -> D
 C        D  LD   \ C       -> D
 D        D  LD   \ D       -> D
 E        D  LD   \ E       -> D
 H        D  LD   \ H       -> D
 L        D  LD   \ L       -> D
----
 HL       D  LD   \ (HL)    -> D
 (HL)     D  LD   \ (HL)    -> D
 IX 06 +  D  LD   \ (IX+06) -> D
 07 IY +  D  LD   \ (IY+07) -> D
 04       D  LD   \ 04      -> D
 A        E  LD   \ A       -> E
 B        E  LD   \ B       -> E
 C        E  LD   \ C       -> E
 D        E  LD   \ D       -> E
 E        E  LD   \ E       -> E
 H        E  LD   \ H       -> E
 L        E  LD   \ L       -> E
 HL       E  LD   \ (HL)    -> E
 (HL)     E  LD   \ (HL)    -> E
 08 IX +  E  LD   \ (IX+08) -> E
 IY 09 +  E  LD   \ (IY+09) -> E
----
 05       E  LD   \ 05      -> E
 A        H  LD   \ A       -> H
 B        H  LD   \ B       -> H
 C        H  LD   \ C       -> H
 D        H  LD   \ D       -> H
 E        H  LD   \ E       -> H
 H        H  LD   \ H       -> H
 L        H  LD   \ L       -> H
 HL       H  LD   \ (HL)    -> H
 (HL)     H  LD   \ (HL)    -> H
 0A IX +  H  LD   \ (IX+0A) -> H
 IY 0B +  H  LD   \ (IY+0B) -> H
 06       H  LD   \ 06      -> H
 A        L  LD   \ A       -> L
 B        L  LD   \ B       -> L
 C        L  LD   \ C       -> L
----
 D        L  LD   \ D       -> L
 E        L  LD   \ E       -> L
 H        L  LD   \ H       -> L
 L        L  LD   \ L       -> L
 HL       L  LD   \ (HL)    -> L
 (HL)     L  LD   \ (HL)    -> L
 IX 0C +  L  LD   \ (IX+0C) -> L
 0D IY +  L  LD   \ (IY+0D) -> L
 07       L  LD   \ 07      -> L
 A      (HL) LD   \ A       -> (HL)
 B      (HL) LD   \ B       -> (HL)
 C      (HL) LD   \ C       -> (HL)
 D      (HL) LD   \ D       -> (HL)
 E      (HL) LD   \ E       -> (HL)
 H      (HL) LD   \ H       -> (HL)
 L      (HL) LD   \ L       -> (HL)
----
 08     (HL) LD   \ 08      -> (HL)
 A   0E IX + LD   \ A       -> (IX+0E)
 B   IX 0F + LD   \ B       -> (IX+0F)
 C   10 IX + LD   \ C       -> (IX+10)
 D   IX 11 + LD   \ D       -> (IX+11)
 E   12 IX + LD   \ E       -> (IX+12)
 H   IX 13 + LD   \ H       -> (IX+13)
 L   14 IX + LD   \ L       -> (IX+14)
 08  IX 14 + LD   \ 08      -> (IX+14)
 A   16 IY + LD   \ A       -> (IY+16)
 B   IY 17 + LD   \ B       -> (IY+17)
 C   18 IY + LD   \ C       -> (IY+18)
 D   IY 19 + LD   \ D       -> (IY+19)
 E   1A IY + LD   \ E       -> (IY+1A)
 H   IY 1B + LD   \ H       -> (IY+1B)
 L   1C IY + LD   \ L       -> (IY+1C)
----
 09  IY 1D + LD   \ 09      -> (IY+1D)
 A        BC LD   \ A       -> (BC)
 A      (BC) LD   \ A       -> (BC)
 FFFE     BC LD   \ FFFE    -> BC
 FFFD     DE LD   \ FFFD    -> DE
 A        DE LD   \ A       -> (DE)
 A      (DE) LD   \ A       -> (DE)
 FFFC     HL LD   \ FFFC    -> HL
 FFFB     SP LD   \ FFFB    -> SP
 FFFA     IX LD   \ FFFA    -> IX
 FFF9     IY LD   \ FFF9    -> IY
 ( FFF8 ) HL LD   \ (FFF8)  -> HL
 ( FFF7 ) BC LD   \ (FFF7)  -> BC
 ( FFF6 ) DE LD   \ (FFF6)  -> DE
 ( FFF5 ) IX LD   \ (FFF5)  -> IX
 ( FFF4 ) IY LD   \ (FFF4)  -> IY
----
 ( FFF3 ) SP LD   \ (FFF3)  -> SP
 HL ( FFF2 ) LD   \ HL   -> (FFF2) 
 BC ( FFF1 ) LD   \ BC    -> (FFF1) 
 DE ( FFF0 ) LD   \ DE    -> (FFF0) 
 IX ( FFEF ) LD   \ IX    -> (FFEF) 
 IY ( FFEE ) LD   \ IY    -> (FFEE) 
 SP ( FFED ) LD   \ SP    -> (FFED) 
 HL       SP LD   \ HL    -> SP 
 IX       SP LD   \ IX    -> SL 
 IY       SP LD   \ IY    -> SL 
z/end-code

: test
 ['] (LD.bin) >body ['] (LD.assembled) >body (LD.bin).l memcmp ;
