# Student Grading

## Description

This benchmark computes **1.25% of the student's marks** and determines whether the computed value exceeds **60**.

- If **1.25% of the marks > 60**, the output is **1**.
- Otherwise, the output is **0**.

## Purpose

This benchmark is used to verify:

- Arithmetic operations
- Comparison operations
- Conditional branching
- Decision-making logic

## Custom Instruction Set Extension (ISE)

To improve the performance of this benchmark, a custom **Instruction Set Extension (ISE)** was integrated into the processor.

The ISE reduces the instruction sequence required for grade computation, resulting in a lower execution time.

| Implementation | Approximate Clock Cycles |
|---------------|-------------------------:|
| Standard RV32I Implementation | ~600 cycles |
| RV32I with Custom ISE | ~400 cycles |

This represents an approximate **33% reduction in execution cycles** for the grading benchmark, demonstrating the effectiveness of application-specific instruction extensions.

## Files

- `grading.asm` – RISC-V assembly source
- `machine_code.mem` – Machine code loaded into instruction memory