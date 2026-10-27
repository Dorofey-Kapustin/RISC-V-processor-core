module decoder (
input logic [31:0] fetched_instr_i,
output logic [1:0] a_sel_o,
output logic [2:0] b_sel_o,
output logic [4:0] alu_op_o,
output logic [2:0] csr_op_o,
output logic csr_we_o,
output logic mem_req_o,
output logic mem_we_o,
output logic [2:0] mem_size_o,
output logic gpr_we_o,
output logic [1:0] wb_sel_o,
output logic illegal_instr_o,
output logic branch_o,
output logic jal_o,
output logic jalr_o,
output logic mret_o
);
import decoder_pkg::*;

reg [6:0] func7;
reg [2:0] func3;

always_comb
begin
a_sel_o = 2'b0;
b_sel_o = 3'b0;
alu_op_o = 5'b0;
csr_op_o = 3'b0;
csr_we_o = 1'b0;
mem_req_o = 1'b0;
mem_we_o = 1'b0;
mem_size_o = 3'b0;
gpr_we_o = 1'b0;
wb_sel_o = 2'b0;
illegal_instr_o = 1'b0;
branch_o = 1'b0;
jal_o = 1'b0;
jalr_o = 1'b0;
mret_o = 1'b0;
func7 = 7'b0;
func3 = 3'b0;

    if (fetched_instr_i[1:0] != 2'b11)
    begin
        illegal_instr_o = 1'b1;
    end
    else
    begin
        case(fetched_instr_i[6:2])
            OP_OPCODE : begin
             func7 = fetched_instr_i[31:25]; 
             func3 = fetched_instr_i[14:12];
             case({func7,func3})
                10'b0000000000 : begin 
                    alu_op_o = ALU_ADD;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0100000000 : begin
                    alu_op_o = ALU_SUB;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000100 :begin
                    alu_op_o = ALU_XOR;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000110 :begin
                    alu_op_o = ALU_OR;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000111 :begin
                    alu_op_o = ALU_AND;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000001 :begin
                    alu_op_o = ALU_SLL;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000101 :begin
                    alu_op_o = ALU_SRL;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0100000101 :begin
                    alu_op_o = ALU_SRA;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000010 :begin
                    alu_op_o = ALU_SLTS;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                10'b0000000011 :begin
                    alu_op_o = ALU_SLTU;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_RS2;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
            default : begin
                illegal_instr_o = 1'b1; 
            end
            endcase
            end
            OP_IMM_OPCODE : begin
            func3 = fetched_instr_i[14:12];
            func7 = fetched_instr_i[31:25];
            case(func3)
            3'b000 : begin  
                alu_op_o = ALU_ADD;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;
            end
            3'b001 : begin  
                if (func7 == 7'b0000000) begin
                    alu_op_o = ALU_SLL;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                else begin
                    illegal_instr_o = 1'b1;  
                end
            end
            3'b010 : begin  
                alu_op_o = ALU_SLTS;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;    
            end
            3'b011 : begin  
                alu_op_o = ALU_SLTU;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;
            end
                3'b100 : begin  
                alu_op_o = ALU_XOR;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;
            end
            3'b101 : begin  // SRLI или SRAI
                if (func7 == 7'b0000000) begin
                    alu_op_o = ALU_SRL;  
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                else if (func7 == 7'b0100000) begin
                    alu_op_o = ALU_SRA;  
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_EX_RESULT;
                    gpr_we_o = 1'b1;
                end
                else begin
                    illegal_instr_o = 1'b1; 
                end
            end
            3'b110 : begin  
                alu_op_o = ALU_OR;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;
            end
            3'b111 : begin  
                alu_op_o = ALU_AND;
                a_sel_o = OP_A_RS1;
                b_sel_o = OP_B_IMM_I;
                wb_sel_o = WB_EX_RESULT;
                gpr_we_o = 1'b1;
            end
            default : begin
                illegal_instr_o = 1'b1;
            end
            endcase
                
            
            end
            LOAD_OPCODE : begin
            func3 = fetched_instr_i[14:12];
            case(func3)
                3'b000 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_B;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_LSU_DATA;
                    gpr_we_o = 1'b1;
                end
                3'b001 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_H;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_LSU_DATA;
                    gpr_we_o = 1'b1;
                end
                3'b010 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_W;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_LSU_DATA;
                    gpr_we_o = 1'b1;
                end
                3'b100 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_BU;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_LSU_DATA;
                    gpr_we_o = 1'b1;
                end
                3'b101 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_HU;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_I;
                    wb_sel_o = WB_LSU_DATA;
                    gpr_we_o = 1'b1;
                end
            default : begin
                illegal_instr_o = 1'b1;  
            end
            endcase
            end
            STORE_OPCODE : begin 
            func3 = fetched_instr_i[14:12];
            case(func3)
               3'b000 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_B;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_S;
                    mem_we_o = 1'b1;
               end
               3'b001 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_H;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_S;
                    mem_we_o = 1'b1;
               end
               3'b010 : begin
                    alu_op_o = ALU_ADD;
                    mem_req_o = 1;
                    mem_size_o = LDST_W;
                    a_sel_o = OP_A_RS1;
                    b_sel_o = OP_B_IMM_S;
                    mem_we_o = 1'b1;
               end
            default : begin
                illegal_instr_o = 1'b1;  
            end
            endcase
            end
            BRANCH_OPCODE : begin
                func3 = fetched_instr_i[14:12];
                case(func3)
                   3'b000: begin
                      alu_op_o = ALU_EQ;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end
                   3'b001: begin
                      alu_op_o = ALU_NE;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end
                    3'b100: begin
                      alu_op_o = ALU_LTS;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end 
                   3'b101: begin
                      alu_op_o = ALU_GES;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end
                   3'b110: begin
                      alu_op_o = ALU_LTU;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end
                   3'b111: begin
                      alu_op_o = ALU_GEU;
                      a_sel_o = OP_A_RS1;
                      b_sel_o = OP_B_RS2;
                      branch_o = 1'b1;
                   end  
                   default : begin
                       illegal_instr_o = 1'b1;  
                   end    
                endcase
            end
            JALR_OPCODE : begin 
                func3 = fetched_instr_i[14:12];
                case(func3)
                    3'b000: begin
                        alu_op_o = ALU_ADD;
                        a_sel_o = OP_A_CURR_PC;
                        b_sel_o = OP_B_INCR;
                        jalr_o = 1'b1;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_EX_RESULT;
                    end
                    default : begin
                        illegal_instr_o = 1'b1; 
                    end
                endcase
            end
            JAL_OPCODE : begin
                alu_op_o = ALU_ADD;
                a_sel_o = OP_A_CURR_PC;
                b_sel_o = OP_B_INCR;
                jal_o = 1'b1;
                gpr_we_o = 1'b1;
                wb_sel_o = WB_EX_RESULT;
            end
            LUI_OPCODE : begin
                alu_op_o = ALU_ADD;
                a_sel_o = OP_A_ZERO;
                b_sel_o = OP_B_IMM_U;
                gpr_we_o = 1'b1;
                wb_sel_o = WB_EX_RESULT;
            end
            AUIPC_OPCODE: begin
                alu_op_o = ALU_ADD;
                a_sel_o = OP_A_CURR_PC;
                b_sel_o = OP_B_IMM_U;
                gpr_we_o = 1'b1;
                wb_sel_o = WB_EX_RESULT;
            end
            SYSTEM_OPCODE : begin
            func3 = fetched_instr_i[14:12];
            if (func3 == 3'b000) begin
                if (fetched_instr_i == 32'h00000073) begin  
                    illegal_instr_o = 1'b1;
                end
                else if (fetched_instr_i == 32'h00100073) begin  
                    illegal_instr_o = 1'b1;
                end
                else if (fetched_instr_i == 32'h30200073) begin  
                    mret_o = 1'b1;
                end
                else begin
                    illegal_instr_o = 1'b1;
                end
            end
            else begin
                case(func3)
                    3'b001 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RW;
                        a_sel_o = OP_A_RS1;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    3'b010 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RS;
                        a_sel_o = OP_A_RS1;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    3'b011 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RC;
                        a_sel_o = OP_A_RS1;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    3'b101 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RWI;
                        a_sel_o = OP_A_ZERO;
                        b_sel_o = OP_B_IMM_I;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    3'b110 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RSI;
                        a_sel_o = OP_A_ZERO;
                        b_sel_o = OP_B_IMM_I;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    3'b111 : begin 
                        csr_we_o = 1'b1;
                        csr_op_o = CSR_RCI;
                        a_sel_o = OP_A_ZERO;
                        b_sel_o = OP_B_IMM_I;
                        gpr_we_o = 1'b1;
                        wb_sel_o = WB_CSR_DATA;
                    end
                    default : begin
                    illegal_instr_o = 1'b1;
                    end
            endcase
            end
            end
       MISC_MEM_OPCODE : begin
            func3 = fetched_instr_i[14:12];
            if (func3 == 3'b000) begin
            end
            else begin
                illegal_instr_o = 1'b1;
            end
        end
        default : begin
            illegal_instr_o = 1'b1; 
        end
        endcase
    end
end
endmodule