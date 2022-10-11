#!/usr/bin/env python3
from io import TextIOBase
from typing import Optional, Sequence, Generator


INSTRS = {
    "nop": 0,
    "hcf": 8,
    "ld": 2,
    "st": 10,
    "set": 4,
    "dup": 12,
    "add": 1,
    "sub": 9,
    "lsh": 3,
    "rsh": 11,
    "or": 5,
    "and": 13,
    "xor": 7,
    "not": 15,
}


def assemble(stream: TextIOBase) -> Generator[int, None, None]:
    for line in stream:
        line = line.split(";", maxsplit=1)[0].strip()
        if not line:
            continue

        instr, *ops = line.split(" ")
        ops = [int(op.split("r")[-1]) for op in ops]

        opcode = INSTRS[instr]

        if instr == "set":
            opcode |= (ops[0] & 15) << 4
            opcode |= (int(ops[1]) & 255) << 8
        elif instr == "st":
            opcode |= (ops[0] & 15) << 8
            opcode |= (ops[1] & 15) << 12
        else:
            for i, reg in enumerate(ops):
                opcode |= (reg & 15) << (4 * (i + 1))

        yield opcode


def emit_bytecode(stream, bytecode):
    stream.write("{:04x}\n".format(bytecode))


def main(args: Optional[Sequence[str]] = None):
    import argparse

    argparser = argparse.ArgumentParser()
    argparser.add_argument("srcfile", type=argparse.FileType("r"))
    argparser.add_argument("memfile", type=argparse.FileType("w"))
    args = argparser.parse_args(args)

    i = 0
    for bytecode in assemble(args.srcfile):
        emit_bytecode(args.memfile, bytecode)
        i += 1

    for i in range(i, 256):
        emit_bytecode(args.memfile, 0)


if __name__ == "__main__":
    main()
