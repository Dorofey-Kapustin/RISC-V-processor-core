module processor_core (
input logic clk_i,
input logic rst_i,
input logic stall_i,
input logic [31:0] instr_i,
input logic [31:0] mem_rd_i,
output logic [31:0] instr_addr_o,
output logic [31:0] mem_addr_o,
output logic [ 2:0] mem_size_o,
output logic mem_req_o,
output logic mem_we_o,
output logic [31:0] mem_wd_o
);



wire [1:0] a_sel;
wire [2:0] b_sel;
wire [4:0] alu_op;
wire gpr_we;
wire [1:0] wb_sel;
wire branch;
wire jal;
wire jalr;
decoder coc(.fetched_instr_i(instr_i), .a_sel_o(a_sel), .b_sel_o(b_sel), .alu_op_o(alu_op), .csr_op_o(), .csr_we_o(), .mem_req_o(mem_req_o), 
.mem_we_o(mem_we_o), .mem_size_o(mem_size_o), .gpr_we_o(gpr_we), .wb_sel_o(wb_sel), .illegal_instr_o(), .branch_o(branch), .jal_o(jal), .jalr_o(jalr),
.mret_o());

wire [31:0] read_data1;
wire [31:0] read_data2;
reg [31:0] wb_data;
register_file fef( .clk_i(clk_i), .write_enable_i(gpr_we & ~stall_i), .write_addr_i(instr_i[11:7]), .read_addr1_i(instr_i[19:15]), .read_addr2_i(instr_i[24:20]),
.write_data_i(wb_data), .read_data1_o(read_data1), .read_data2_o(read_data2));

assign mem_wd_o = read_data2;

wire [11:0] imm_I;
wire [31:0] imm_U;
wire [11:0] imm_S;
wire [12:0] imm_B;
wire [20:0] imm_J;
assign imm_U = {instr_i[31:12], 12'h000};
assign imm_S = {instr_i[31:25], instr_i[11:7]};
assign imm_B = {instr_i[31],instr_i[7],instr_i[30:25], instr_i[11:8], 1'b0};
assign imm_J = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
assign imm_I = instr_i[31:20];

wire [31:0] PC_o;
wire [31:0] cas1;
wire flag_o;


assign cas1 = branch ? {{19{imm_B[12]}},imm_B} : {{11{imm_J[20]}}, imm_J};

wire [31:0] res;
Adder32 ksas(.a_i(read_data1), .b_i({{20{imm_I[11]}}, imm_I}), .carry_i(1'b0), .sum_o(res), .carry_o());

wire [31 :0] cas2;

assign cas2 = jal | (flag_o & branch) ? cas1 : 32'd4;

PC PC(.clk_i(clk_i), .stall_i(stall_i), .rst_i(rst_i), .jalr(jalr), .sign({res[31:1],1'b0}), .increment(cas2), .PC_o(PC_o));

assign instr_addr_o = PC_o;


reg [31:0] a; 
always_comb
begin
case(a_sel)
    2'b00 : a = read_data1;
    2'b01 : a = PC_o;
    2'b10 : a = 32'b0;
    default : a = read_data1;
endcase
end

reg [31:0] b; 
always_comb
begin
case(b_sel)
    3'b000 : b = read_data2;
    3'b001 : b = {{20{imm_I[11]}}, imm_I};
    3'b010 : b = imm_U;
    3'b011 : b = {{20{imm_S[11]}}, imm_S};
    3'b100 : b = 32'd4;
    default : b = read_data2;
endcase
end

wire [31:0] alu_o;
ALU LAL(.a_i(a), .b_i(b), .alu_op_i(alu_op), .flag_o(flag_o), .result_o(alu_o)); 
assign mem_addr_o = alu_o;

always_comb
begin
case(wb_sel)
    2'b00 : wb_data = alu_o;
    2'b01 : wb_data = mem_rd_i;
    default :  wb_data = alu_o;
endcase
end

endmodule
