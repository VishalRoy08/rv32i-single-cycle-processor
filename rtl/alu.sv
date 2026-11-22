import risc_pkg ::*;
module alu(
    //Operands
    input logic [31:0] alu_a,
    input logic [31:0] alu_b,

    //Operation Selector
    input alu_op_t alu_op,

    //ALU Result
    output logic [31:0] alu_res
);
    //Temp value for the custom GRD instruction.
    //Computed outside the case statement so it is always assigned
    //(the original version only assigned it inside GRD, which infers a latch).
    logic [31:0] tmp;
    assign tmp = alu_a + (alu_a >> 2);

    //Internal signed versions for arithmetic comparisons and shifts
    logic signed [31:0] signed_a;
    logic signed [31:0] signed_b;

    assign signed_a = alu_a;
    assign signed_b = alu_b;

    //ALU Operation Logic
    always_comb begin
        //Default assignment before case to avoid latches
        alu_res = 32'd0;
        case(alu_op)
            ADD:  alu_res = alu_a + alu_b;
            SUB:  alu_res = alu_a - alu_b;
            SLL:  alu_res = alu_a << alu_b[4:0];
            SRL:  alu_res = alu_a >> alu_b[4:0];
            SRA:  alu_res = signed_a >>> alu_b[4:0];
            OR:   alu_res = alu_a | alu_b;
            AND:  alu_res = alu_a & alu_b;
            XOR:  alu_res = alu_a ^ alu_b;
            SLT:  alu_res = (signed_a < signed_b) ? 32'd1 : 32'd0;
            SLTU: alu_res = (alu_a < alu_b) ? 32'd1 : 32'd0;
            GRD:  alu_res = (tmp >= 32'd60) ? 32'd1 : 32'd0;
            default: alu_res = 32'd0;
        endcase
    end
endmodule
