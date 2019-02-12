;SysTick initializer

NVIC_ST_CTRL 		EQU 0xE000E010
NVIC_ST_RELOAD 		EQU 0xE000E014
NVIC_ST_CURRENT 	EQU 0xE000E018
SHP_SYSPRI3 		EQU 0xE000ED20
DC					EQU	0x40004100

;LABEL	 		;DIRECTIVE 	;VALUE 					;COMMENT
				AREA 			initisr , CODE, READONLY, ALIGN=2
				THUMB
				EXPORT 			Systick_Init
				EXTERN			SSI_Send
				EXTERN			Delay100

			
Systick_Init	PROC
				PUSH		{R7}
				LDR 		R1 , =NVIC_ST_CTRL		;Disable
				MOV 		R0 , #0
				STR 		R0 , [ R1 ]
				
				MOV			R7 , #0x003D0000
				ORR			R7,  #0x00000900
				LDR 		R1 , =NVIC_ST_RELOAD	;Load value for 1sec
				STR 		R7 , [ R1 ]

				LDR 		R1 , =NVIC_ST_CURRENT	;Load any number different than zero to start process
				STR 		R7 , [ R1 ]
				
				LDR 		R1 , =SHP_SYSPRI3		;Set priority level to 1
				MOV 		R0 , #0x20000000
				STR 		R0 , [ R1 ]
				
				LDR 		R1 , =NVIC_ST_CTRL		;Enable systick
				MOV 		R0 , #0x03
				STR 		R0 , [ R1 ]
				POP			{R7}
				BX 			LR
				ENDP

				ALIGN
				END