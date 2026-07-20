# RV32I 32-bit Single-Cycle RISC-V Processor

A 32-bit single-cycle RISC-V processor implemented in **SystemVerilog** based on the **RV32I Base Integer Instruction Set (ISA)**. The processor features a modular Harvard architecture with separate instruction and data memories and includes a custom **Instruction Set Extension (ISE)** developed to accelerate a grading application. The design has been functionally verified using **ModelSim** and **Xilinx Vivado Simulator**, and successfully synthesized targeting the **Digilent Basys 3 (Artix-7 XC7A35T)** FPGA.

Hardware implementation on the FPGA and additional architectural enhancements are planned as future work.

---

## Architecture

<p align="center">
  <img src="docs/architecture/processor_architecture.png" alt="Processor Architecture" width="900">
</p>

---

## Features

- 32-bit Single-Cycle RV32I Processor
- Harvard Architecture
- Modular SystemVerilog RTL Design
- 32 × 32-bit General Purpose Register File
- Arithmetic Logic Unit (ALU)
- Control Unit
- Branch Control Unit
- Instruction Fetch Unit
- Instruction Decode Unit
- Immediate Generator
- Instruction Memory
- Data Memory
- Custom Instruction Set Extension (ISE) for grading acceleration
- Functional verification using ModelSim and Vivado Simulator
- Successfully synthesized targeting Xilinx Artix-7 FPGA

---

## Processor Specifications

| Specification | Details |
|--------------|---------|
| ISA | RV32I |
| Architecture | Harvard |
| Datapath Width | 32-bit |
| Processor Type | Single-Cycle |
| HDL | SystemVerilog |
| Verification | ModelSim, Vivado Simulator |
| Synthesis Tool | Xilinx Vivado 2018.2 |
| Target FPGA | Digilent Basys 3 (Artix-7 XC7A35T-1CPG236C) |

---

## Repository Structure

```text
rv32i-single-cycle-processor/
│
├── rtl/
├── sim/
├── programs/
├── docs/
│   ├── architecture/
│   ├── waveforms/
│   ├── synthesis/
│   └── report/
├── hardware/
├── README.md
├── LICENSE
└── .gitignore
```

---

## Processor Modules

The processor is composed of the following RTL modules:

- Top Module
- Instruction Fetch
- Instruction Decode
- Control Unit
- Branch Control Unit
- Register File
- Arithmetic Logic Unit (ALU)
- Instruction Memory
- Data Memory

---

## Benchmark Programs

The processor has been verified using the following benchmark applications:

| Benchmark | Purpose |
|-----------|---------|
| Fibonacci Series | Verifies arithmetic operations, branching and looping |
| Bubble Sort | Verifies memory operations, comparisons and loops |
| Maximum Value in an Array | Verifies conditional branching and memory access |
| Student Grading | Verifies arithmetic, comparison and decision-making operations |
| Student Grading (ISE) | Demonstrates acceleration using a custom instruction |

Each benchmark directory contains:

- RISC-V Assembly Source (`.asm`)
- Machine Code (`machine_code.mem`)

---

## Custom Instruction Set Extension (ISE)

A custom Instruction Set Extension (ISE) was designed and integrated into the processor to accelerate the student grading benchmark.

The extension reduces the number of instructions required for grade computation, demonstrating how application-specific instructions can improve execution efficiency while maintaining compatibility with the processor architecture.

---

## Simulation and Verification

Functional verification was carried out using:

- ModelSim
- Xilinx Vivado Simulator

Verification includes:

- Instruction Fetch
- Instruction Decode
- Register File Operations
- ALU Operations
- Branch Instructions
- Memory Operations
- Execution of all benchmark programs

Representative simulation waveforms are available in:

```text
docs/waveforms/
```

---

## Synthesis

The processor has been successfully synthesized targeting the **Digilent Basys 3 (Artix-7 XC7A35T-1CPG236C)** FPGA.

### Resource Utilization

| Resource | Used | Utilization |
|----------|-----:|------------:|
| Slice LUTs | 3,934 | 18.91% |
| Slice Registers | 1,568 | 3.77% |
| Block RAM | 0 | 0% |
| DSP | 0 | 0% |

RTL schematic and synthesis reports are available in:

```text
docs/synthesis/
```

---
## Results

- Successfully executed Fibonacci Series
- Successfully executed Bubble Sort
- Successfully executed Maximum Value in an Array
- Successfully executed Student Grading
- Successfully accelerated Student Grading using a custom Instruction Set Extension (ISE)
- Successfully synthesized targeting the Xilinx Artix-7 FPGA

## Development Tools

- SystemVerilog
- ModelSim
- Xilinx Vivado 2018.2


---

## Future Work

- Hardware implementation on Digilent Basys 3 FPGA
- On-board functional validation
- SHA-256 hardware implementation
- Additional custom Instruction Set Extensions
- UART interface
- Memory-mapped peripherals
- Pipeline implementation
- Branch prediction
- Cache memory
- CSR (Control and Status Registers)
- Interrupt and exception handling
- RV32M (Integer Multiplication and Division) Extension
- Performance benchmarking and optimization

---

## License

This project is licensed under the MIT License.

---

## Author

**Vishal Roy**

GitHub: https://github.com/VishalRoy08
