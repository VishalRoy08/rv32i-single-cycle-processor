module register_file(
    input logic clk,
    input logic reset_n,

    //Read register addresses
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,

    //Write Port
    input logic [4:0] rd_addr,
    input logic rf_wr_en,
    input logic [31:0] wr_data,

    //Read Data Outputs
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
    //Register File: 32*32-bit registers
    logic [31:0] regs [0:31];

    //Reset and Write Logic
    always_ff @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            //Reset all registers to 0
            for(int i = 0; i < 32; i=i+1) begin
                regs[i] <= 32'b0;
            end
        end else if(rf_wr_en && rd_addr != 5'b0) begin
            //Write data to register file if write enable is high and rd_addr is not zero
            regs[rd_addr] <= wr_data;           
        end
    end

    //Read Logic
    //Read Logic: Force output to 0 if address is x0
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regs[rs2_addr];

endmodule
