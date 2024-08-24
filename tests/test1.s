.section txt
ld $2, %r1          #0
st %r1, 0xFFFFFF10  #4
ld $tmr, %r1        #8
csrwr %r1, %handler #12
ld $A, %r5          #16
csrwr %r0, %status  #20
loop:
beq %r1, %r1, loop  #24
tmr:
ld [%r5], %r3       #28
beq %r3, %r0, end:
st %r3, 0xFFFFFFF00 #32
ld $1, %r10         #36
add %r10, %r5       #40
iret                #44 && 48
end: halt
A:.ascii "Cao mala"
.skip 12
.section data
B: .skip 4