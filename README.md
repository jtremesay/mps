# MPS (Microprocessor without Pipelined Stages)

Like a [MIPS](https://en.wikipedia.org/wiki/MIPS_architecture), but simpler.

MPS is a load/store architecture (also known as a register-register architecture); except for the load/store instructions used to access memory, all instructions operate on the registers. Alro, the MPS doesn't support jumps or tests. Too hard too implement, hem, I mean, out of scope for this projet… 

## Registers

The MPS has sixteen 8-bit general purpose registers. `r0` is hardwired to zero and writes to it are discarded.  

## Instruction format

Instructions are 16 bits width. Look at [`config.inc.v`](rtl/config.inc.v) for the details.

## Instructions

The MPS support 14 instructions. Each instruction can use 1 to 3 register. `rd` is a destination register and write only. `ra` and `rb` are source registers and read only. `imm` is an immediate value.

### No operation

```
nop
```

Do nothing. Waste a CPU cycle.

### Halt, and Catch Fire

```
hcf
```

Halt, and Catch Fire.

### Load

```
ld rd ra; rd = MEM[ra]
```

Store in `rd` the value at address `rd`.

### Store

```
st ra rb; MEM[ra] = rb
```

Store at address `ra` the value `rb`.

### Set

```
set rd imm; rd = imm
```

Store in `rd` the value `imm`.

### Duplicate

```
dup rd ra; rd = ra
```

Store in `rd` the value of `ra`.

### Add

```
add rd ra rb; rd = ra + rb
```

Store in `rd` the sum of `ra` and `rb`.

### Substract

```
sub rd ra rb; rd = ra - rb
```

Store in `rd` the difference of `ra` and `rb`.

### Left shift

```
lsh rd ra rb; rd = ra << rb
```

Store in `rd` the left shift of `ra` by `rb`.

### Right shift

```
rsh rd ra rb; rd = ra >> rb
```

Store in `rd` the right shift of `ra` by `rb`.

### Bitwise OR

```
or rd ra rb; rd = ra | rb
```

Store in `rd` the result of the binary OR betwen `ra` and `rb`.

### Bitwise AND

```
and rd ra rb; rd = ra & rb
```

Store in `rd` the result of the binary AND betwen `ra` and `rb`.

### Bitwise XOR

```
xor rd ra rb; rd = ra ^ rb
```

Store in `rd` the result of the binary OR betwen `ra` and `rb`.

### Bitwise NOT

```
not rd ra; rd = ~ra
```

Store in `rd` the result of the binary NOT of `ra`.


## Exemple program

```
; Load two values from the memory, sum them and store back the result

; Initialize the register used to index the memory
set r1 1
set r2 2

; Load the two values at address 0x0 and 0x1
ld r8 r0
ld r9 r1

; Do the sum
add r8 r8 r9

; Store the result at address 0x2
st r2 r9

; Halt, and catch fire
hcf
```

## Assembler

You can use [`asm.py`](asm.py) to assemble your program.

```
./asm.py main.s main.mem
```