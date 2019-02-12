;************************************************
;Helper subroutine to print numbers
;************************************************

;LABEL 			DIRECTIVE VALUE COMMENT
				AREA sdata , DATA, READONLY
				THUMB

zero			DCB 0x3e, 0x51, 0x49, 0x45, 0x3e, 0x00 ;// 30 0
one				DCB 0x00, 0x42, 0x7f, 0x40, 0x00, 0x00 ;// 31 1
two				DCB 0x42, 0x61, 0x51, 0x49, 0x46, 0x00 ;// 32 2
three			DCB 0x21, 0x41, 0x45, 0x4b, 0x31, 0x00 ;// 33 3
four			DCB 0x18, 0x14, 0x12, 0x7f, 0x10, 0x00 ;// 34 4
five			DCB 0x27, 0x45, 0x45, 0x45, 0x39, 0x00 ;// 35 5
six				DCB 0x3c, 0x4a, 0x49, 0x49, 0x30, 0x00 ;// 36 6
seven			DCB 0x01, 0x71, 0x09, 0x05, 0x03, 0x00 ;// 37 7
eight			DCB 0x36, 0x49, 0x49, 0x49, 0x36, 0x00 ;// 38 8
nine			DCB 0x06, 0x49, 0x49, 0x29, 0x1e, 0x00 ;// 39 9

;LABEL	 		;DIRECTIVE 	;VALUE 					;COMMENT
				AREA 			initisS , CODE, READONLY, ALIGN=2
				THUMB
				EXPORT			write_seventeen
				EXPORT			write_eighteen
				EXPORT			write_nineteen
				EXPORT			write_twenty
				EXPORT			write_sixteen
				EXPORT			write_fifteen
				EXPORT			write_fourteen
				EXPORT			write_thirteen
				EXPORT			write_twelve
				EXPORT			write_eleven
				EXTERN			SSI_Send

write_eleven	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_11			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_11
				LDR		R1,=one
				MOV		R11,#7
read_11s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_11s
				POP		{LR}
				BX		LR
				ENDP
					
write_twelve	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_12			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_12
				LDR		R1,=two
				MOV		R11,#7
read_12s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_12s
				POP		{LR}
				BX		LR
				ENDP
					
write_thirteen	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_13			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_13
				LDR		R1,=three
				MOV		R11,#7
read_13s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_13s
				POP		{LR}
				BX		LR
				ENDP
					
write_fourteen	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_14			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_14
				LDR		R1,=four
				MOV		R11,#7
read_14s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_14s
				POP		{LR}
				BX		LR
				ENDP
					
write_fifteen	PROC
				PUSH		{LR}
				LDR		R1,=one
				MOV		R11,#6
read_15			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_15
				LDR		R1,=five
				MOV		R11,#7
read_15s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_15s
				POP		{LR}
				BX		LR
				ENDP
					
write_sixteen	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_16			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_16
				LDR		R1,=six
				MOV		R11,#7
read_16s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_16s
				POP		{LR}
				BX		LR
				ENDP
					
write_seventeen	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_17			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_17
				LDR		R1,=seven
				MOV		R11,#7
read_17s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_17s
				POP		{LR}
				BX		LR
				ENDP
				
write_eighteen	PROC
				PUSH		{LR}
				LDR		R1,=one
				MOV		R11,#6
read_18			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_18
				LDR		R1,=eight
				MOV		R11,#7
read_18s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_18s
				POP		{LR}
				BX		LR
				ENDP
				
write_nineteen	PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_19			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_19
				LDR		R1,=nine
				MOV		R11,#7
read_19s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_19s
				POP		{LR}
				BX		LR
				ENDP
				
write_twenty	PROC
				PUSH	{LR}
				LDR		R1,=two
				MOV		R11,#6
read_20			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_20
				LDR		R1,=zero
				MOV		R11,#7
read_20s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_20s
				POP		{LR}
				BX		LR
				ENDP
					
				ALIGN
				END