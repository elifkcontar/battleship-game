;Subroutine Delay10us
;***************************************************
;one instruction execution time=1/16*10^6=62.5 ns
;Count loop has 2 instructions
;1us/(2*(62.5ns))=8 count variable

;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA		|.text|,READONLY,CODE,ALIGN=2
			THUMB
			
			EXPORT		Delay10us

Delay10us	PROC
			PUSH		{R0,LR}					;To keep value at R0 after subroutine 
			MOV			R0, #80				;Required count number for 100ms
			
loop		SUBS		R0, #1					;If no, decrement R0
			BNE			loop					;continue subroutine
			
			POP			{R0,LR}					;Pop previous value at R0
			BX			LR						;Return
			ENDP
			ALIGN
			END