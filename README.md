# 8-bit SystemVerilog ALU

A small, fully combinational 8-bit Arithmetic Logic Unit written in SystemVerilog. The project is designed to demonstrate basic digital logic, binary arithmetic, flags, and self-checking simulation and a few other things i learnt, not completely sure how to structure a read me but we'll try this format for onw.

What Is an ALU?

An Arithmetic Logic Unit is a digital circuit that performs arithmetic and logical operations. It is one of the core building blocks inside a processor.

Supported Operations

| Opcode | Operation | Description |
| --- | --- | --- |
| `0000` | ADD | `a + b` |
| `0001` | SUB | `a - b` |
| `0010` | AND | Bitwise AND |
| `0011` | OR | Bitise OR |
| `0100` | XOR | Bitwise exclusive OR |
| `0101` | NOT | Bitwise NOT of `a` |
| `0110` | SHIFT LEFT | Logical left shift of `a` by one bit |
| `0111` | SHIFT RIGHT | Logical right shift of `a` by one bit |
| `1000` | EQUAL | `1` when `a == b`, otherwise `0` |
| `1001` | LESS THAN | Signed comparison: `1` when `a < b`, otherwise `0` |

Unused opcodes produce a zero result and clear all flags.

## Flags

- **Zero:** `1` when the final result is zero; otherwise `0`.
- **Carry:** For addition, this is the unsigned carry-out. For subtraction, it is `1` when no unsigned borrow occurs. For shifts, it is the bit shifted out.
- **Overflow:** `1` when a signed arithmetic result cannot be represented in 8 bits. It is cleared for logical and comparison operations.

Signed overflow is different from carry. For example, signed `127 + 1` produces the bit pattern `1000_0000`, which represents `-128` in 8-bit two's complement. The bit pattern wrapped around, so the overflow flag is set.

## Project Structure

```text
src/
  alu.sv       # ALU implementation
tb/
  alu_tb.sv    # Self-checking testbench
README.md
.gitignore
Makefile
```

## Requirements

- Icarus Verilog with SystemVerilog support
- GNU Make

### Installing Icarus Verilog

On Ubuntu or Debian:

```bash
sudo apt update
sudo apt install iverilog
```

On macOS with Homebrew:

```bash
brew install icarus-verilog
```

On Windows, install Icarus Verilog from [the official project site](https://stevebertrand.github.io/iverilog/), or use a package manager such as Chocolatey:

```powershell
choco install iverilog
```

## Running the Tests

From the project folder, run:

```bash
make test
```

The Makefile compiles the ALU and testbench with `iverilog -g2012`, then runs the simulation with `vvp`. Each test prints `PASS`. The simulation prints `ALL TESTS PASSED` when every expected result and flag matches. A failure prints its inputs, expected outputs, actual outputs, and flags, then ends the simulation with an error.

## What I Learned

This project provides practice with combinational logic, ALU design, binary arithmetic, signed numbers, carry and overflow flags, SystemVerilog syntax, and self-checking testbenches.

## Future Improvements

- Parameterise the ALU bit width
- Add multiplication
- Add arithmetic shifts
- Add more comparison operations
- Implement the ALU on an FPGA
- Integrate the ALU into a simple CPU
