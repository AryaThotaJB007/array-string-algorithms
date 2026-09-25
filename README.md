# Low-Level Array & String Algorithms — x86 Assembly (NASM)

CS 66 lab: four standalone 32-bit NASM programs covering common low-level
array and string algorithms, each verified via GDB by inspecting the
final memory contents (these programs compute results in memory and
exit — they don't print anything, so correctness is checked by
examining registers/memory in a debugger, not console output).

## Programs

- **`fibonacci_nasm.asm`** — generates the first seven Fibonacci numbers
  using a sliding-window approach: only the last two values are ever
  kept in registers (`al`/`bl`), so no previous values are re-read from
  memory. Verified result: `1, 1, 2, 3, 5, 8, 13`.

- **`reverse_array_nasm.asm`** — reverses a 7-element `dword` array in
  place using the two-pointer technique (`esi` from the left, `edi`
  from the right, swap and step inward). Uses assemble-time
  `SIZEOF`/`TYPE`/`LENGTHOF`-style constants so the element count and
  size aren't hardcoded. Verified result: `[1,2,3,4,5,6,7]` →
  `[7,6,5,4,3,2,1]`.

- **`string_reverse_nasm.asm`** — copies a null-terminated string into a
  second buffer in reverse character order (reads backward from the
  end of the source while writing forward into the target). Verified
  result: `"This is the source string"` → `"gnirts ecruos eht si sihT"`.

- **`array_rotation_nasm.asm`** — rotates an array forward by one
  position (last element wraps to the front), implemented three times
  for 8-bit, 16-bit, and 32-bit element sizes, shifting elements from
  the end toward the start so no data is overwritten before it's read.
  Verified results: `[10,20,30,40]`→`[40,10,20,30]`,
  `[100,200,300,400]`→`[400,100,200,300]`,
  `[1000,2000,3000,4000]`→`[4000,1000,2000,3000]`.

## Build & run

Each file is fully self-contained (no external library, just raw Linux
`int 0x80` syscalls to exit), so only `nasm` and `ld` are needed — no
`gcc-multilib`/32-bit `libc` required here.

```bash
sudo apt-get update && sudo apt-get install -y nasm
```

To build and inspect any one of them, e.g. `fibonacci_nasm.asm`:

```bash
nasm -f elf32 -g -F dwarf fibonacci_nasm.asm -o fibonacci_nasm.o
ld -m elf_i386 -o fibonacci_nasm fibonacci_nasm.o
gdb ./fibonacci_nasm
```

Then in GDB, set a breakpoint at `done` and run, then examine memory
at the array's label, e.g.:

```
(gdb) break done
(gdb) run
(gdb) x/7db fib
```

(swap `fib` for `intArray`, `target`, or `arr8`/`arr16`/`arr32` for the
other three programs). Since these binaries have no `printf` output,
GDB is the only way to see the result — that's intentional, matching
how the lab was meant to be verified.
