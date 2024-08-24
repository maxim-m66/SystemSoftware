.section txt
ld $5, %r1          #0
st %r1, 0xFFFFFF10  #4
ld $tmr, %r1        #8
csrwr %r1, %handler #12
ld $A, %r5          #16
csrwr %r0, %status  #20
loop:
beq %r1, %r1, loop  #24
.skip 200
tmr:
ld [%r5], %r3
st %r3, 0xFFFFFFFF0
ld $1, %r10
add %r10, %r5
iret
A:.ascii "Cao mala"
.section data
B: .skip 4