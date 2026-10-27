`timescale 1ns / 1ps


module PC(
    input logic clk_i,
    input logic stall_i,
    input logic rst_i,
    input logic jalr,
    input logic [31:0] sign,
    input logic [31:0] increment,
    output logic [31:0] PC_o
    );
    wire [31:0] res;
    wire po;

Adder32 sas(.a_i(PC_o), .b_i(increment), .carry_i(1'b0), .sum_o(res), .carry_o(po)); 

    always_ff @(posedge clk_i or posedge rst_i)
    begin
        if(rst_i)
        PC_o <= 32'b0;
        else if (!stall_i)
            PC_o <= (jalr ? sign : res);
    end
    
endmodule
