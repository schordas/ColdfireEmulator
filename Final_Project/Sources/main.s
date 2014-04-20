
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
//
	/* Initialize the LED's. */
	move.l #0x0,d0
	move.b d0,0x4010006F // Set pins to be used GPIO.
	move.l #0xFFFFFFFF,d0
	move.b d0,0x40100027 // Set LED's as output.

	// Initial value 0000 for the LED's:
	move.l #0x0,d1
	move.b d1,0x4010000F

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
	clr.l d0
	
DECODE:
	bra.s LOADINST
COMP: 
	cmp.l #0x1, d1
	beq ADD	
	cmp.l #0x2, d1
	beq ADDI
	cmp.l #0x4, d1
	beq BE
	cmp.l #0x6, d1
	beq BNE
	cmp.l #0x8, d1
	beq SUBI
	cmp.l #0x30, d1
	beq READ
	cmp.l #0x20, d1
	beq DIS
	cmp.l #0x0, d1
	beq END
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
	lsl.l #6, d2 //rs (rt for READS)
	lsr.l #8, d2
	lsr.l #8, d2
	lsr.l #8, d2
	lsr.l #5, d2
	lsl.l #8, d3 //rt
	lsl.l #1, d3
	lsr.l #8, d3
	lsr.l #8, d3
	lsr.l #8, d3
	lsr.l #5, d3
	lsl.l #8, d4 //rd and/or imm
	lsl.l #4, d4
	lsr.l #8, d4
	lsr.l #4, d4
	//lsl.l #8, d5 //imm
	//lsl.l #8, d5
	//lsl.l #2, d5
	//lsr.l #8, d5
	//lsr.l #8, d5
	//lsr.l #2, d5
	bra COMP
ADD:
	lsr.l #8, d4 //split last 20 bits to extract rd 
	lsr.l #8, d4
	lsr.l #1, d4
	clr.l d6
	mulu #4, d2 
	add.l d2, a4 
	move.l (a4), d6//pulls value of rs register
	movea.l a3, a4
	mulu #4, d4
	add.l d4, a4
	move.l (a4), d2//pulls value of rt register
	movea.l a3, a4
	mulu #4, d3
	add.l d3, a4
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
	mulu #4, d2 
	add.l d2, a4 
	move.l (a4), d6//pulls value of rs register
	movea.l a3, a4
	add.l d6, d4 //d4 holds immediate value
	mulu #4, d3
	add.l d3, a4
	//clr.l d2
	move.l d4, (a4)//pulls value of rt register
	movea.l a3, a4
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	bra DECODE
BE:
	clr.l d6
	mulu #4, d2
	add.l d2, a4
	move.l (a4), d6 //pulls value of rs register
	movea.l a3, a4
	mulu #4, d3
	add.l d3, a4
	move.l (a4), d2
	cmp.l d2, d6
	bne NOTEQ
	add.l d4, a1	
	NOTEQ:
		clr.l d1
		clr.l d2
		clr.l d3
		clr.l d4
		clr.l d5
		clr.l d6
		movea.l a3, a4
		bra DECODE
BNE:
	clr.l d6
	mulu #4, d2
	add.l d2, a4
	move.l (a4), d6 //pulls value of rs register
	movea.l a3, a4
	mulu #4, d3
	add.l d3, a4
	move.l (a4), d2
	cmp.l d2, d6
	beq EQUAL
	add.l d4, a1	
EQUAL:
		clr.l d1
		clr.l d2
		clr.l d3
		clr.l d4
		clr.l d5
		clr.l d6
		movea.l a3, a4
		bra DECODE
SUBI:
	clr.l d6
	mulu #4, d2 
	add.l d2, a4 
	move.l (a4), d6//pulls value of rs register
	movea.l a3, a4
	sub.l d4, d6 //d4 holds immediate value
	mulu #4, d3
	add.l d3, a4
	//clr.l d2
	move.l d6, (a4)//pulls value of rt register
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	movea.l a3, a4
	bra DECODE
READ:
	clr.l d5
	move.b 0x40100044, d5 //move switch value into d5
	lsr.l #4, d5 //bit-shift to get proper value
	mulu #4, d2
	add.l d2, a4
	move.l d5, (a4)
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	movea.l a3, a4
	bra DECODE	

DIS:
	move.b d2,0x4010000F // Light up the LED
	clr.l d1
	clr.l d2
	clr.l d3
	clr.l d4
	clr.l d5
	clr.l d6
	movea.l a3, a4
	bra DECODE	
END:
	bra.s END

