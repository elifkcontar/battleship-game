;*******************************************************************
;ADC_Init
;********************************************************************

;Register           EQU     Address
SYSCTL_RCGCGPIO 	EQU 	0x400FE608
GPIO_PORTE_AFSEL    EQU     0x40024420
GPIO_PORTE_DIR      EQU     0x40024400
GPIO_PORTE_DATA     EQU     0X400243FC
GPIO_PORTE_AMSEL    EQU     0x40024528
GPIO_PORTE_DEN      EQU     0x4002451C
GPIO_PORTE_PCTL     EQU     0x4002452C
	
;Register           EQU     Address
SYSCTL_RCGCADC   	EQU 	0X400FE638
ADC0_ACTSS_R        EQU     0x40038000
ADC0_SSCTL2_R       EQU     0x40038084
ADC0_EMUX_R         EQU     0x40038014
ADC0_SSMUX2_R       EQU     0x40038080
ADC0_PC_R           EQU     0x40038FC4
ADC0_IM_R           EQU     0x40038008
ADC0_PSSI_R         EQU     0x40038028
ADC0_SSFIFO2_R      EQU     0x40038088
ADC0_ISC_R          EQU     0x4003800C
	
NVIC_IEN0			EQU		0xE000E100
NVIC_SYSPRI_4		EQU		0xE000E410
	
		AREA    |.text|, READONLY, CODE, ALIGN=2
        THUMB
		
        EXPORT  ADC_Init            	; Make available
		EXPORT	ADC0_SS2_ISR
		EXTERN	Display_update
			
;LABEL			DIRECTIVE	VALUE					COMMENT					
 	
ADC_Init		PROC
				LDR     	R1, =SYSCTL_RCGCADC		;start adc clock
				LDR     	R0, [R1]
				ORR     	R0, #0x01
				STR     	R0, [R1]
				NOP
				NOP
				NOP
				
				LDR			R1, =SYSCTL_RCGCGPIO	;start GPIO clock
				LDR			R0, [R1]
				ORR			R0, R0, #0x10
				STR			R0, [R1]
				NOP
				NOP
				NOP
				
				LDR			R1, =GPIO_PORTE_DEN		;disable digital
				LDR			R0, [R1]
				BIC			R0, #0x0C
				STR			R0, [R1]
				
				LDR			R1, =GPIO_PORTE_AFSEL	;alternate function
				LDR			R0, [R1]
				ORR			R0, #0x0C
				STR			R0, [R1]
				
				LDR			R1, =GPIO_PORTE_AMSEL	;enable analog
				LDR			R0, [R1]
				ORR			R0, #0x0C
				STR			R0, [R1]
				
				
				LDR     	R1, =ADC0_ACTSS_R		;disable before configure
				LDR     	R0, [R1]
				BIC     	R0, #0x04
				STR     	R0, [R1]
				
				LDR     	R1, =ADC0_EMUX_R		;trigger is processor trigger
				LDR     	R0, [R1]
				BIC     	R0, #0x0F00
				STR     	R0, [R1]
				
				LDR     	R1, =ADC0_SSMUX2_R		;ssmux2 is configured
				MOV     	R0, #0x10
				STR     	R0, [R1]
				
				LDR     	R1, =ADC0_SSCTL2_R		;control bits configured
				MOV     	R0, #0x60
				STR     	R0, [R1]
				
				LDR     	R1, =ADC0_PC_R			;sampling rate set to 125 ksps
				MOV     	R0, #0x01
				STR     	R0, [R1]
				
				LDR			R1, =ADC0_IM_R
				LDR			R0, [R1]
				ORR			R0, #0x04
				STR			R0, [R1]
				
				LDR			R0, =NVIC_IEN0			;Enable ADC0_SS2 interrupt
				LDR			R1, [R0]
				ORR			R1, #0x00010000
				STR			R1, [R0]
				
				LDR			R0, =NVIC_SYSPRI_4		;Set interrupt priority to 1 
				LDR			R1, [R0]
				ORR			R1, #0x00000020
				STR			R1, [R0]
				
				LDR     	R1, =ADC0_ACTSS_R		;enable
				LDR     	R0, [R1]
				ORR     	R0, #0x04
				STR     	R0, [R1]
				
				BX			LR						;return
				ENDP
					
ADC0_SS2_ISR	PROC
				PUSH		{LR}
				LDR			R1, =ADC0_SSFIFO2_R	;data stored in R2,X
				LDR			R2, [R1]
				LSR			R2, #6				;shift to map X between 0-63
				LDR			R1, =ADC0_SSFIFO2_R	;data stored in R3,Y
				LDR			R3, [R1]			
				LSR			R3, #7				;shift to map Y between 0-31
			
				BL			Display_update
						
				LDR			R1, =ADC0_ISC_R		;interrupt status and clear register
				LDR			R0, [R1]			
				MOV			R0, #0x04			;IN2 bit is set so RIS bit is cleared
				STR			R0, [R1]
				
				LDR			R1, =ADC0_PSSI_R
				MOV			R0, #0x04
				STR			R0, [R1]
				POP			{LR}
				BX			LR
				ENDP	
				
			ALIGN
			END
