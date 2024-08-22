.extern C
.global A
.section txt
ld %r1, %r2
ld %r3, %r2
ld %r4, %r12
.word 100
A:beq %r1, %r2, A
beq %r1, %r2, A
beq %r1, %r2, B
ld [%r1 + C], %r2
int
B: int
ret
halt