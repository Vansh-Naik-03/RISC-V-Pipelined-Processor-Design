module control_unit (
    input  [6:0] opcode,
    output reg   reg_write,
    output reg   alu_src,
    output reg   mem_to_reg,
    output reg   mem_read,
    output reg   mem_write,
    output reg   branch,
    output reg   jump,
    output reg   jalr,
    output reg   lui,
    output reg   auipc,
    output reg [1:0] alu_op
);
always @(*) begin
    // Defaults (safe NOP state)
    reg_write  = 0;
    alu_src    = 0;
    mem_to_reg = 0;
    mem_read   = 0;
    mem_write  = 0;
    branch     = 0;
    jump       = 0;
    jalr       = 0;
    lui        = 0;
    auipc      = 0;
    alu_op     = 2'b00;

    case (opcode)
        // R-type: ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA
        7'b0110011: begin
            reg_write = 1;
            alu_op    = 2'b10;
        end

        // I-type ALU: ADDI, ANDI, ORI, XORI, SLTI, SLLI, SRLI, SRAI
        7'b0010011: begin
            reg_write = 1;
            alu_src   = 1;
            alu_op    = 2'b10;
        end

        // LOAD: LW, LH, LB, LHU, LBU
        7'b0000011: begin
            reg_write  = 1;
            alu_src    = 1;
            mem_to_reg = 1;
            mem_read   = 1;
            alu_op     = 2'b00;
        end

        // STORE: SW, SH, SB
        7'b0100011: begin
            alu_src   = 1;
            mem_write = 1;
            alu_op    = 2'b00;
        end

        // BRANCH: BEQ, BNE, BLT, BGE, BLTU, BGEU
        7'b1100011: begin
            branch = 1;
            alu_op = 2'b01;
        end

        // JAL
        7'b1101111: begin
            reg_write = 1;
            jump      = 1;
        end

        // JALR
        7'b1100111: begin
            reg_write = 1;
            alu_src   = 1;
            jalr      = 1;
            alu_op    = 2'b00;
        end

        // LUI
        7'b0110111: begin
            reg_write = 1;
            alu_src   = 1;
            lui       = 1;
        end

        // AUIPC
        7'b0010111: begin
            reg_write = 1;
            alu_src   = 1;
            auipc     = 1;
            alu_op    = 2'b00;
        end

        default: begin
            // NOP / undefined — all signals remain 0
        end
    endcase
end

endmodule
