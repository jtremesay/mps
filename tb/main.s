
; r1 = 1
; r2 = 2
; r3 = 3
set r1 1
set r2 2
set r3 3

; r4 = r3 + r3
; MEMORY[r1] = r4
add r4 r2 r3
st r1 r4

; r5 = r4 << r1
; MEMORY[r2] = r5
lsh r5 r4 r1
st r2 r5

; r7 = MEMORY[r1]
; r6 = MEMORY[r2]
; r5 = r6 ^ r7
; MEMORY[r3] = r5
ld r7 r1
ld r6 r2
xor r5 r6 r7
st r3 r5

; Halt, and Catch Fire
hcf