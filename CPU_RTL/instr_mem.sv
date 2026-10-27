`timescale 1ns / 1ps


module instr_mem(
    input logic [31:0] read_addr_i,
    output logic [31:0] read_data_o
    );
import memory_pkg::INSTR_MEM_SIZE_BYTES;
import memory_pkg::INSTR_MEM_SIZE_WORDS;

logic [31:0 ] ROM [INSTR_MEM_SIZE_WORDS];
initial begin
    $readmemh("program.mem", ROM);
end

assign read_data_o =
ROM[read_addr_i[$clog2(INSTR_MEM_SIZE_BYTES)-1:2]];

endmodule
