# RV32I 5-Stage Pipelined Processor

A fully synthesizable, FPGA-ready implementation of the RISC-V RV32I base ISA
featuring a classic 5-stage pipeline with data forwarding and hazard detection.

---

## Project Structure

```
riscv32/
├── rtl/
│   ├── top.v             ← Top-level integration (start here)
│   ├── pc.v              ← Program Counter
│   ├── instr_mem.v       ← Instruction Memory (ROM)
│   ├── reg_file.v        ← 32×32 Register File
│   ├── alu.v             ← ALU (ADD/SUB/AND/OR/XOR/SLT/SLL/SRL/SRA)
│   ├── alu_control.v     ← Decodes funct3/funct7 → ALU op
│   ├── imm_gen.v         ← Immediate Generator (all RV32I formats)
│   ├── control_unit.v    ← Main Control Unit
│   ├── hazard_unit.v     ← Load-Use Hazard Detection
│   ├── forwarding_unit.v ← RAW Data Forwarding (EX/MEM → EX)
│   ├── data_mem.v        ← Data Memory (LB/LH/LW/SB/SH/SW)
│   └── pipeline_regs.v  ← IF/ID, ID/EX, EX/MEM, MEM/WB registers
│
├── tb/
│   └── tb_top.v          ← Self-checking testbench
│
└── README.md
```

---

## Features

| Feature               | Status |
|-----------------------|--------|
| RV32I Base ISA        | ✅     |
| 5-Stage Pipeline      | ✅     |
| Data Forwarding (EX→EX, MEM→EX) | ✅ |
| Load-Use Hazard Detection | ✅  |
| Branch Resolution (EX stage) | ✅ |
| JAL / JALR            | ✅     |
| LUI / AUIPC           | ✅     |
| Byte/Half/Word memory | ✅     |
| Self-checking testbench | ✅   |

---

## How to Simulate (Icarus Verilog)

```bash
# Compile
iverilog -o sim.out rtl/top.v tb/tb_top.v

# Run
vvp sim.out

# View waveforms
gtkwave waves.vcd
```

### Using Vivado (Xilinx)

1. Create new RTL project, target Artix-7 (xc7a35tcpg236-1)
2. Add all `rtl/*.v` as design sources
3. Add `tb/tb_top.v` as simulation source
4. Run Behavioral Simulation
5. For synthesis: set `top` as the top module and Run Synthesis

---

## Pipeline Overview

```
Clock:  1   2   3   4   5   6
I1:    IF  ID  EX  ME  WB
I2:        IF  ID  EX  ME  WB
I3:            IF  ID  EX  ME  WB
```

### Hazard Handling

**Load-Use Stall (1 cycle)**
```
lw  x1, 0(x2)     ← load
add x3, x1, x4    ← needs x1 → stall inserted
```

**Data Forwarding (0 cycles)**
```
add x1, x2, x3    ← produces x1 in EX
sub x4, x1, x5    ← EX/MEM → EX forwarding: no stall
```

**Branch (2-cycle penalty, flushed)**
```
beq x1, x2, label ← resolved in EX stage
                   ← IF+ID stages flushed on taken branch
```

---

## Expected Performance (Artix-7)

| Metric        | Value        |
|---------------|--------------|
| Fmax          | ~120–140 MHz |
| LUT Usage     | ~3,000       |
| CPI (no hazards) | 1.0      |
| CPI (with hazards) | ~1.2   |

---

## Supported Instructions

| Type   | Instructions                                      |
|--------|---------------------------------------------------|
| R-type | ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, SRA |
| I-type | ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI |
| Load   | LW, LH, LB, LHU, LBU                             |
| Store  | SW, SH, SB                                        |
| Branch | BEQ, BNE, BLT, BGE, BLTU, BGEU                   |
| Jump   | JAL, JALR                                         |
| Upper  | LUI, AUIPC                                        |

---

## Possible Extensions

- Instruction Cache (Direct-Mapped)
- Static Branch Prediction (Predict Not-Taken)
- AXI-Lite Bus Interface
- CSR Registers (mtvec, mepc, mcause for traps)
- OpenLane GDSII flow (RTL → ASIC)
