;**********************************************
;EE447-INTRODUCTION TO MICROPROCESSORS
;LABORATORY PROJECT: BATTLESHIP GAME CONSOLE
;AUTHORS:
;Gokberk Afsin Peker 2094357
;Elif Kubra Contar   2094894
;**********************************************
DC					EQU		0x40004100		
ADC0_PSSI_R         EQU     0x40038028		;ADC
ADC0_RIS_R          EQU     0x40038004
ADC0_SSFIFO2_R      EQU     0x40038088
ADC0_ISC_R          EQU     0x4003800C
ADC0_ACTSS_R        EQU     0x40038000
	
NVIC_ST_CTRL 		EQU 	0xE000E010

ship_locs			EQU		0x20000700
mine_locs			EQU		0x20000800
	
;***************************************************************
;LABEL 		DIRECTIVE 	VALUE 		COMMENT
			AREA 	sdata , DATA, READONLY
			THUMB
win_msg		DCB 0x07, 0x08, 0x70, 0x08, 0x07, 0x00 
			DCB	0x3e, 0x41, 0x41, 0x41, 0x3e, 0x00
			DCB	0x3f, 0x40, 0x40, 0x40, 0x3f, 0x00, 0x00, 0x00
			DCB	0x3f, 0x40, 0x38, 0x40, 0x3f, 0x00
			DCB	0x00, 0x41, 0x7f, 0x41, 0x00, 0x00
			DCB	0x7f, 0x04, 0x08, 0x10, 0x7f, 0x00
			DCB	0x00, 0x00, 0x5f, 0x00, 0x00			;YOU WIN!
				
lost_msg	DCB 0x07, 0x08, 0x70, 0x08, 0x07, 0x00
			DCB	0x3e, 0x41, 0x41, 0x41, 0x3e, 0x00
			DCB	0x3f, 0x40, 0x40, 0x40, 0x3f, 0x00, 0x00, 0x00
			DCB	0x7f, 0x40, 0x40, 0x40, 0x40, 0x00
			DCB	0x3e, 0x41, 0x41, 0x41, 0x3e, 0x00
			DCB	0x46, 0x49, 0x49, 0x49, 0x31, 0x00
			DCB	0x01, 0x01, 0x7f, 0x01, 0x01, 0x00
			DCB	0x00, 0x00, 0x5f, 0x00, 0x00			;YOU LOST!
				
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA		|.text|,CODE,ALIGN=2
			THUMB
					
			EXPORT  __main
			EXTERN	LCD_Init
			EXTERN	SSI_Send
			EXTERN	SSI_Init
			EXTERN	ADC_Init
			EXTERN	PortF_Init
			EXTERN	Display_update
			EXTERN	clr_memory
			EXTERN	Delay10us
			EXTERN	Delay100
			EXTERN	Clear
				
__main      BL		SSI_Init
			BL		LCD_Init
			BL		ADC_Init
			BL		PortF_Init
			
			BL		clr_memory
			
			MOV		R7, #0				;Number of button pressed
			MOV		R8,#21				;Time left(20 seconds)
			LDR		R9, =ship_locs		;Memory location to save ship coordinates 
			LDR		R10, =mine_locs		;Memory location to save mine coordinates
			
			LDR		R1, =ADC0_PSSI_R
			MOV		R0, #0x04
			STR		R0, [R1]
			
loop		CMP		R8, #0				;Main loop during the game
			BNE		loop
			
			LDR     R1, =ADC0_ACTSS_R		;Disable ADC
			LDR     R0, [R1]
			BIC     R0, #0x04
			STR     R0, [R1]
			
			LDR 	R1, =NVIC_ST_CTRL		;Disable SysTick
			LDR		R0, [R1]
			BIC		R0, #0x01
			STR 	R0, [R1]
			
			
			LDR		R9, =ship_locs
			MOV		R12, #4			;Ship number
next_ship	LDRB	R0, [R9], #1
			CMP		R0, #0x01
			BEQ		bship
			
			LDR		R10, =mine_locs	;Civilian ship checking for hits
			LDRB	R0, [R9], #1	;R0 has civ_ship_X
			LDRB	R1, [R9], #1	;R1 has civ_ship_Y
			MOV		R5, R7			;Mine number is button pressed-6 
			SUB		R5, #6
next_mine_c	LDRB	R2, [R10], #1	;R2 has mine_X
			LDRB	R3, [R10], #1	;R3 has mine_Y
			CMP		R2, R0
			BLO		no_hit_c
			ADD		R0, #5
			CMP		R2, R0
			BHI		no_hit_c
			CMP		R3, R1
			BLO		no_hit_c
			ADD		R1, #2
			CMP		R3, R1
			BHI		no_hit_c
			B		lost
no_hit_c	SUBS	R5, #1
			BNE		next_mine_c
			SUBS	R12, #1
			BNE		next_ship
			B		won
			
bship		LDR		R10, =mine_locs
			LDRB	R0, [R9], #1	;R0 has battle_ship_X
			LDRB	R1, [R9], #1	;R1 has battle_ship_Y
			MOV		R5, R7			;Mine number is button pressed-6 
			SUB		R5, #6
next_mine_b	LDRB	R2, [R10], #1	;R2 has mine_X
			LDRB	R3, [R10], #1	;R3 has mine_Y
			CMP		R2, R0
			BLO		no_hit_b
			ADD		R0, #7
			CMP		R2, R0
			BHI		no_hit_b
			CMP		R3, R1
			BLO		no_hit_b
			ADD		R1, #5
			CMP		R3, R1
			BHI		no_hit_b
			SUBS	R12, #1
			BNE		next_ship
			B		won
no_hit_b	SUBS	R5, #1
			BNE		next_mine_b
			B		lost
			
lost		BL		Clear			;Load lost message and send to display
			LDR		R1 , =DC
			LDR		R0 , [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]
			
			MOV		R4 , #0x20		;Basic mode, horizontal
			BL 		SSI_Send
			MOV		R4 , #0x42		;Set Y start cursor for message
			BL		SSI_Send
			BL		Delay10us				
			MOV		R4 , #0x93		;Set X start cursor for message
			BL		SSI_Send
			BL		Delay10us
			
			LDR		R1 , =DC
			LDR		R0 , [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			
			LDR		R1, =lost_msg	;Lost message length is 49 byte
			MOV		R11, #49		
read_1ost	LDRB	R4,[R1],#1
			BL		SSI_Send
			SUBS	R11,#1
			BNE		read_1ost
			B		show_msg

won			BL		Clear			;Load won message and send to display
			LDR		R1 , =DC
			LDR		R0 , [R1]
			BIC		R0, #0x40		;DC=0 Command
			STR		R0, [R1]
			
			MOV		R4 , #0x20		;Basic mode, horizontal
			BL 		SSI_Send
			MOV		R4 , #0x42		;Set Y start cursor for message
			BL		SSI_Send
			BL		Delay10us				
			MOV		R4 , #0x93		;Set X start cursor for message
			BL		SSI_Send
			BL		Delay10us
			
			LDR		R1 , =DC
			LDR		R0 , [R1]
			ORR		R0, #0x40		;DC=1 Data
			STR		R0, [R1]
			
			LDR		R1, =win_msg	;Win message length is 43 byte
			MOV		R11, #43
read_won	LDRB	R4,[R1],#1
			BL		SSI_Send
			SUBS	R11,#1
			BNE		read_won
			B		show_msg
			
			
show_msg	MOV		R0, #20
delay_loop	BL		Delay100
			SUBS	R0, #1
			BNE		delay_loop
			B		__main
			ALIGN
			END