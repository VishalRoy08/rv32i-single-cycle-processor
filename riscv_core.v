module alu (
	alu_a,
	alu_b,
	alu_op,
	alu_res
);
	reg _sv2v_0;
	input wire [31:0] alu_a;
	input wire [31:0] alu_b;
	input wire [3:0] alu_op;
	output reg [31:0] alu_res;
	wire [31:0] tmp;
	assign tmp = alu_a + (alu_a >> 2);
	wire signed [31:0] signed_a;
	wire signed [31:0] signed_b;
	assign signed_a = alu_a;
	assign signed_b = alu_b;
	always @(*) begin
		if (_sv2v_0)
			;
		alu_res = 32'd0;
		case (alu_op)
			4'd0: alu_res = alu_a + alu_b;
			4'd1: alu_res = alu_a - alu_b;
			4'd2: alu_res = alu_a << alu_b[4:0];
			4'd6: alu_res = alu_a >> alu_b[4:0];
			4'd7: alu_res = signed_a >>> alu_b[4:0];
			4'd8: alu_res = alu_a | alu_b;
			4'd9: alu_res = alu_a & alu_b;
			4'd5: alu_res = alu_a ^ alu_b;
			4'd3: alu_res = (signed_a < signed_b ? 32'd1 : 32'd0);
			4'd4: alu_res = (alu_a < alu_b ? 32'd1 : 32'd0);
			4'd10: alu_res = (tmp >= 32'd60 ? 32'd1 : 32'd0);
			default: alu_res = 32'd0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module branch_control (
	opr_a,
	opr_b,
	is_b_type,
	funct3,
	branch_taken
);
	reg _sv2v_0;
	input wire [31:0] opr_a;
	input wire [31:0] opr_b;
	input wire is_b_type;
	input wire [2:0] funct3;
	output wire branch_taken;
	wire signed [31:0] a_signed;
	wire signed [31:0] b_signed;
	assign a_signed = opr_a;
	assign b_signed = opr_b;
	reg taken;
	always @(*) begin
		if (_sv2v_0)
			;
		taken = 1'b0;
		case (funct3)
			3'h0: taken = opr_a == opr_b;
			3'h1: taken = opr_a != opr_b;
			3'h4: taken = a_signed < b_signed;
			3'h5: taken = a_signed >= b_signed;
			3'h6: taken = opr_a < opr_b;
			3'h7: taken = opr_a >= opr_b;
		endcase
	end
	assign branch_taken = is_b_type & taken;
	initial _sv2v_0 = 0;
endmodule
module control (
	r_type,
	i_type,
	s_type,
	b_type,
	u_type,
	j_type,
	funct3,
	funct7,
	opcode,
	pc_sel,
	op1_sel,
	op2_sel,
	alu_op,
	rf_wr_data_sel,
	dmem_req,
	dmem_size,
	dmem_wr_en,
	dmem_zero_extend,
	rf_wr_en
);
	reg _sv2v_0;
	input wire r_type;
	input wire i_type;
	input wire s_type;
	input wire b_type;
	input wire u_type;
	input wire j_type;
	input wire [2:0] funct3;
	input wire [6:0] funct7;
	input wire [6:0] opcode;
	output wire pc_sel;
	output wire op1_sel;
	output wire op2_sel;
	output wire [3:0] alu_op;
	output wire [1:0] rf_wr_data_sel;
	output wire dmem_req;
	output wire [1:0] dmem_size;
	output wire dmem_wr_en;
	output wire dmem_zero_extend;
	output wire rf_wr_en;
	wire [3:0] funct_r;
	wire [3:0] opcode_i;
	wire funct7_bit5;
	assign funct7_bit5 = funct7[5];
	reg [14:0] ctrl_r;
	reg [14:0] ctrl_i;
	reg [14:0] ctrl_s;
	reg [14:0] ctrl_b;
	reg [14:0] ctrl_u;
	reg [14:0] ctrl_j;
	reg [14:0] ctrl;
	assign funct_r = {funct7_bit5, funct3};
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_r = 1'sb0;
		ctrl_r[9] = 1'b1;
		case (funct_r)
			4'h0: ctrl_r[3-:4] = 4'd0;
			4'h8: ctrl_r[3-:4] = 4'd1;
			4'h1: ctrl_r[3-:4] = 4'd2;
			4'h2: ctrl_r[3-:4] = 4'd3;
			4'h3: ctrl_r[3-:4] = 4'd4;
			4'h4: ctrl_r[3-:4] = 4'd5;
			4'h6: ctrl_r[3-:4] = 4'd8;
			4'h7: ctrl_r[3-:4] = 4'd9;
			4'h5: ctrl_r[3-:4] = 4'd6;
			4'hd: ctrl_r[3-:4] = 4'd7;
			4'h9: ctrl_r[3-:4] = 4'd10;
		endcase
	end
	assign opcode_i = {opcode[4], funct3};
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_i = 1'sb0;
		ctrl_i[9] = 1'b1;
		ctrl_i[6] = 1'b1;
		case (opcode_i)
			4'h8: ctrl_i[3-:4] = 4'd0;
			4'ha: ctrl_i[3-:4] = 4'd3;
			4'hb: ctrl_i[3-:4] = 4'd4;
			4'hc: ctrl_i[3-:4] = 4'd5;
			4'he: ctrl_i[3-:4] = 4'd8;
			4'hf: ctrl_i[3-:4] = 4'd9;
			4'h9: ctrl_i[3-:4] = 4'd2;
			4'hd: ctrl_i[3-:4] = (funct7_bit5 ? 4'd7 : 4'd6);
			4'h0: {ctrl_i[14], ctrl_i[12-:2], ctrl_i[5-:2], ctrl_i[10]} = 6'b100010;
			4'h1: {ctrl_i[14], ctrl_i[12-:2], ctrl_i[5-:2], ctrl_i[10]} = 6'b101010;
			4'h2: {ctrl_i[14], ctrl_i[12-:2], ctrl_i[5-:2], ctrl_i[10]} = 6'b111010;
			4'h4: {ctrl_i[14], ctrl_i[12-:2], ctrl_i[5-:2], ctrl_i[10]} = 6'b100011;
			4'h5: {ctrl_i[14], ctrl_i[12-:2], ctrl_i[5-:2], ctrl_i[10]} = 6'b101011;
		endcase
		if (opcode == 7'h67) begin
			ctrl_i[8] = 1'b1;
			ctrl_i[5-:2] = 2'b11;
			ctrl_i[3-:4] = 4'd0;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_s = 1'sb0;
		ctrl_s[14] = 1'b1;
		ctrl_s[13] = 1'b1;
		ctrl_s[6] = 1'b1;
		ctrl_s[3-:4] = 4'd0;
		case (funct3)
			3'h0: ctrl_s[12-:2] = 2'b00;
			3'h1: ctrl_s[12-:2] = 2'b01;
			3'h2: ctrl_s[12-:2] = 2'b11;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_b = 1'sb0;
		ctrl_b[7] = 1'b1;
		ctrl_b[6] = 1'b1;
		ctrl_b[3-:4] = 4'd0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_u = 1'sb0;
		ctrl_u[9] = 1'b1;
		case (opcode)
			7'h17: begin
				ctrl_u[7] = 1'b1;
				ctrl_u[6] = 1'b1;
			end
			7'h37: ctrl_u[5-:2] = 2'b10;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl_j = 1'sb0;
		ctrl_j[9] = 1'b1;
		ctrl_j[5-:2] = 2'b11;
		ctrl_j[7] = 1'b1;
		ctrl_j[6] = 1'b1;
		ctrl_j[8] = 1'b1;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		ctrl = 1'sb0;
		if (r_type)
			ctrl = ctrl_r;
		else if (i_type)
			ctrl = ctrl_i;
		else if (s_type)
			ctrl = ctrl_s;
		else if (b_type)
			ctrl = ctrl_b;
		else if (u_type)
			ctrl = ctrl_u;
		else if (j_type)
			ctrl = ctrl_j;
	end
	assign pc_sel = ctrl[8];
	assign op1_sel = ctrl[7];
	assign op2_sel = ctrl[6];
	assign alu_op = ctrl[3-:4];
	assign rf_wr_data_sel = ctrl[5-:2];
	assign dmem_req = ctrl[14];
	assign dmem_wr_en = ctrl[13];
	assign dmem_size = ctrl[12-:2];
	assign dmem_zero_extend = ctrl[10];
	assign rf_wr_en = ctrl[9];
	initial _sv2v_0 = 0;
endmodule
module decode (
	instruction,
	rs1_addr,
	rs2_addr,
	rd_addr,
	opcode,
	funct3,
	funct7,
	r_type,
	i_type,
	s_type,
	b_type,
	u_type,
	j_type,
	immediate
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output wire [4:0] rs1_addr;
	output wire [4:0] rs2_addr;
	output wire [4:0] rd_addr;
	output wire [6:0] opcode;
	output wire [2:0] funct3;
	output wire [6:0] funct7;
	output reg r_type;
	output reg i_type;
	output reg s_type;
	output reg b_type;
	output reg u_type;
	output reg j_type;
	output wire [31:0] immediate;
	wire [31:0] imm_i_type;
	wire [31:0] imm_s_type;
	wire [31:0] imm_b_type;
	wire [31:0] imm_u_type;
	wire [31:0] imm_j_type;
	assign opcode = instruction[6:0];
	assign rd_addr = instruction[11:7];
	assign funct3 = instruction[14:12];
	assign rs1_addr = instruction[19:15];
	assign rs2_addr = instruction[24:20];
	assign funct7 = instruction[31:25];
	assign imm_i_type = {{20 {instruction[31]}}, instruction[31:20]};
	assign imm_s_type = {{20 {instruction[31]}}, instruction[31:25], instruction[11:7]};
	assign imm_b_type = {{20 {instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
	assign imm_u_type = {instruction[31:12], 12'b000000000000};
	assign imm_j_type = {{12 {instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
	always @(*) begin
		if (_sv2v_0)
			;
		r_type = 1'b0;
		i_type = 1'b0;
		s_type = 1'b0;
		b_type = 1'b0;
		u_type = 1'b0;
		j_type = 1'b0;
		case (opcode)
			7'h33: r_type = 1'b1;
			7'h03, 7'h13, 7'h67: i_type = 1'b1;
			7'h23: s_type = 1'b1;
			7'h63: b_type = 1'b1;
			7'h37, 7'h17: u_type = 1'b1;
			7'h6f: j_type = 1'b1;
		endcase
	end
	assign immediate = (r_type ? 32'd0 : (i_type ? imm_i_type : (s_type ? imm_s_type : (b_type ? imm_b_type : (u_type ? imm_u_type : imm_j_type)))));
	initial _sv2v_0 = 0;
endmodule
module fetch (
	clk,
	reset_n,
	pc,
	imem_req,
	imem_addr,
	imem_data,
	instruction
);
	input wire clk;
	input wire reset_n;
	input wire [31:0] pc;
	output wire imem_req;
	output wire [31:0] imem_addr;
	input wire [31:0] imem_data;
	output wire [31:0] instruction;
	reg req_reg;
	always @(posedge clk or negedge reset_n)
		if (!reset_n)
			req_reg <= 1'b0;
		else
			req_reg <= 1'b1;
	assign imem_req = req_reg;
	assign imem_addr = pc;
	assign instruction = imem_data;
endmodule
module register_file (
	clk,
	reset_n,
	rs1_addr,
	rs2_addr,
	rd_addr,
	rf_wr_en,
	wr_data,
	rs1_data,
	rs2_data
);
	input wire clk;
	input wire reset_n;
	input wire [4:0] rs1_addr;
	input wire [4:0] rs2_addr;
	input wire [4:0] rd_addr;
	input wire rf_wr_en;
	input wire [31:0] wr_data;
	output wire [31:0] rs1_data;
	output wire [31:0] rs2_data;
	reg [31:0] regs [0:31];
	always @(posedge clk or negedge reset_n)
		if (!reset_n) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				regs[i] <= 32'b00000000000000000000000000000000;
		end
		else if (rf_wr_en && (rd_addr != 5'b00000))
			regs[rd_addr] <= wr_data;
	assign rs1_data = (rs1_addr == 5'b00000 ? 32'b00000000000000000000000000000000 : regs[rs1_addr]);
	assign rs2_data = (rs2_addr == 5'b00000 ? 32'b00000000000000000000000000000000 : regs[rs2_addr]);
endmodule
module riscv_core (
	clk,
	reset_n,
	imem_req,
	imem_addr,
	imem_data,
	dmem_req,
	dmem_wr_en,
	dmem_size,
	dmem_zero_extend,
	dmem_addr,
	dmem_wr_data,
	dmem_rd_data
);
	reg _sv2v_0;
	parameter RESET_PC = 32'h00000000;
	input wire clk;
	input wire reset_n;
	output wire imem_req;
	output wire [31:0] imem_addr;
	input wire [31:0] imem_data;
	output wire dmem_req;
	output wire dmem_wr_en;
	output wire [1:0] dmem_size;
	output wire dmem_zero_extend;
	output wire [31:0] dmem_addr;
	output wire [31:0] dmem_wr_data;
	input wire [31:0] dmem_rd_data;
	reg [31:0] pc;
	wire [31:0] next_pc;
	wire [31:0] next_seq_pc;
	wire pc_sel;
	wire [31:0] instruction;
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [4:0] rs1_addr;
	wire [4:0] rs2_addr;
	wire [4:0] rd_addr;
	wire [31:0] rs1_data;
	wire [31:0] rs2_data;
	reg [31:0] wr_data;
	wire [31:0] immediate;
	wire r_type;
	wire i_type;
	wire s_type;
	wire b_type;
	wire u_type;
	wire j_type;
	wire [31:0] alu_a;
	wire [31:0] alu_b;
	wire [31:0] alu_res;
	wire [3:0] alu_op;
	wire [1:0] dmem_size_int;
	wire [1:0] rf_wr_data_sel;
	wire rf_wr_en;
	wire op1_sel;
	wire op2_sel;
	wire branch_taken;
	assign next_seq_pc = pc + 32'd4;
	assign next_pc = (branch_taken | pc_sel ? {alu_res[31:1], 1'b0} : next_seq_pc);
	always @(posedge clk or negedge reset_n)
		if (!reset_n)
			pc <= RESET_PC;
		else
			pc <= next_pc;
	fetch u_fetch(
		.clk(clk),
		.reset_n(reset_n),
		.pc(pc),
		.imem_req(imem_req),
		.imem_addr(imem_addr),
		.imem_data(imem_data),
		.instruction(instruction)
	);
	decode u_decode(
		.instruction(instruction),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr(rd_addr),
		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.r_type(r_type),
		.i_type(i_type),
		.s_type(s_type),
		.b_type(b_type),
		.u_type(u_type),
		.j_type(j_type),
		.immediate(immediate)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		case (rf_wr_data_sel)
			2'b00: wr_data = alu_res;
			2'b01: wr_data = dmem_rd_data;
			2'b10: wr_data = immediate;
			2'b11: wr_data = next_seq_pc;
			default: wr_data = alu_res;
		endcase
	end
	register_file u_register_file(
		.clk(clk),
		.reset_n(reset_n),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr(rd_addr),
		.rf_wr_en(rf_wr_en),
		.wr_data(wr_data),
		.rs1_data(rs1_data),
		.rs2_data(rs2_data)
	);
	control u_control(
		.r_type(r_type),
		.i_type(i_type),
		.s_type(s_type),
		.b_type(b_type),
		.u_type(u_type),
		.j_type(j_type),
		.funct3(funct3),
		.funct7(funct7),
		.opcode(opcode),
		.pc_sel(pc_sel),
		.op1_sel(op1_sel),
		.op2_sel(op2_sel),
		.alu_op(alu_op),
		.rf_wr_data_sel(rf_wr_data_sel),
		.dmem_req(dmem_req),
		.dmem_size(dmem_size_int),
		.dmem_wr_en(dmem_wr_en),
		.dmem_zero_extend(dmem_zero_extend),
		.rf_wr_en(rf_wr_en)
	);
	assign dmem_size = dmem_size_int;
	branch_control u_branch_control(
		.opr_a(rs1_data),
		.opr_b(rs2_data),
		.is_b_type(b_type),
		.funct3(funct3),
		.branch_taken(branch_taken)
	);
	assign alu_a = (op1_sel ? pc : rs1_data);
	assign alu_b = (op2_sel ? immediate : rs2_data);
	alu u_alu(
		.alu_a(alu_a),
		.alu_b(alu_b),
		.alu_op(alu_op),
		.alu_res(alu_res)
	);
	assign dmem_addr = alu_res;
	assign dmem_wr_data = rs2_data;
	initial _sv2v_0 = 0;
endmodule
