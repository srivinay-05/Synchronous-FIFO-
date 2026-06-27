# Synchronous FIFO — Verilog RTL Design

A parameterized synchronous FIFO implemented in Verilog, verified in Vivado with
a system-level integration using Sender and Receiver modules.

---

## Project Structure

```
sync-fifo-verilog/
├── fifo.v        # FIFO core
├── sender.v      # Sender module
├── receiver.v    # Receiver module (FSM-based)
├── top.v         # Top-level integration
├── top_tb.v      # Testbench
└── README.md
```

---

## Block Diagram

 ![System](<img width="1155" height="412" alt="block" src="https://github.com/user-attachments/assets/5b081e2d-f762-4151-b521-c1317f2467e5" />
.PNG)


- **Sender (S1)** — Accepts input data and drives write_en to FIFO
- **FIFO (F1)** — 8-depth, 8-bit synchronous FIFO with full/empty flags
- **Receiver (R1)** — FSM-based module that reads from FIFO and outputs data

---

## Features

- Parameterized WIDTH and DEPTH
- Write valid guard — blocks write when FIFO is full
- Read valid guard — blocks read when FIFO is empty
- Full and Empty flags
- Overflow protection
- Underflow protection
- Circular buffer with write_ptr and read_ptr
- Entry count tracked via count register

---

## Parameters

| Parameter  | Default | Description        |
|------------|---------|--------------------|
| WIDTH      | 8       | Data width in bits |
| DEPTH      | 8       | Number of entries  |
| ADDR_WIDTH | 3       | log2(DEPTH)        |

---

## Ports — FIFO Core

| Port     | Direction | Width | Description       |
|----------|-----------|-------|-------------------|
| clk      | input     | 1     | Clock             |
| rst      | input     | 1     | Synchronous reset |
| din      | input     | 8     | Write data        |
| write_en | input     | 1     | Write enable      |
| read_en  | input     | 1     | Read enable       |
| dout     | output    | 8     | Read data         |
| full     | output    | 1     | FIFO full flag    |
| empty    | output    | 1     | FIFO empty flag   |

---

## How It Works

```
write_valid = write_en AND NOT full
read_valid  = read_en  AND NOT empty
```

- On posedge clk, if write_valid → data written at write_ptr, pointer increments
- On posedge clk, if read_valid → data read from read_ptr, pointer increments
- count tracks number of valid entries in FIFO
- Pointers wrap around automatically (circular buffer)

---

## Simulation Results

### Waveform 1 — System Level (Sender → FIFO → Receiver)

![System Waveform](<img width="1913" height="973" alt="WAVE" src="https://github.com/user-attachments/assets/9229ec98-cf55-4970-acab-26a3da2d1a4d" />
.PNG)

- Sender drives 10, 20, 30... into FIFO every clock
- Receiver FSM reads every 3rd cycle
- write_ptr and read_ptr increment correctly
- count oscillates between 7 and 8 in steady state
- final_out shows correct sequential data output

### Waveform 2 — FIFO Core (Memory Contents)

![FIFO Core Waveform](<img width="1908" height="759" alt="wavete" src="https://github.com/user-attachments/assets/b15f201a-a4e8-4c27-b0c4-7ace3303da6d" />
.PNG)

- mem[0] to mem[7] correctly store 10, 20, 30, 40, 50, 60, 70, 80
- full flag asserts when count reaches 8
- empty flag asserts when count reaches 0
- final_out correctly sequences through all stored values

---

## Tests Covered

| Test                 | Result |
|----------------------|--------|
| Reset                | PASS   |
| Write valid guard    | PASS   |
| Read valid guard     | PASS   |
| Full flag            | PASS   |
| Overflow protection  | PASS   |
| Empty flag           | PASS   |
| Underflow protection | PASS   |

---

## Tools Used

- Xilinx Vivado — Simulation and Schematic
- Verilog HDL

---

## Author

**Gandla Srivinay**

- LinkedIn:www.linkedin.com/in/gandla-srivinay
- GitHub: https://github.com/srivinay-05

B.Tech (ECE) | Aspiring RTL Design Engineer

Currently learning and building projects in:

- RTL Design
- Digital Design
- FPGA Design
- Verilog HDL
- VLSI Design
