; MPS - an educational 8 bits processor and its toolchain
; Copyright (C) 2022 Jonathan Tremesaygues <jonathan.tremesaygues@slaanesh.org>
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.

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