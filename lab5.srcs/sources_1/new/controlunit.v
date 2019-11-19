module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        
        output wire [2:0]  alu_ctrl,
        output wire dst_jal,
        output wire link,
        output wire jr,
        output wire MHI,
        output wire MLO,
        output wire HILO,
        output wire MultToReg,
        output wire shift
    );
    
    wire [1:0] alu_op;

    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op),
        .dst_jal (dst_jal),
        .link (link)      
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .jr (jr),
        .MHI (MHI),
        .MLO (MLO),
        .HILO (HILO),
        .MultToReg (MultToReg),
        .shift (shift)
        
    );

endmodule