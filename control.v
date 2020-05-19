`include "constants.h"

/************** Main control in ID pipe stage  *************/
module control_main(output reg RegDst,
                output reg Branch,  
                output reg MemRead,
                output reg MemWrite,  
                output reg MemToReg,  
                output reg ALUSrc,  
                output reg RegWrite,  
                output reg [1:0] ALUcntrl,  
                input [5:0] opcode);

  always @(*) 
   begin
     case (opcode)
      `R_FORMAT: 
          begin 
            RegDst = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            Branch = 1'b0;         
            ALUcntrl  = 2'b10; // R             
          end
       `LW :   
           begin 
            RegDst = 1'b0;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
        `SW :   
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
       `BEQ:  
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            Branch = 1'b1;
            ALUcntrl = 2'b01; // sub
           end
       default:
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            ALUcntrl = 2'b00; 
         end
      endcase
    end // always
endmodule


/**************** Module for Bypass Detection in EX pipe stage goes here  *********/
 module  control_bypass_ex(output reg [1:0] bypassA,
                       output reg [1:0] bypassB,
                       input [4:0] idex_rs,
                       input [4:0] idex_rt,
                       input [4:0] exmem_rd,
                       input [4:0] memwb_rd,
                       input       exmem_regwrite,
                       input       memwb_regwrite);
					   
		if(exmem_regwrite == 1'b1 && exmem_rd != 5'b00000 && exmem_rd == idex_rs) 
			begin
				bypassA = 2'b10;
			end
		else begin
			if(memwb_regwrite == 1'b1 && (memwb_rd != 5'b00000) && (exmem_regwrite != 1'b1 && exmem_rd != 5'b00000) && (exmem_rd != idex_rs) && (memwb_rd == idex_rs))
			begin
				bypassA = 2'b01;
			end
		end
		else begin
			bypassA = 2'b00;
		end
		
		
		if(exmem_regwrite == 1'b1 && exmem_rd != 5'b00000 && exmem_rd == idex_rt)
				begin
					bypassB = 2'b10;
				end
		else begin
			if(memwb_regwrite == 1'b1 && (memwb_rd != 5'b00000) && (exmem_regwrite != 1'b1 && exmem_rd != 5'b00000) && (exmem_rd != idex_rt) && (memwb_rd == idex_rt))
				begin
					bypassB = 2'b01;
				end
		end
		else begin
			bypassB = 2'b00;
		end
endmodule          
                       

/**************** Module for Stall Detection in ID pipe stage goes here  *********/
module control_hazard_unit(	output reg stall,
							output ifid_write,
							output pc_write,
							input idex_memread,
							input [4:0] idex_rs,
							input [4:0] ifid_rt,
							input [4:0] ifid_rs,
							);


							
	if((idex_memread == 1'b1) && (idex_rt == ifid_rs || idex_rt == ifid_rt))
		stall = 1'b1;
	else
		stall = 1'b0;

/************** control for ALU control in EX pipe stage  *************/
module control_alu(output reg [3:0] ALUOp,                  
               input [1:0] ALUcntrl,
               input [5:0] func);

  always @(ALUcntrl or func)  
    begin
      case (ALUcntrl)
        2'b10: 
           begin
             case (func)
              6'b100000: ALUOp  = 4'b0010; // add
              6'b100010: ALUOp = 4'b0110; // sub
              6'b100100: ALUOp = 4'b0000; // and
              6'b100101: ALUOp = 4'b0001; // or
              6'b100111: ALUOp = 4'b1100; // nor
              6'b101010: ALUOp = 4'b0111; // slt
              default: ALUOp = 4'b0000;       
             endcase 
          end   
        2'b00: 
              ALUOp  = 4'b0010; // add
        2'b01: 
              ALUOp = 4'b0110; // sub
        default:
              ALUOp = 4'b0000;
     endcase
    end
endmodule
