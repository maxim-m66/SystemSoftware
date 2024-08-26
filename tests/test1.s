.section txt
ld $0x100, %sp
call A
halt
.skip 500
A:
ret