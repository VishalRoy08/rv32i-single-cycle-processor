// --------------------------------------------------------
// top : SIMULATION ONLY wrapper (not used for layout)
// riscv_core + your existing instruction/data memories.
// Keeps the same name and ports as before, so test_bench.sv
// works unchanged. Re-run your 4 programs with this to prove
// the core you lay out is the same core you verified.
// Waveform paths become /test_bench/dut/u_core/...
// --------------------------------------------------------
import risc_pkg ::*;
module top #(
    parameter RESET_PC = 32'h0000
)(
    input logic clk,
    input logic reset_n
);
    logic        imem_req;
    logic [31:0] imem_addr, imem_data;
    logic        dmem_req, dmem_wr_en, dmem_zero_extend;
    logic [1:0]  dmem_size;
    logic [31:0] dmem_addr, dmem_wr_data, dmem_rd_data;

    riscv_core #(.RESET_PC(RESET_PC)) u_core (
        .clk(clk),
        .reset_n(reset_n),
        .imem_req(imem_req),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .dmem_req(dmem_req),
        .dmem_wr_en(dmem_wr_en),
        .dmem_size(dmem_size),
        .dmem_zero_extend(dmem_zero_extend),
        .dmem_addr(dmem_addr),
        .dmem_wr_data(dmem_wr_data),
        .dmem_rd_data(dmem_rd_data)
    );

    instruction_memory u_instruction_memory(
        .imem_req(imem_req),
        .imem_addr(imem_addr),
        .imem_data(imem_data)
    );

    data_memory u_data_memory(
        .clk(clk),
        .dmem_req(dmem_req),
        .dmem_wr_en(dmem_wr_en),
        .dmem_data_size(mem_size_t'(dmem_size)),
        .dmem_addr(dmem_addr),
        .dmem_wr_data(dmem_wr_data),
        .dmem_zero_extend(dmem_zero_extend),
        .dmem_rd_data(dmem_rd_data)
    );
endmodule
