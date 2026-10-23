# 8-bit Accumulator CPU (VHDL)

- **Student:** Tusar Abdullah
- **ID:** 22201079
- **Course:** CSE 450 (VLSI Lab), Final Project, Spring 2026
- **Set:** 9

A small single-cycle 8-bit accumulator CPU written in VHDL.

## Instruction set (Set 9)

| Instruction | Opcode | Operation |
|---|---|---|
| LDI imm | 0001 | ACC <- imm |
| ADD imm | 0010 | ACC <- ACC + imm (carry dropped) |
| NOT | 0111 | ACC <- NOT ACC |
| SHL | 1000 | ACC <- ACC shifted left by 1 (0 enters LSB) |
| JZ addr | 1100 | If Z = 1 then PC <- addr, else PC <- PC + 1 |

Any other opcode is a NOP. Each instruction takes one clock cycle.
Instruction format: 4-bit opcode + 8-bit operand (12 bits).

## Files

| File | Description |
|---|---|
| `pc.vhd` | 4-bit program counter (count up or load for JZ) |
| `program_rom.vhd` | 16 x 12-bit program ROM |
| `control_unit.vhd` | Decodes the opcode and drives the control signals |
| `alu.vhd` | 8-bit ALU (LDI, ADD, SHL, NOT) |
| `acc_register.vhd` | 8-bit accumulator |
| `z_register.vhd` | 1-bit zero flag |
| `cpu_top.vhd` | Top level, connects all blocks |
| `tb_cpu.vhd` | Testbench (checks the Appendix B results) |

## How to run

1. Create a VHDL project in Xilinx ISE and add all the `.vhd` files.
2. Set `cpu_top` as the top module and `tb_cpu` as the simulation top.
3. Run **Simulate Behavioral Model** (ISim) for about 100 ns.
4. The console should show no `FAILED` message.

## Expected results (Appendix B, Set 9)

| Cycle | Instruction | ACC | Z | Next PC |
|---|---|---|---|---|
| 0 | RESET | 00 | 1 | 0 |
| 1 | LDI 0xFF | FF | 0 | 1 |
| 2 | NOT | 00 | 1 | 2 |
| 3 | JZ 0x05 (taken) | 00 | 1 | 5 |
| 4 | ADD 0x11 | 11 | 0 | 6 |
| 5 | SHL | 22 | 0 | 7 |
| 6 | JZ 0x00 (not taken) | 22 | 0 | 8 |
| 7 | SHL | 44 | 0 | 9 |
