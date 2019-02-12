;Subroutine Delay10us
;***************************************************
;one instruction execution time=1/16*10^6=62.5 ns
;Count loop has 2 instructions
;100ms/(2*(62.5ns))=800000 count variable

;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,READONLY,CODE,ALIGN=2
			THUMB
			
			EXPORT		Delay100

Delay100	PROC
			PUSH		{R0,LR}					;To keep value at R0 after subroutine 
			MOV			R0, #0x000C3000			;Required count number for 100ms
			ORR			R0, #0x00000500
			
loop		SUBS		R0, #1					;If no, decrement R0
			BNE			loop					;continue subroutine
			
			POP			{R0,LR}					;Pop previous value at R0
			BX			LR						;Return
			ENDP
			ALIGN
			END