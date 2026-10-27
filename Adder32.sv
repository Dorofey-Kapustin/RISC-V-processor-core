`timescale 1ns / 1ps


module Adder32(
    input logic [31:0] a_i,
    input logic [31:0] b_i,
    input logic carry_i,
    output logic [31:0] sum_o,
    output logic carry_o
    );
 
 wire [32:0] P_n;
 assign P_n[0] = carry_i;
  

 
genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: sums
            Adder adder_inst (
                .a_i(a_i[i]), 
                .b_i(b_i[i]), 
                .carry_i(P_n[i]), 
                .sum_o(sum_o[i]), 
                .carry_o(P_n[i+1])
            );
        end 
    endgenerate

 assign carry_o = P_n[32];
  
    
endmodule
