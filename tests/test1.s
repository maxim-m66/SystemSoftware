.section txt
ld $0x100, %r1
st %r1, A
ld A, %r2
not %r2
xchg %r1, %r2
halt
.section data
A:.skip 100
