module pipelined_alu_tb;
    // Clock and Reset
    reg clk;
    reg reset;
    // Inputs
    reg [31:0] a_in;
    reg [31:0] b_in;
    reg [2:0]  op_in;
    reg [4:0]  rs1_in;
    reg [4:0]  rs2_in;
    reg [4:0]  rd_in;
    reg        reg_write_in;
    // Outputs
    wire [31:0] alu_out;
    wire [4:0]  rd_out;
    wire        reg_write_out;
    pipelined_alu DUT (
        .clk(clk),
        .reset(reset),
        .a_in(a_in),
        .b_in(b_in),
        .op_in(op_in),
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .rd_in(rd_in),
        .reg_write_in(reg_write_in),
        .alu_out(alu_out),
        .rd_out(rd_out),
        .reg_write_out(reg_write_out)
    );)
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        a_in = 0;
        b_in = 0;
        op_in = 0;
        rs1_in = 0;
        rs2_in = 0;
        rd_in  = 0;
        reg_write_in = 0;
        #10 reset = 0;
        // x5 = x1 + x2
        #10;
        a_in = 10;
        b_in = 5;
        op_in = 3'b000; // ADD
        rs1_in = 1;
        rs2_in = 2;
        rd_in  = 5;
        reg_write_in = 1;
        // x6 = x5 - x3
        #10;
        a_in = 15;
        b_in = 3;
        op_in = 3'b001; // SUB
        rs1_in = 5;
        rs2_in = 3;
        rd_in  = 6;
        reg_write_in = 1;
        // TEST 3 : AND
        #10;
        a_in = 8;
        b_in = 4;
        op_in = 3'b010; // AND
        rs1_in = 7;
        rs2_in = 8;
        rd_in  = 9;
        reg_write_in = 1;
        // TEST 4 : Another ADD
        #10;
        a_in = 20;
        b_in = 10;
        op_in = 3'b000;
        rs1_in = 2;
        rs2_in = 3;
        rd_in  = 4;
        reg_write_in = 1;
        #100;
        $finish;
    end
    initial begin
        $monitor("Time=%0t | ALU_OUT=%d | RD=%d | REG_WRITE=%b",
                 $time, alu_out, rd_out, reg_write_out);
    end
endmodule
endmodule
