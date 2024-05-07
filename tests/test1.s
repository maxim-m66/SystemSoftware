# file: handler.s
.section txt
handler:
push %r1
push %r2
csrrd %cause, %r1
ld $2, %r2
beq %r1, %r2, my_isr_timer
ld $3, %r2
beq %r1, %r2, my_isr_terminal
# obrada prekida od tajmera
my_isr_timer:
ld $ascii_code , %r1
st %r1, term_out
add %r1, %r1
not %r2
pop %r1
ret
jmp finish
# obrada prekida od terminala
my_isr_terminal:
ld term_in, %r1
st %r1, term_out
ld my_counter, %r1
ld $1, %r2
add %r2, %r1
xchg %pc, %r1
st %r1, my_counter
finish:
pop %r2
pop %r1
iret
.end
# file: main.s
ld $init_sp, %sp
ld $handler, %r1
csrwr %r1, %handler
ld $0x1, %r1
st %r1, tim_cfg
wait:
ld my_counter, %r1
ld $5, %r2
bne %r1, %r2, wait
int
halt