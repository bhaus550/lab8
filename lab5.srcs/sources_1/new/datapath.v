module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire [2:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        //NEW SIGNALS ADDED
        input wire MLO,
        input wire MHI,
        input wire HILO,
        input wire MultToReg,
        input wire link,
        input wire jr,
        input wire shift,
        input wire dst_jal,
        
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3
    );

    wire [4:0]  rf_wa;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire        zero;
    
    //NEW
    wire [31:0] lo, hi, out_lo, out_hi, shift_mux_out, multu_mux_out, MultToReg_mux_out,
        link_mux_out, jr_mux_out;
    wire [4:0] jal_mux_out;
    
    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_jr_mux(
            .sel (jr),
            .a (pc_plus4),
            .b (alu_pa),
            .y (jr_mux_out)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (jr_mux_out),
            .b              (bta),
            .y              (pc_pre)
        );

    mux2 #(32) pc_jmp_mux (
            .sel            (jump),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_next)
        );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (rf_wa)
        );
        
    mux2 #(5) jal_mux(
            .sel (dst_jal),
            .a (rf_wa),
            .b (5'd31),
            .y (jal_mux_out)
        );
        
    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (jal_mux_out),
            .wd             (link_mux_out),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );
    shift_mux shiftmux(
            .sel (shift),
            .a (alu_pa),
            .b (instr[10:6]),
            .y (shift_mux_out)
        );

    Multu multiply(
            .a (alu_pa),
            .b (wd_dm),
            .lo (lo),
            .hi (hi)
        );
    Mflo movelo(
            .clk (clk),
            .rst (rst),
            .wlo (MLO),
            .a (lo),
            .mlo (out_lo)
        );
    Mfhi movehi(
            .clk (clk),
            .rst (rst),
            .whi (MHI),
            .b (hi),
            .mhi (out_hi)
        );
        
    mux2 #(32) multu_mux (
            .sel (HILO),
            .a (out_lo),
            .b (out_hi),
            .y (multu_mux_out)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (shift_mux_out),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out)
        );

    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm),
            .y              (wd_rf)
        );

    mux2 #(32) MultToReg_mux(
            .sel (MultToReg),
            .a (wd_rf),
            .b (multu_mux_out),
            .y (MultToReg_mux_out)
        );
    mux2 #(32) link_mux(
            .sel (link),
            .a (MultToReg_mux_out),
            .b (pc_plus4),
            .y (link_mux_out)
        );
endmodule