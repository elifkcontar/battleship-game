;********************************************
;GPIO PORT F INITALIZATION FOR PF0 AND PF4
;GPIO PORT F ISR
;PF0 places civilian ship (6x3)
;PF4 places battleship (8x6)
;********************************************

SYSCTL_RCGCGPIO 	EQU 	0x400FE608		;clock registers

GPIO_PORTF_DIR      EQU     0x40025400
GPIO_PORTF_DEN      EQU     0x4002551C
GPIO_PORTF_AFSEL	EQU		0x40025420
GPIO_PORTF_PCTL     EQU     0x4002552C
GPIO_PORTF_LOCK		EQU		0x40025520
GPIO_PORTF_CR		EQU		0x40025524
GPIO_PORTF_PUR		EQU		0x40025510
GPIO_PORTF_IS		EQU		0x40025404
GPIO_PORTF_IBE		EQU		0x40025408
GPIO_PORTF_IEV		EQU		0x4002540C
GPIO_PORTF_IM		EQU		0x40025410
GPIO_PORTF_ICR		EQU		0x4002541C
GPIO_PORTF_0_4		EQU		0x40025044	
GPIO_PORTF_0		EQU		0x40025004
GPIO_PORTF_4		EQU		0x40025040

NVIC_IEN0			EQU		0xE000E100
NVIC_SYSPRI_7		EQU		0xE000E41C

DM					EQU		0x20000400
BM					EQU		0x20000500	;Memory location for battleships
CM					EQU		0x20000600	;Memory location for civilian ships
	
DC					EQU		0x40004100

;LABEL 			DIRECTIVE VALUE COMMENT
				AREA sdata , DATA, READONLY
				THUMB
P2	DCB 0x7f, 0x09, 0x09, 0x09, 0x06, 0x00 ;// 50 P
	DCB 0x42, 0x61, 0x51, 0x49, 0x46, 0x00 ;// 32 2
	DCB 0x00, 0x05, 0x03, 0x00, 0x00, 0x00 ;// 27 '
	DCB 0x46, 0x49, 0x49, 0x49, 0x31, 0x00, 0x00, 0x00 ;// 53 S
	DCB 0x01, 0x01, 0x7f, 0x01, 0x01, 0x00 ;// 54 T
	DCB 0x3f, 0x40, 0x40, 0x40, 0x3f, 0x00 ;// 55 U
	DCB 0x7f, 0x09, 0x19, 0x29, 0x46, 0x00 ;// 52 R
	DCB 0x7f, 0x04, 0x08, 0x10, 0x7f, 0x00 ;// 4e N
	
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,CODE,ALIGN=2
			THUMB
				
			EXPORT 	PortF_Init
			EXPORT 	Button_ISR
			EXTERN 	Delay100
			EXTERN	Delay10us
			EXTERN 	SSI_Send
			EXTERN	Systick_Init
				
PortF_Init  PROC
			LDR		R0, =SYSCTL_RCGCGPIO	;Enable clock for Port F
			LDR		R1, [R0]
			ORR		R1, #0x20
			STR 	R1, [R0]
			NOP
			NOP
			NOP
			NOP
			
			LDR		R0, =GPIO_PORTF_LOCK	;Unlock Port F
			MOV		R1, #0x0000004B
			ORR		R1, #0x00004300
			ORR		R1, #0x004F0000
			ORR		R1, #0x4C000000
			STR		R1, [R0]			
			
			LDR		R0, =GPIO_PORTF_CR		;Commit changes to PF0, PF4
			LDR		R1, [R0]
			ORR		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_DIR		;PF0, PF4 is input
			LDR		R1, [R0]
			BIC		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_AFSEL	;No alt. func
			LDR		R1, [R0]
			BIC		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_DEN		;Digital enabled
			LDR		R1, [R0]
			ORR		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_IS		;Edge sensitive
			LDR		R1, [R0]
			BIC		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_IBE		;No both edge detection
			LDR		R1, [R0]
			BIC		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_IEV		;Detect falling edge
			LDR		R1, [R0]
			BIC		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_IM		;Send interrupt to NVIC
			LDR		R1, [R0]
			ORR		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =GPIO_PORTF_PUR		;Pull up resistors enabled
			LDR		R1, [R0]
			ORR		R1, #0x11
			STR		R1, [R0]
			
			LDR		R0, =NVIC_IEN0			;Enable Port F interrupt
			LDR		R1, [R0]
			ORR		R1, #0x40000000
			STR		R1, [R0]
			
			LDR		R0, =NVIC_SYSPRI_7		;Set interrupt priority to 2 
			LDR		R1, [R0]
			ORR		R1, #0x00200000
			STR		R1, [R0]			
			BX		LR
			ENDP
				
Button_ISR	PROC	
			PUSH	{LR, R4, R5, R6}
			BL		Delay100				;Debouncing
			LDR		R0, =GPIO_PORTF_0_4		
			LDR		R1, [R0]
			CMP		R1, #0x11
			BEQ		c_return
			CMP		R7, #4
			BEQ		p1_end
			CMP		R7, #5
			BEQ		p2_start_hp
			BHI		mine_hop
			CMP		R1, #0x01
			BEQ		civ
			B		battle
			
civ			CMP		R2, #58
			BHI		c_return
			CMP		R3, #29
			BHI		c_return
			MOV		R0, #0x10		;Place ship coordinates on memory 
			STRB	R0, [R9], #1
			STRB	R2, [R9], #1
			STRB	R3, [R9], #1
			LDR		R0, =CM
			MOV		R1, #0x07
			LSL		R1, R3
			ADD		R0, R2, LSL #2
			MOV		R6, #6
write_c		STR		R1, [R0], #4
			SUBS	R6, #1
			BNE		write_c
			LDR		R0, =CM
			LDR		R1, =DM
			MOV		R6, #64
orring_c	LDR		R4, [R0], #4
			LDR		R5, [R1]
			ORR		R4, R5
			STR		R4, [R1], #4
			SUBS	R6, #1
			BNE		orring_c
			ADD		R7, #1
c_return	B		return

p2_start_hp	B		p2_start

battle		CMP		R2, #56
			BHI		c_return
			CMP		R3, #26
			BHI		c_return
			MOV		R0, #0x01		;Place ship coordinates on memory
			STRB	R0, [R9], #1
			STRB	R2, [R9], #1
			STRB	R3, [R9], #1
			LDR		R0, =BM
			MOV		R1, #0x3F
			LSL		R1, R3
			ADD		R0, R2, LSL #2
			MOV		R6, #8
write_b		STR		R1, [R0], #4
			SUBS	R6, #1
			BNE		write_b
			LDR		R0, =BM
			LDR		R1, =DM
			MOV		R6, #64
orring_b	LDR		R4, [R0], #4
			LDR		R5, [R1]
			ORR		R4, R5
			STR		R4, [R1], #4
			SUBS	R6, #1
			BNE		orring_b
			ADD		R7, #1
			B		return

mine_hop	B		place_mine
			
p1_end		ADD		R7, #1
			
			;**********************TO PRINT P2'S TURN******************************
			LDR		R1, =DC
			LDR		R0, [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]	

			MOV		R4, #0x41		;Set Y start cursor for play area
			BL		SSI_Send
			BL		Delay10us
			
			MOV		R4, #0x87		;Set X start cursor for play area
			BL		SSI_Send
			BL		Delay10us

			LDR		R1, =DC
			LDR		R0, [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			
			MOV		R4, #0
			MOV		R5, #64
send		BL		SSI_Send		;Sends the least significant byte
			BL		SSI_Send
			BL		SSI_Send
			BL		SSI_Send		
			MOV		R4, #0x01		;Send top pixel of the game border
			BL		SSI_Send
			MOV		R4, #0x80		;Send bottom pixel of the game border
			BL		SSI_Send
			SUBS	R5, #1
			BNE		send
			
			LDR		R1, =DC
			LDR		R0, [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]	

			MOV		R4 , #0x20		;Basic mode, horizontal
			BL 		SSI_Send
				
			MOV		R4, #0x42		;Set Y start cursor for play area
			BL		SSI_Send
			BL		Delay10us
			
			MOV		R4, #0x8F		;Set X start cursor for play area
			BL		SSI_Send
			BL		Delay10us

			LDR		R1, =DC
			LDR		R0, [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			
			MOV		R5, #50
			LDR		R0, =P2
print_msg	LDRB	R4, [R0],#1
			BL		SSI_Send
			SUBS	R5, #1
			BNE		print_msg
			
			MOV		R1, #20
delay_lp	BL		Delay100
			SUBS	R1, #1
			BNE		delay_lp
			
			;*****************************************
			
			LDR		R1 , =DC
			LDR		R0 , [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]	
			BL		Delay10us
			
			MOV		R4 , #0x22		;Basic mode, vertical
			BL 		SSI_Send
			
			MOV		R4, #0x08		;Set screen mode to blank
			BL		SSI_Send
			BL		Delay10us
			
			LDR		R1 , =DC
			LDR		R0 , [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			B		return 
			
p2_start	ADD		R7, #1
			LDR		R1 , =DC
			LDR		R0 , [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]	
			BL		Delay10us
			
			MOV		R4, #0x0C		;Set screen mode to normal
			BL		SSI_Send
			BL		Delay10us
			
			LDR		R1 , =DC
			LDR		R0 , [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			
			MOV		R1, #5
delay_loop	BL		Delay100
			SUBS	R1, #1
			BNE		delay_loop
			
			LDR		R1, =DM			;Clear display memory DM
			MOV		R2, #64
			MOV		R0,#0
loop_d		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_d
			BL		Systick_Init	;Initialize SysTick to start countdown for player2 turn
			B 		return

place_mine	CMP		R7,#10
			BHI		return
			ADD		R7, #1
			STRB	R2, [R10], #1	;Place mines on memory
			STRB	R3, [R10], #1
			B		return
			
return 		LDR		R0, =GPIO_PORTF_ICR
			LDR		R1, [R0]
			ORR		R1, #0x11
			STR		R1, [R0]
			POP		{LR, R4, R5, R6}
			BX		LR
			ENDP
			ALIGN
			END