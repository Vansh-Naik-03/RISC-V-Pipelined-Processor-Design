# Pipelined ALU with Data Forwarding 

## Overview

This project implements a **3-stage pipelined Arithmetic Logic Unit (ALU)** in **Verilog HDL** with a **data forwarding unit** to resolve **Read After Write (RAW) data hazards**.

The design demonstrates key concepts used in modern processor pipelines such as **pipeline registers, hazard detection, and operand forwarding**.

---

## Features

* 3-Stage Pipeline Architecture
* Data Forwarding Unit for hazard resolution
* Supports basic ALU operations:

  * ADD
  * SUB
  * AND
* Pipeline register implementation
* Verilog Testbench for simulation
* Simulation verification using waveform / console output

---

## Pipeline Architecture

The ALU is divided into **three stages**:

| Stage   | Description             |
| ------- | ----------------------- |
| Stage 1 | Fetch / Input Capture   |
| Stage 2 | Execute (ALU Operation) |
| Stage 3 | Writeback               |

### Pipeline Flow

```
Cycle 1
Stage1 : Instruction 1

Cycle 2
Stage1 : Instruction 2
Stage2 : Instruction 1

Cycle 3
Stage1 : Instruction 3
Stage2 : Instruction 2
Stage3 : Instruction 1
```

---

## Data Hazard and Forwarding

### RAW Hazard Example

```
ADD x5, x1, x2
SUB x6, x5, x3
```

The **SUB instruction requires the result of ADD**, but the value has not yet been written back to the register file.

Without forwarding:

* Pipeline stall required.

With forwarding:

* Result from the **Execute stage is directly forwarded** to the next instruction.

Forwarding logic checks:

```
if (rd_s2 == rs1_s1)
if (rd_s2 == rs2_s1)
```

and forwards the computed value.

---

## Supported ALU Operations

| Opcode | Operation |
| ------ | --------- |
| 000    | ADD       |
| 001    | SUB       |
| 010    | AND       |

Example:

```
3'b000 : res = A + B
3'b001 : res = A - B
3'b010 : res = A & B
```

---

## Project Structure

```
pipelined-alu-forwarding/
│
├── pipelined_alu_forwarding.v      # Main RTL module
├── pipelined_alu_forwarding_tb.v   # Testbench
├── README.md                       # Project documentation
```

---

## Simulation

### Tools Used

* Vivado Simulator / ModelSim / Icarus Verilog

### Example Simulation Output

```
Time=45000 | ALU_OUT=15 | RD=5 | REG_WRITE=1
Time=55000 | ALU_OUT=12 | RD=6 | REG_WRITE=1
Time=65000 | ALU_OUT=0  | RD=9 | REG_WRITE=1
Time=75000 | ALU_OUT=30 | RD=4 | REG_WRITE=1
```

### Interpretation

| Instruction | Result |
| ----------- | ------ |
| ADD 10 + 5  | 15     |
| SUB 15 - 3  | 12     |
| AND 8 & 4   | 0      |
| ADD 20 + 10 | 30     |

The **SUB instruction successfully used forwarded data**, proving that the forwarding unit works correctly.

---


## Learning Outcomes

This project demonstrates important **processor design concepts**:

* RTL Design using Verilog
* Pipeline architecture
* Data hazard detection
* Data forwarding
* Pipeline register design
* Hardware verification using testbenches

---

## Possible Improvements

Future improvements could include:

* 5-stage pipeline (IF, ID, EX, MEM, WB)
* Hazard Detection Unit
* Pipeline Stall Logic
* Branch Handling
* Register File Integration
* RISC-V Instruction Support

---


---

## License

This project is released under the **MIT License**.
