.extern C
.section txt
beq %r1, %r2, A
beq %r1, %r2, A
beq %r1, %r2, B
ld [%r1 + C], %r2
int
int
A: ret
B:
.section bss
.skip 5
.word 3, 2, 1