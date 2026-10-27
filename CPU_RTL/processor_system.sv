`timescale 1ns / 1ps


module processor_system(
    input logic clk_i,
    input logic rst_i
    );

wire [31:0] read_addr;
wire [31:0] read_data;
instr_mem imem(.read_addr_i(read_addr), .read_data_o(read_data));

//module processor_core (
//input logic clk_i,
//input logic rst_i,
//input logic stall_i,
//input logic [31:0] instr_i,
//input logic [31:0] mem_rd_i,
//output logic [31:0] instr_addr_o,
//output logic [31:0] mem_addr_o,
//output logic [ 2:0] mem_size_o,
//output logic mem_req_o,
//output logic mem_we_o,
//output logic [31:0] mem_wd_o
//);
wire mem_req;
wire stall;
wire [31:0] mem_rd;
wire [31:0] mem_addr;
wire mem_we;
wire [31:0] mem_wd;

processor_core core(.clk_i(clk_i), .rst_i(rst_i), .stall_i(stall), .instr_i(read_data), .instr_addr_o(read_addr),
.mem_rd_i(mem_rd), .mem_addr_o(mem_addr), .mem_size_o(), .mem_req_o(mem_req), .mem_we_o(mem_we), .mem_wd_o(mem_wd));

//input logic clk_i,
//    input logic rst_i,
//    input logic mem_req,
//    output logic stall
stall_reg stol(.clk_i(clk_i), .rst_i(rst_i), .mem_req(mem_req), .stall(stall));    


//nput  logic        clk_i,
//  input  logic        mem_req_i,
//  input  logic        write_enable_i,
//  input  logic [ 3:0] byte_enable_i,
//  input  logic [31:0] addr_i,
//  input  logic [31:0] write_data_i,
//  output logic [31:0] read_data_o,
//  output logic        ready_o

data_mem mem(.clk_i(clk_i), .mem_req_i(mem_req), .write_enable_i(mem_we), .byte_enable_i(4'b1111),
.addr_i(mem_addr), .write_data_i(mem_wd), .read_data_o(mem_rd), .ready_o());

endmodule
