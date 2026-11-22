// ------------------------------------------------------------------
// tb_gls.v : one testbench for BOTH the RTL core and the post-layout
// gate-level netlist (same module name riscv_core, same ports).
// It runs one program, prints every store to data memory, then dumps
// data memory. If the RTL log and the gate-level log are identical,
// the layout netlist behaves exactly like the verified RTL.
//
// Usage: +prog=programs/fibonacci.mem
// ------------------------------------------------------------------
`timescale 1ns/1ps
module tb;
  reg clk = 1'b0;
  reg reset_n = 1'b0;
  always #500 clk = ~clk;        // slow clock: gate models use unit delays

  wire        imem_req;
  wire [31:0] imem_addr;
  wire [31:0] imem_data;
  wire        dmem_req, dmem_wr_en, dmem_zero_extend;
  wire [1:0]  dmem_size;
  wire [31:0] dmem_addr, dmem_wr_data;
  reg  [31:0] dmem_rd_data;

  riscv_core dut (
    .clk(clk), .reset_n(reset_n),
    .imem_req(imem_req), .imem_addr(imem_addr), .imem_data(imem_data),
    .dmem_req(dmem_req), .dmem_wr_en(dmem_wr_en), .dmem_size(dmem_size),
    .dmem_zero_extend(dmem_zero_extend), .dmem_addr(dmem_addr),
    .dmem_wr_data(dmem_wr_data), .dmem_rd_data(dmem_rd_data)
  );

  // ---------------- instruction memory (same as instruction_memory.sv)
  reg [7:0] imem [0:127];
  assign imem_data = imem_req ? {imem[imem_addr], imem[imem_addr+1],
                                 imem[imem_addr+2], imem[imem_addr+3]} : 32'd0;

  // ---------------- data memory (same as data_memory.sv, 64 bytes)
  reg [7:0] dmem [0:63];
  always @(posedge clk) begin
    if (dmem_req && dmem_wr_en) begin
      case (dmem_size)
        2'b00: dmem[dmem_addr] <= dmem_wr_data[7:0];
        2'b01: {dmem[dmem_addr+1], dmem[dmem_addr]} <= dmem_wr_data[15:0];
        2'b11: {dmem[dmem_addr+3], dmem[dmem_addr+2], dmem[dmem_addr+1], dmem[dmem_addr]} <= dmem_wr_data;
      endcase
    end
  end
  always @* begin
    if (dmem_req && !dmem_wr_en) begin
      case (dmem_size)
        2'b00: dmem_rd_data = dmem_zero_extend ? {24'd0, dmem[dmem_addr]} : {{24{dmem[dmem_addr][7]}}, dmem[dmem_addr]};
        2'b01: dmem_rd_data = dmem_zero_extend ? {16'd0, dmem[dmem_addr+1], dmem[dmem_addr]}
                                               : {{16{dmem[dmem_addr+1][7]}}, dmem[dmem_addr+1], dmem[dmem_addr]};
        2'b11: dmem_rd_data = {dmem[dmem_addr+3], dmem[dmem_addr+2], dmem[dmem_addr+1], dmem[dmem_addr]};
        default: dmem_rd_data = 32'd0;
      endcase
    end else
      dmem_rd_data = 32'd0;
  end

  // ---------------- run control and logging
  reg [8*256:1] prog;
  integer i, cycles, stores;
  initial begin
    for (i = 0; i < 128; i = i + 1) imem[i] = 8'h00;
    for (i = 0; i < 64;  i = i + 1) dmem[i] = 8'h00;
    if (!$value$plusargs("prog=%s", prog)) prog = "programs/fibonacci.mem";
    $readmemh(prog, imem);
    cycles = 0; stores = 0;
    #2000 reset_n = 1'b1;
  end

  always @(posedge clk) if (reset_n) begin
    cycles <= cycles + 1;
    if (dmem_req === 1'b1 && dmem_wr_en === 1'b1) begin
      stores <= stores + 1;
      $display("STORE  pc=%08h  addr=%08h  size=%b  data=%08h", imem_addr, dmem_addr, dmem_size, dmem_wr_data);
    end
    // every program ends with a NOP (0x00000013): stop when it is fetched
    if (imem_data === 32'h00000013 || cycles == 3000) begin
      $display("END    pc=%08h  cycles=%0d  stores=%0d", imem_addr, cycles, stores);
      #1;
      $display("DATA MEMORY (bytes 0..63):");
      for (i = 0; i < 64; i = i + 16)
        $display("  %02h: %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h %02h", i,
          dmem[i],dmem[i+1],dmem[i+2],dmem[i+3],dmem[i+4],dmem[i+5],dmem[i+6],dmem[i+7],
          dmem[i+8],dmem[i+9],dmem[i+10],dmem[i+11],dmem[i+12],dmem[i+13],dmem[i+14],dmem[i+15]);
      $finish;
    end
  end
endmodule
