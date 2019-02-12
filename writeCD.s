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
				AREA 			initis, CODE, READONLY, ALIGN=2
				THUMB
				EXPORT			write_ten
				EXPORT			write_nine
				EXPORT			write_eight
				EXPORT			write_seven
				EXPORT			write_six
				EXPORT			write_five
				EXPORT			write_four
				EXPORT			write_three
				EXPORT			write_two
				EXPORT			write_one
				EXPORT			write_zero
				EXTERN			SSI_Send

write_zero		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_0			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_0
				LDR		R1,=zero
				MOV		R11,#7
read_0s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_0s
				POP		{LR}
				BX		LR
				ENDP
					
write_one		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_1			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_1
				LDR		R1,=one
				MOV		R11,#7
read_1s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_1s
				POP		{LR}
				BX		LR
				ENDP
					
write_two		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_2			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_2
				LDR		R1,=two
				MOV		R11,#7
read_2s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_2s
				POP		{LR}
				BX		LR
				ENDP
					
write_three		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_3			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_3
				LDR		R1,=three
				MOV		R11,#7
read_3s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_3s
				POP		{LR}
				BX		LR
				ENDP
					
write_four		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_4			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_4
				LDR		R1,=four
				MOV		R11,#7
read_4s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_4s
				POP		{LR}
				BX		LR
				ENDP
					
write_five		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_5			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_5
				LDR		R1,=five
				MOV		R11,#7
read_5s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_5s
				POP		{LR}
				BX		LR
				ENDP
					
write_six		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_6			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_6
				LDR		R1,=six
				MOV		R11,#7
read_6s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_6s
				POP		{LR}
				BX		LR
				ENDP
					
write_seven		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_7			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_7
				LDR		R1,=seven
				MOV		R11,#7
read_7s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_7s
				POP		{LR}
				BX		LR
				ENDP
					
write_eight		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_8			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_8
				LDR		R1,=eight
				MOV		R11,#7
read_8s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_8s
				POP		{LR}
				BX		LR
				ENDP
					
write_nine		PROC
				PUSH	{LR}
				LDR		R1,=zero
				MOV		R11,#6
read_9			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_9
				LDR		R1,=nine
				MOV		R11,#7
read_9s			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_9s
				POP		{LR}
				BX		LR
				ENDP
					
write_ten		PROC
				PUSH	{LR}
				LDR		R1,=one
				MOV		R11,#6
read_10			LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_10
				LDR		R1,=zero
				MOV		R11,#7
read_10s		LDRB	R4,[R1],#1
				BL		SSI_Send
				SUBS	R11,#1
				BNE		read_10s
				POP		{LR}
				BX		LR
				ENDP
					
				ALIGN
				END