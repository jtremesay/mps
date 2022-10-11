set r1 1
set r2 2
set r3 3

add r4 r2 r3
st r1 r4

lsh r5 r4 r1
st r2 r5

ld r7 r1
ld r6 r2
xor r5 r6 r7
st r2 r5

hcf