# Logic Design Lab — TA Reference Designs

Reference solutions I wrote as a **teaching assistant** for **EE223002 Logic Design Lab** (National Tsing Hua University, instructor Prof. Yuan-Hao Huang) in **Spring 2025** and **Spring 2026**. All designs target the Digilent **Basys 3** FPGA board (Artix-7) in Xilinx Vivado.

Only labs I actually implemented are included. Quizzes, course handouts, student submissions, and Vivado project and build files are not included.

> My own student version of this course (Spring 2023, plain Verilog) is in [Logic-Design-Lab](https://github.com/SamChang03/Logic-Design-Lab).

---

## ⚠️ 2026 is written in SystemVerilog

The **2025** designs (and 2026 `lab02`) are **Verilog-2001** (`.v`). From **2026 `lab03` on, everything is SystemVerilog** (`.sv`), and the coding style is quite different. Add the files as SystemVerilog sources in Vivado, or they will not compile.

| | 2025 (Verilog) | 2026 (SystemVerilog) |
|---|---|---|
| Signal type | `wire` / `reg` | `logic` everywhere |
| Sequential logic | `always @(posedge clk)` | `always_ff @(posedge clk)` |
| Combinational logic | `always @(*)` | `always_comb`, with defaults assigned at the top so no latches are inferred |
| FSM states | `localparam` constants | `typedef enum logic [N-1:0] {IDLE, COUNTING, PAUSE, DONE}` |
| 7-segment patterns | `localparam` / `` `define `` per file | One shared `head.sv` with a `typedef enum ssd_codeword`, so ports are typed: `output ssd_codeword SSD` |
| Case statements | `case` | `unique case` where all cases are covered |
| Widths and constants | Hard-coded widths | Parameterized modules, `'0` fill literals, `BCD_BIT'(9)` width casts, `$clog2()` |
| Structure | One file per experiment, logic mixed with I/O | Reusable blocks shared across labs: `clock_gen_1Hz/1kHz`, `debounce_circuit`, `one_pulse`, `input_processing`, `ssd_control`, `BCD_up/down` |

All 2026 `.sv` files include `head.sv` (guarded with `` `ifndef HEAD_SV ``), so keep it in the same source set.

---

## 2025 (Verilog)

Each experiment folder has `rtl/`, `tb/` (testbench), and `constraint/` (`.xdc`).

| Lab | Experiments |
|---|---|
| **Lab01** Verilog basics | `Lab01_1` binary-to-Gray-code converter · `Lab01_3` select the larger of two numbers |
| **Lab02** FPGA emulation | `Lab02_2` 4-bit binary to 7-segment decoder, with LEDs mirroring the input |
| **Lab03** Counters and shifters | `prelab1` 4-bit up counter · `prelab2` 8-bit ring counter · `Lab03_1` 2²⁷ frequency divider · `Lab03_2` 1 Hz clock from a count-to-50M divider · `Lab03_3` up counter at 1 Hz · `Lab03_4` ring counter at 1 Hz · `Lab03_5` scrolling pattern on the 7-segment display |
| **Lab04** Counters II | `Lab04_1` binary down counter · `Lab04_2` down counter on the 7-segment display · `Lab04_3` single-digit BCD down counter · `Lab04_4` two-digit BCD up counter |
| **Lab05** FSM: timer and stopwatch | `Lab05_1` 50-second timer with start/pause FSM · `Lab05_2` MM:SS stopwatch with lap · `Lab05_3` settable MM:SS countdown timer (schematic in `schematic.pdf`) |

## 2026 (SystemVerilog)

The 2026 syllabus was reorganized: Lab03 now covers both counters and shifters, and the timer/stopwatch, speaker, and keyboard labs moved earlier. Each experiment folder has `hdl/` and `xdc/`.

| Lab | Experiments |
|---|---|
| **lab02** FPGA emulation (Verilog) | `lab2_2` binary to 7-segment decoder · `lab2_3` *Bulls and Cows* matcher (two-digit BCD secret vs. guess, with bulls and cows shown on LEDs) |
| **lab03** Counters and shifters | `lab3_1` 2²⁷ divider · `lab3_2` 1 Hz divider · `lab3_3` 4-bit up counter at 1 Hz · `lab3_4` counter on the 7-segment display · `lab3_5` 7-bit ring counter, reset value `1101110` · `lab3_6` scrolling “NTHUEE2026” · `lab3_7` BCD down counter at 2 Hz · `lab3_8` two-digit BCD up counter |
| **lab04** FSM: timer and stopwatch | `lab4_1` 50-second timer (IDLE/COUNTING/PAUSE/DONE FSM) · `lab4_2` MM:SS stopwatch with lap (frozen display buffer) · `lab4_3` settable countdown timer with start/stop and pause/resume |
| **lab06** Speaker | `lab6_1` audio parallel-to-serial driver (25 MHz MCLK, 25/128 MHz LRCK, 32·Fs SCK), with testbench · `lab6_2` Do/Re/Mi on buttons with 16-level volume shown on the 7-segment display |
| **lab07** PS/2 keyboard | `lab7_1` digits and a/s/m operator keys shown on the 7-segment display |

`KeyboardCtrl`, `KeyboardDecoder`, and `Ps2Interface` in `lab7_1` are the course-provided PS/2 modules, renamed to `.sv`. `PS2_Decoder.sv` and the top-level module are mine.

## Tools

- Xilinx Vivado
- Verilog-2001
- SystemVerilog (IEEE 1800)
- Digilent Basys 3 (XC7A35T)

## Author

Yu-Shuo Chang (張育碩), TA for EE223002, NTHU EE
