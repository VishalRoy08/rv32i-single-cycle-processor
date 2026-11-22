# Student Grading

## Description

This benchmark computes **1.25 × the student's marks** (as `marks + (marks >> 2)`) for five students and determines whether the result is at least **60**.

- If **1.25 × marks ≥ 60**, the output is **1** (pass).
- Otherwise, the output is **0**.

## Purpose

This benchmark is used to verify:

- Arithmetic operations
- Comparison operations
- Conditional branching
- Decision-making logic

## Custom Instruction Set Extension (ISE)

To improve the performance of this benchmark, a custom **Instruction Set Extension (ISE)** was integrated into the processor.

The custom `GRD` instruction (R-type, opcode `0110011`, `funct3 = 001`, `funct7 = 0100000`) replaces the shift, add, compare and branch sequence with a single instruction, resulting in a lower execution time.

Measured from reset until the final instruction is fetched:

| Implementation | Clock Cycles |
|---------------|-------------:|
| Standard RV32I Implementation | 68 |
| RV32I with Custom ISE | 48 |

This represents an approximate **29% reduction in execution cycles** for the grading benchmark, demonstrating the effectiveness of application-specific instruction extensions.

## Files

- `grading_without_ise/grades.asm` – assembly source, standard RV32I
- `grading_without_ise/grades.mem` – machine code, standard RV32I
- `grading_with_ise/grades_acc.asm` – assembly source, using the `GRD` instruction
- `grading_with_ise/grades_acc.mem` – machine code, using the `GRD` instruction

To run a program, copy its `.mem` file to `machine_code.mem` in the simulator's working directory.