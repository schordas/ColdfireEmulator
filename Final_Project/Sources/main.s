
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
	jsr LOADINST  
	cmp.l #0x1, d1
	beq ADD	
	cmp.l #0x2, d1
	beq ADDI
	//d0 will be entire line
	//d1 - opcode
	//d2 - rs
	//d3 - rt
	//d4 - immediate
LOADINST:
	move.l (a1)+, d0
	move.l d0, d1
	move.l d0, d2
	move.l d0, d3
	move.l d0, d4
	move.l d0, d5
	lsr.l #8, d1 //this is opcode
	lsr.l #8, d1
	lsr.l #8, d1
	lsr.l #2, d1
	lsr.l #8, d2 //rs
	lsr.l #8, d2
	lsr.l #8, d2
	lsl.l #6, d2
	lsr.l #8, d3 //rt
	lsr.l #8, d3
	lsr.l #4, d3
	lsl.l #8, d3
	lsl.l #1, d3
	lsr.l #8, d4 //rd
	lsr.l #8, d4
	lsr.l #1, d4
	lsl.l #8, d4
	lsl.l #4, d4
	lsl.l #8, d5 //imm
	lsl.l #8, d5
	lsl.l #2, d5
	lsr.l #8, d5
	lsr.l #8, d5
	lsr.l #2, d5
	rts
ADD:
	clr.l d6
	mulu #32, d2 
	add.l d2, a4 
	move.l (a4), d6//pulls value of rs register
	movea.l a3, a4
	mulu #32, d3
	add.l d3, a4
	move.l (a4), d2//pulls value of rt register
	movea.l a3, a4
	mulu #32, d4
	add.l d4, a4
	add.l d6, d2
	move.l d2, (a4)//saves sum in rd register
	movea.l a3, a4
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	bra DECODE
ADDI:
	clr.l d6
	mulu #32, d2 
	add.l d2, a4 
	move.l (a4), d6//pulls value of rs register
	movea.l a3, a4
	add.l d2, d5
	mulu #32, d3
	add.l d3, a4
	move.l d5, (a4)//pulls value of rt register
	movea.l a3, a4
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	bra DECODE
LOAD:
BE:
BNE:
SUBI:
READ:
DIS:
END:

inflp:	bra.s	inflp
		rts

