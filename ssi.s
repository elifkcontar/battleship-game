;*******************************************
;SSI INITILIZATION
;********************************************
SYSCTL_RCGCGPIO 	EQU 	0x400FE608		;clock registers
SYSCTL_RCGCSSI	 	EQU     0x400FE61C

;SSI registers
SSI0_CR0            EQU		0x40008000
SSI0_CR1           	EQU		0x40008004
SSI0_DR           	EQU		0x40008008
SSI0_SR             EQU		0x4000800C
SSI0_CPSR           EQU		0x40008010
SSI0_CC            	EQU		0x40008FC8

;GPIO registers
RESET_PIN    		EQU     0x40004200		;Port A7		
DC					EQU		0x40004100		;Port A6
GPIO_PORTA_DIR      EQU     0x40004400
GPIO_PORTA_DEN      EQU     0x4000451C
GPIO_PORTA_AFSEL	EQU		0x40004420
GPIO_PORTA_PCTL     EQU     0x4000452C	
	
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,CODE,ALIGN=2
			THUMB
					
			EXPORT  SSI_Init
			EXPORT	SSI_Send
			EXTERN	Delay100		

SSI_Init		PROC
				LDR 	R1 , =SYSCTL_RCGCGPIO	;enable clock for GPIO
				LDR 	R0 , [R1]				
				ORR 	R0 , R0 , #0x01			;activate portA
				STR		R0 , [R1]				
				NOP								;nope to stabilize clock
				NOP
				NOP
				
				LDR 	R1 , =GPIO_PORTA_DIR 	;Bit0 is input
				LDR 	R0 , [R1]
				ORR 	R0, R0 , #0xEC				;port 6, 7 output
				STR 	R0 , [R1]
				
				LDR 	R1 , =GPIO_PORTA_AFSEL	;Enbale alternate function for bit0
				LDR 	R0 , [R1]
				ORR 	R0, R0 , #0x3C				;enable alternate function for port 2,3,4,5
				BIC 	R0 , #0xC0				;disable	alternate function for port 6,7
				STR 	R0 , [R1]
				
				LDR 	R1 , =GPIO_PORTA_DEN	;enable digital
				LDR 	R0 , [R1]
				ORR 	R0, R0 , #0xFC
				STR 	R0 , [R1]
							
				LDR 	R1, =GPIO_PORTA_PCTL ; no alternate function
				LDR 	R0, [R1]
				BIC		R0, R0, #0x000000FF
				ORR 	R0, R0, #0x00220000
				ORR 	R0, R0, #0x00002200
				STR 	R0, [R1]		
				
				LDR 	R1 , =SYSCTL_RCGCSSI	;enable clock for timer
				MOV		R0 , #0x01			
				STR		R0 , [R1]				
				NOP								;nope to stabilize clock
				NOP
				NOP
				NOP								;nope to stabilize clock
				NOP
				NOP
				NOP								;nope to stabilize clock
				NOP
				NOP
				
				LDR		R1 , =SSI0_CR1
				LDR 	R0, [R1]
				BIC		R0 , #0x2
				STR		R0, [R1]
				
				LDR		R1 , =SSI0_CPSR
				MOV		R0 , #0x02				;CPSDVR=2
				STR		R0 , [R1]
				
				LDR		R1 , =SSI0_CR0			;SCR=7, SPH,SPO=0, frescale, 8bit
				MOV		R0 , #0x0707
				STR		R0 , [R1]
				
				LDR		R1 , =SSI0_CR1
				MOV		R0 , #0x02				;enable
				STR		R0 , [R1]
				BX		LR
				ENDP
;**********************************************
;SSI_send subroutine
;Sends the least significant byte of the value in 
;register R4 to the LCD screen to display
;**********************************************
SSI_Send		PROC
				PUSH	{LR,R1,R0}
wait_fifo		LDR		R1 , =SSI0_SR
				LDR		R0 , [R1]
				ANDS	R0 , #0x01
				BEQ		wait_fifo
				LDR		R1 , =SSI0_DR
				STR		R4 , [R1]
				POP		{LR,R1,R0}
				BX		LR
				ENDP
				ALIGN
				END