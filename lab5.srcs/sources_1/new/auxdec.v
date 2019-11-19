module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [2:0] alu_ctrl,
        output wire jr,
        output wire MHI,
        output wire MLO,
        output wire HILO,
        output wire MultToReg,
        output wire shift
    );

    reg [2:0] ctrl;

    assign {alu_ctrl} = ctrl;
    
    reg [5:0] ctrl2;
    assign {jr, MHI, MLO, HILO, MultToReg, shift} = ctrl2;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00:
                begin
                    ctrl = 3'b010; // ADD
                    ctrl2 = 6'b000x00;
                end
            2'b01:
                begin
                    ctrl = 3'b110; // SUB
                    ctrl2 = 6'b000x00;
                end
            default: case (funct)
                6'b10_0100:
                    begin
                        ctrl = 3'b000; // AND
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                6'b10_0101:
                    begin
                        ctrl = 3'b001; // OR
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                6'b10_0000:
                    begin
                        ctrl = 3'b010; // ADD
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                6'b10_0010:
                    begin

                        ctrl = 3'b110; // SUB
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                6'b10_1010:
                    begin
                        ctrl = 3'b111; // SLT
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                //NEW//
                6'b00_0000:
                    begin
                        ctrl = 3'b100; //SLL
                        ctrl2 = 6'b0_0_0_x_0_1;
                    end
                6'b00_0010:
                    begin
                        ctrl = 3'b101; //SRL
                        ctrl2 = 6'b0_0_0_x_0_1;
                    end
                6'b00_1000:
                    begin
                        ctrl = 3'b011; //JR
                        ctrl2 = 6'b1_0_0_x_0_0;
                    end
                6'b01_0000:
                    begin
                        ctrl = 3'bxxx;
                        ctrl2 = 6'b0_0_0_1_1_0; //Mfhi
                    end
                6'b01_0010:
                    begin
                        ctrl = 3'bxxx; //Mflo
                        ctrl2 = 6'b0_0_0_0_1_0;
                    end
                6'b01_1001:
                    begin
                        ctrl = 3'bxxx; //Multu
                        ctrl2 = 6'b0_1_1_x_x_0;
                    end
                default:
                    begin
                        ctrl = 3'bxxx;
                        ctrl2 = 6'b0_0_0_x_0_0;
                    end
                endcase
        endcase
    end
endmodule