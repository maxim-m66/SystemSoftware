.global a, b, c
.equ a, 1
.equ b, a + 1
.equ c, b - 0x10
.section txt
ld $0x100, %sp
ld $a, %r1
ld $b, %r2
ld $c, %r3