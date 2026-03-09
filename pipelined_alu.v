module pipelined_alu (
    input  wire        clk,
    input  wire        reset,
    // ALU Inputs
    input  wire [31:0] a_in,
    input  wire [31:0] b_in,
    input  wire [2:0]  op_in,
    // Register identifiers
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    // Register write control
    input  wire        reg_write_in,
    // Outputs (Writeback stage)
    output reg  [31:0] alu_out,
    output reg  [4:0]  rd_out,
    output reg         reg_write_out);

    reg [31:0] a_s1, b_s1;
    reg [4:0]  rs1_s1, rs2_s1, rd_s1;
    reg [2:0]  op_s1;
    reg        rw_s1;
    
    reg [31:0] res_s2;
    reg [4:0]  rd_s2;
    reg        rw_s2;

    reg [31:0] forward_a;
    reg [31:0] forward_b;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a_s1   <= 32'd0;
            b_s1   <= 32'd0;
            rs1_s1 <= 5'd0;
            rs2_s1 <= 5'd0;
            rd_s1  <= 5'd0;
            op_s1  <= 3'd0;
            rw_s1  <= 1'b0;
        end 
        else begin
            a_s1   <= a_in;
            b_s1   <= b_in;
            rs1_s1 <= rs1_in;
            rs2_s1 <= rs2_in;
            rd_s1  <= rd_in;
            op_s1  <= op_in;
            rw_s1  <= reg_write_in;
        end
    end
    always @(*) begin
        forward_a = a_s1;
        forward_b = b_s1;
        // Forwarding condition
        if (rw_s2 && (rd_s2 != 5'd0)) begin
            if (rd_s2 == rs1_s1)
                forward_a = res_s2;
            if (rd_s2 == rs2_s1)
                forward_b = res_s2;
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            res_s2 <= 32'd0;
            rd_s2  <= 5'd0;
            rw_s2  <= 1'b0;
        end 
        else begin
            rd_s2 <= rd_s1;
            rw_s2 <= rw_s1;
            case (op_s1)
                3'b000: res_s2 <= forward_a + forward_b; // ADD
                3'b001: res_s2 <= forward_a - forward_b; // SUB
                3'b010: res_s2 <= forward_a & forward_b; // AND
                default: res_s2 <= 32'd0;
            endcase
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_out       <= 32'd0;
            rd_out        <= 5'd0;
            reg_write_out <= 1'b0;
        end 
        else begin
            alu_out       <= res_s2;
            rd_out        <= rd_s2;
            reg_write_out <= rw_s2;
        end
    end
endmodule
