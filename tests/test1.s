.section txt
begin:
halt
begin1:
int
iret
call 128
call lol
ret
jmp 256
jmp lol
beq %r1, %r2, 128
beq %r1, %r2, begin1
bne %r1, %r2, 128
bne %r1, %r2, enter
bgt %r1, %r2, 128
bgt %r1, %r2, lol
enter:
push %r15
pop %r15
xchg %r1, %r2
add %r1, %r2
sub %r3, %r4
mul %r5, %r6
div %r7, %r8
not %r9
and %r10, %r11
or %r12, %r13
xor %r14, %r15
shl %r1, %r2
shr %r3, %r4
csrrd %status, %r1
csrwr %r2, %handler
st %r3, 128
st %r4, lol
st %r5, %r6
st %r7, [%r8]
st %r9, [%r10 + 128]
st %r11, [%r12 + lol]
ld $128, %r1
ld $lol, %r2
ld 128, %r3
ld lol, %r4
ld %r5, %r6
ld [%r7], %r8
ld [%r9 + 128], %r10
ld [%r11 + lol], %r12
.section data
lol: int
.section bss
int
halt
.section data
lel:
pop %r15