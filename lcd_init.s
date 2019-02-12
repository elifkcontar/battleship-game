;********************************************************
;LCD Initialization
;Initialize LCD screen and the clear 84*48 screen to remove any drawings from previous
;Draws border of game area
;*****************************************************
;Launchpad to Nokia 5110 LCD Pin Setup
; Use SSI0 module (Port A)
;  TI Pin  (Type)    Nokia 5110 Pin Pin #
;  PA7     (GPIO)        RST           1
;  PA3     (SSI0Fss)     CE            2
;  PA6     (GPIO)        DC            3
;  PA5     (SSI0Tx)      Din           4
;  PA2     (SSI0Clk)     CLK           5
;  PA4     ()            BL            7
;  +3.3V   ()            VCC           6
;  GND     ()            GND           8
; *****************************************************
;GPIO registers
RESET_PIN    		EQU     0x40004200		;PortA7
DC					EQU		0x40004100		;PortA6
				
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,CODE,ALIGN=2
			THUMB
					
			EXPORT  LCD_Init
			EXPORT	Clear
			EXTERN	Delay100
			EXTERN	Delay10us
			EXTERN	SSI_Send
			EXTERN	SSI_Init

LCD_Init		PROC
				PUSH	{LR,R10}
				LDR		R1 , =RESET_PIN
				LDR		R0 , [R1]
				BIC		R0 , #0x80		;Reset=LOW
				STR		R0 , [R1]
				
				BL		Delay100		
				ORR		R0 , #0x80		;Reset=HIGH
				STR		R0 , [R1]
				
				
				LDR		R1 , =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]
					
				MOV		R4 , #0x21		; Extended Command Mode, horizontal addressing
				BL		SSI_Send				
				MOV		R4 , #0xC0		;Set Vop
				BL		SSI_Send
				MOV		R4 , #0x04		;Set temp
				BL		SSI_Send				
				MOV		R4 , #0x13		;Set voltage bias
				BL		SSI_Send
				MOV		R4 , #0x20		;Basic mode
				BL		SSI_Send
				MOV		R4 , #0x0C		;Normal display
				BL		SSI_Send
				
				MOV		R4 , #0x22		;Basic mode vertical 
				BL		SSI_Send
				
				BL 		Clear				
				LDR		R1 , =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]	
				
				MOV		R4 , #0x40		;Set Y start cursor for borders
				BL		SSI_Send
				BL		Delay10us
				
				MOV		R4 , #0x86		;Set X start cursor for borders
				BL		SSI_Send
				BL		Delay10us

				LDR		R1 , =DC
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				
				MOV		R10, #66							
draw_border		MOV		R4, #0x80
				BL		SSI_Send
				MOV		R4, #0x00
				CMP		R10, #66
				MOVEQ	R4, #0xFF
				CMP		R10, #1
				MOVEQ	R4, #0xFF
				BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				MOV		R4, #0x01
				BL		SSI_Send
				SUBS	R10, #1
				BNE		draw_border
				
				BL		Delay10us
				LDR		R1 , =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]
				MOV		R4 , #0x41		;Set Y start cursor for play area
				BL		SSI_Send
				BL		Delay10us
				MOV		R4 , #0x86		;Set X start cursor for play area
				BL		SSI_Send
				BL		Delay10us
				LDR		R1 , =DC
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				
				POP		{LR,R10}
				BX		LR
				ENDP
;******************************************
;Clear subroutine
;Clears the 84*48 LCD screen
;*****************************************
Clear			PROC
				PUSH{LR,R10}
				LDR		R1 , =DC
				LDR		R0 , [R1]
				BIC		R0, #0x40		;DC=0 Command
				STR		R0, [R1]				
				MOV		R4 , #0x40		;Set Y start cursor for borders
				BL		SSI_Send
				BL		Delay10us				
				MOV		R4 , #0x80		;Set X start cursor for borders
				BL		SSI_Send
				BL		Delay10us				
				LDR		R1 , =DC
				LDR		R0 , [R1]
				ORR		R0, #0x40		;DC=1 Data
				STR		R0, [R1]
				MOV		R10, #84							
				
				MOV		R4, #0x00		;Clear LCD screen byte by byte
nextline		BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				BL		SSI_Send
				SUBS	R10, #1
				BNE		nextline
				POP		{LR,R10}
				BX		LR
				ENDP
				
				ALIGN
				END