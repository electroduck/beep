GLOBAL _StrToInt
GLOBAL _GetStringLenCDecl

SECTION .text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GetStringLenCDecl: Gets the length of a C-String.
;; Argument str          [4 bytes] The C-String to get the length of
;; Returns: The length of str.
;; Precondition/Postcondition: None, other than args and return value.
;; Notes: This function exists mainly for use by assembly language programs,
;;        as a replacement for strlen() that does not require the C standard
;;        library.
;; C equivalent: unsigned int __cdecl GetStringLenCDecl(char* str);
_GetStringLenCDecl:
	PUSH	EBP
	MOV		EBP, ESP
	
	PUSH	EBX
	
	XOR		EAX, EAX
	MOV		EBX, [EBP + 8]
	
	.loop:
	MOV		CL, BYTE [EBX]
	CMP		CL, 0
	JE		.loopEnd
	INC		EBX
	INC		EAX
	JMP		.loop
	.loopEnd:
	
	DEC		EAX
	
	POP		EBX
	
	POP		EBP
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; StrToInt: Convert C-String to integer.
;; Argument str          [4 bytes] The string to convert
;; Argument base         [4 bytes] The base of the num. in str (1 through 36)
;; Returns: The number as an integer.
;; Precondition/Postcondition: None, other than args and return value.
;; Notes: The maximum value supported is 0x7FFFFFFF.
;;        Values up to 0xFFFFFFFF will be processed correctly but will appear
;;        to be negative when used as an int.
;; C equivalent: int __cdecl StrToInt(char* str, int base);
_StrToInt:
	PUSH	EBP
	MOV		EBP, ESP
	
	; Save register values
	PUSH	EBX
	PUSH	EDX
	
	; EBX = start of the string
	MOV		EBX, [EBP + 8]
	PUSH	EBX
	CALL	_GetStringLenCDecl
	ADD		ESP, 4
	
	; ECX = end of the string
	MOV		ECX, EBX
	ADD		ECX, EAX
	
	; Initialize registers before looping
	XOR		EAX, EAX				; EAX: total value
	MOV		EDX, 1					; EDX: current multiplier
	
	; Main loop
	.loop:
	CMP		ECX, EBX
	JL		.loopEnd
	PUSH	EBX						; Save on stack while in loop body
	XOR		EBX, EBX				; Zero EBX
	MOV		BL, BYTE [ECX]			; BL = current character
	CMP		BL, '9'					; Check if alphabetical
	JG		.alph
	AND		BL, 0b00001111			; Convert numeric char to int
	JMP		.convertedToInt
	.alph:
	SUB		BL, 'A'-10				; Convert alpha char to int
	.convertedToInt:
	IMUL	EBX, EDX				; Multiply by multiplier
	ADD		EAX, EBX				; Add result to EAX
	MOV		EBX, [EBP + 12]			; EBX = base
	IMUL	EDX, EBX				; Multiply multiplier by base
	DEC		ECX						; Next character
	POP		EBX						; Restore EBX = original string
	JMP		.loop
	.loopEnd:
	
	; Total is now in EAX - we are done
	
	; Restore register values
	POP		EDX
	POP		EBX
	
	; Return
	POP		EBP
	RET
