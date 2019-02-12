DC					EQU	0x40004100

;LABEL	 		;DIRECTIVE 	;VALUE 					;COMMENT
				AREA 			initisr , CODE, READONLY, ALIGN=2
				THUMB
				EXPORT			Systick_ISR
				EXTERN			SSI_Send
				EXTERN			Delay100
				EXTERN			Delay10us
				EXTERN			write_twenty
				EXTERN			write_nineteen
				EXTERN			write_eighteen
				EXTERN			write_seventeen
				EXTERN			write_sixteen
				EXTERN			write_fifteen
				EXTERN			write_fourteen
				EXTERN			write_thirteen
				EXTERN			write_twelve
				EXTERN			write_eleven
				EXTERN			write_ten
				EXTERN			write_nine
				EXTERN			write_eight
				EXTERN			write_seven
				EXTERN			write_six
				EXTERN			write_five
				EXTERN			write_four
				EXTERN			write_three
				EXTERN			write_two
				EXTERN			write_one
				EXTERN			write_zero
				EXTERN			Display_update
				
Systick_ISR		PROC
				PUSH	{LR}
				LDR		R1, =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]
				MOV		R4 , #0x20		;Basic mode, horizontal
				BL 		SSI_Send
				MOV		R4 , #0x40		;Set Y start cursor for cd area
				BL		SSI_Send
				BL		Delay10us
				MOV		R4 , #0xC9		;Set X start cursor for cd area
				BL		SSI_Send
				BL		Delay10us
				LDR		R1 , =DC
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				
				BL		clear_CD		;Clear countdown area
				
				SUB		R8, #1			;Decrement the remaining time
				CMP		R8, #20			;Branch to print the remaining time
				BLEQ	write_twenty				
				CMP		R8, #19
				BLEQ	write_nineteen
				CMP		R8, #18
				BLEQ	write_eighteen
				CMP		R8, #17
				BLEQ	write_seventeen
				CMP		R8, #16
				BLEQ	write_sixteen
				CMP		R8, #15
				BLEQ	write_fifteen
				CMP		R8, #14
				BLEQ	write_fourteen
				CMP		R8, #13
				BLEQ	write_thirteen
				CMP		R8, #12
				BLEQ	write_twelve
				CMP		R8, #11
				BLEQ	write_eleven
				CMP		R8, #10
				BLEQ	write_ten
				CMP		R8, #9
				BLEQ	write_nine
				CMP		R8, #8
				BLEQ	write_eight
				CMP		R8, #7
				BLEQ	write_seven
				CMP		R8, #6
				BLEQ	write_six				
				CMP		R8, #5
				BLEQ	write_five			
				CMP		R8, #4
				BLEQ	write_four				
				CMP		R8, #3
				BLEQ	write_three				
				CMP		R8, #2
				BLEQ	write_two
				CMP		R8, #1
				BLEQ	write_one
				CMP		R8, #0
				BLEQ	write_zero
				
				LDR		R1 , =DC
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]
				BL		Delay10us
				MOV		R4 , #0x22		;Basic mode, vertical
				BL		SSI_Send
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				POP		{LR}
				BX		LR
				ENDP


clear_CD		PROC
				PUSH	{LR}
				MOV		R11,#13
				MOV		R4,#0x00
send			BL		SSI_Send
				SUBS	R11,#1
				BNE		send
				LDR		R1 , =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]
				MOV		R4 , #0x40		;Set Y start cursor for play area
				BL		SSI_Send
				BL		Delay10us
				MOV		R4 , #0xC9		;Set X start cursor for play area
				BL		SSI_Send
				BL		Delay10us
				LDR		R1 , =DC
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				POP		{LR}
				BX		LR
				ENDP				
				
				ALIGN
				END