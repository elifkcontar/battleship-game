;*********************************************
;Clears the memory that will be used throughout the game
;*********************************************
DM		    EQU	    0x20000400	;Memory location for display
BM			EQU		0x20000500	;Memory location for battleships
CM			EQU		0x20000600	;Memory location for civilian ships
ship_locs	EQU		0x20000700	;Memory location for ship top left coordinates(Type,X,Y)
mine_locs	EQU		0x20000800	;Memory location for mine location coordinates

;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,CODE,ALIGN=2
			THUMB
					
			EXPORT  clr_memory

clr_memory	PROC
			LDR		R1, =DM
			MOV		R2, #64
			MOV		R0,#0
loop_d		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_d
			
			LDR		R1, =CM
			MOV		R2, #64
			MOV		R0,#0
loop_c		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_c
			
			LDR		R1, =BM
			MOV		R2, #64
			MOV		R0,#0
loop_b		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_b
			
			LDR		R1, =ship_locs
			MOV		R2, #32
			MOV		R0,#0
loop_s		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_s
			
			LDR		R1, =mine_locs
			MOV		R2, #64
			MOV		R0,#0
loop_m		STR		R0,[R1], #4
			SUBS	R2, #1
			BNE		loop_m
			BX		LR
			ENDP
				
			ALIGN
			END