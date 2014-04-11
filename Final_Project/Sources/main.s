
// Place static data declarations/directives here
  		.data
// Replace declaration below.
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:	
INIT:
	//a0 for starting address
	movea.l #0x20005c1c, a0	
	//a1 will be stack pointer
	movea.l a0, a1
	//hard code machine code for program we will run
	move.l #0x0810000F, (a1)+
	move.l #0x04040000, (a1)+
	move.l #0x040C0000, (a1)+
	move.l #0xC3000000, (a1)+
	move.l #0x0840000A, (a1)+
	move.l #0x12600008, (a1)+
	move.l #0x052C0000, (a1)+
	move.l #0x20900001, (a1)+
	move.l #0x181FFFF8, (a1)+
	move.l #0x81000001, (a1)+
	move.l #0x00900001, (a1)+
	//return a1 to bottom of stack
	movea.l a0, a1
	//a3 used as an array for the registers R0-R7
	movea.l #0x20005bec, a3
	//a4 as stack pointer for reg array
	movea.l a3, a4
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	move.l #0x0, (a4)+
	
	movea.l a3, a4
	
DECODE:
	clr.l d0
	
	move.l (a1), d0
	move.l d0, d1
	move.l d0, d2
	move.l d0, d3
	move.l d0, d4
	move.l d0, d5
	lsr.l #26, d1 //this is opcode
	lsr.l #23, d2 //rs
	lsl.l #6, d2
	lsr.l #20, d3 //rt
	lsl.l #9, d3
	lsr.l #17, d4 //rd
	lsl.l #12, d4
	lsl.l #18, d5 //imm
	lsr.l #18, d5
	cmp.l #0x1, d1
	beq ADD	
	//d0 will be entire line
	//d1 - opcode
	//d2 - rs
	//d3 - rt
	//d4 - immediate
ADD:
	
ADDI:
LOAD:
BE:
BNE:
SUBI:
READ:
DIS:
END:

inflp:	bra.s	inflp
		rts

