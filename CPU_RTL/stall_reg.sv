`timescale 1ns / 1ps

module stall_reg(
    input logic clk_i,
    input logic rst_i,
    input logic mem_req,
    output logic stall
    );
    always_ff @(posedge clk_i or posedge rst_i)
    begin
        if(rst_i)  
            stall <= 1'b0;
        else
            stall <= mem_req & ~stall;      
    end
    
endmodule
