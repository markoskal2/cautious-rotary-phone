# MIPS CPU written in Verilog

A classic 5-stage pipeline MIPS 32-bit processor, including a 2-bit branch predictor, a 1024 depth branch prediction buffer, a 2KB direct-mapped cache and a 64K main memory.

- 5 stage pipeline
	-Instruction Fetch (IF)
	-Instruction Decode (ID)
	-Execute (EX)
	-Memory Access (MEM)
	-Writeback (WB)

- Static branch not taken branch predictor

- Able to forward from memory (Stage 4) and Write Back (Stage 5) to avoid stalls

- Branch detection in decode (stage 2)

- Hazard Detection Unit to insert stalls (nop cycles) wherever required.

This MIPS processor is implemented according to "Computer Organization and Design" by David A.Patternson & John L.Hennsessy.

![hello](https://ibb.co/mSqyTnY)

