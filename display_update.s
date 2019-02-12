;*****************************************************
;R2		X_cursor
;R3		Y_cursor
;R4		Send_data
;R5		X_counter
;R6		Memory map base adress
;R10	Flag
;R9		Some other Flag
; *****************************************************

DC					EQU		0x40004100		;D/C' line PA6
DM	    			EQU	    0x20000400		;Display memory base address
				
	;LABEL		DIRECTIVE	VALUE			COMMENT
				AREA		|.text|,CODE,ALIGN=2
				THUMB
						
				EXPORT  Display_update
				EXTERN	SSI_Send
				EXTERN	Delay100
				EXTERN	Delay10us

Display_update	PROC
				PUSH	{LR,R2,R3,R5,R6,R10,R9,R0,R12}			
				MOV		R5, #0					;Counter for vertical printing
				LDR		R6, =DM
				SUB		R12, R2, #1
				MOV		R10,#0
				MOV		R9, #0
										;Begining of the display set cursor top left of the play area
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
				
loop			CMP		R5, #64
				BEQ		return
				LDR		R4, [R6], #4	;Load memory map screen
				CMP		R5, R12			;Compare counter_vertical and X_cursor-1
				BNE		send
				CMP		R10, #1			;If cursor is to be drawn check whether it is the middle part or not
				BEQ		middle
				MOV		R0 , #0x01		;Only one 1 for edges
				LSL		R0 , R3
				ORR		R4 , R0
				MOV		R10, #1
				CMP		R9, #0
				ADDEQ	R12, #1
				B		send

middle			MOV 	R0, #0x07		;Three 1s for the middle 
				LSL		R0 , R3
				LSR		R0, #1
				ORR		R4 , R0
				MOV		R10, #0
				ADD 	R12, #1
				ADD		R9, #1
				B		send
				
send			BL		SSI_Send		;Sends the least significant byte
				LSR		R4,#8
				BL		SSI_Send
				LSR		R4,#8
				BL		SSI_Send
				LSR		R4,#8
				BL		SSI_Send		
				MOV		R4, #0x01		;Send top pixel of the game border
				BL		SSI_Send
				MOV		R4, #0x80		;Send bottom pixel of the game border
				BL		SSI_Send
				ADD		R5, #1
				B		loop
				
return			POP		{LR,R2,R3,R5,R6,R10,R9,R0,R12}
				BX		LR
				ENDP
		ALIGN
		END