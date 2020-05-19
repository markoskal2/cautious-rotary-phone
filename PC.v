module PC (instr, reset, clk, Branch, zero, pc);

input reset, clk;
input [31:0] instr;
input Branch, zero;

output reg [31:0] pc;

wire [31:0] new_pc;
wire [31:0] pcInc, sign_ext, add;

assign sel = Branch & zero;
assign pcInc = pc + 4;
assign sign_ext = {{16{instr[15]}}, instr[15:0]};
assign sign_ext = sign_ext << 2;
assign add = pcInc + sign_ext;

assign new_pc = sel ? add : pcInc;

always@(negedge clk)

	begin
		pc <= new_pc;
	end
	
endmodule

