`timescale 1ns / 1ps


module ALU(
    input logic [31:0] a_i,
    input logic [31:0] b_i,
    input logic [4:0] alu_op_i,
    output logic flag_o,
    output logic [31:0] result_o
    );
import alu_opcodes_pkg::*;
wire p_i = 1'b0;
wire p_o;
wire [31:0] sum;
wire [31:0] result_sub;
wire p_sub;
Adder32 sas(.a_i(a_i), .b_i(b_i),  .carry_i(p_i), .sum_o(sum), .carry_o(p_o));
Adder32 substractor(.a_i(a_i), .b_i(~b_i), .carry_i(1'b1), .sum_o(result_sub), .carry_o(p_sub));

always_comb
begin
    result_o = 32'b0;
    case(alu_op_i)
    ALU_ADD: result_o = sum;
    ALU_SUB: result_o = result_sub; 
    ALU_SLL: result_o = a_i << b_i[4:0];
    ALU_SRL: result_o = a_i >> b_i[4:0];
    ALU_SRA: result_o = $signed(a_i) >>> b_i[4:0];
    ALU_SLTS: result_o = {31'd0, ($signed(a_i) < $signed(b_i))}; // assic realisation
    ALU_SLTU: result_o = {31'd0, (a_i < b_i)}; //asic realisation
    ALU_XOR: result_o = a_i ^ b_i;
    ALU_OR: result_o = a_i | b_i;
    ALU_AND: result_o = a_i & b_i;
    
    default: result_o = 32'b0;
    endcase
end

always_comb
begin
    flag_o = 1'b0;
    case(alu_op_i)    
    ALU_EQ: flag_o = (a_i == b_i); //переделать на asic 
    ALU_NE: flag_o = (a_i != b_i); //переделать на asic
    ALU_LTS: flag_o = $signed(a_i) < $signed(b_i); //asic realisation
    ALU_GES: flag_o = $signed(a_i) >= $signed(b_i); //asic
    ALU_LTU: flag_o = (a_i < b_i);
    ALU_GEU: flag_o = (a_i >= b_i);
    default: flag_o = 1'b0;
    endcase
end
endmodule
