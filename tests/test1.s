.skip 12
.word 1200131
.word 1200132
.word 1200133
.word 1200134
.word 1200135
.word 1200136
.word 1200137
.word 1200138
.word 1200139
.word 1200140
.word 1200141
.word 1200142
.word 1200143
.word 1200144
.word 1200145
.word 1200146
.word 1200147
.word 1200148
.word 1200149
.word 1200150
.word 1200151
.word 1200152
.word 1200153
.word 1200154
.word 1200155
.word 1200156
.word 1200157
.word 1200158
.word 1200159
.word 1200160
.word 1200161
.word 1200162
.word 1200163
.word 1200164
.word 1200165
.word 1200166
.word 1200167
.word 1200168
.word 1200169
.word 1200170
.word 1200171
.word 1200172
.word 1200173
.word 1200174
.word 1200175
.word 1200176
.word 1200177
.word 1200178
.word 1200179
.word 1200180
.word 1200181
.word 1200182
.word 1200183
.word 1200184
.word 1200185
.word 1200186
.word 1200187
.word 1200188
.word 1200189
.word 1200190
.word 1200191
.word 1200192
.word 1200193
.word 1200194

.section bss

sub %r13, %r14
mul %r15, %r15

div %r13, %r14
not %r13

and %r13, %r14
or %r13, %r14

xor %r13, %r14
shl %r13, %r14

shr %r13, %r14
ld $A, %r10

A:ld $3, %r11
ld A, %r10

ld 3, %r11
st %r1, [%r2]

st %r1, [%r2 + 3]
st %r1, [%r2 + A]

csrrd %status, %r1
csrwr %r2, %status