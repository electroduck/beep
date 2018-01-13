EXTERN _Beep@16
EXTERN _GetCommandLineA@0
EXTERN _GetStdHandle@4
EXTERN _WriteConsoleA@20
EXTERN _MessageBoxA@16

EXTERN _StrToInt

GLOBAL START

%DEFINE InputMax 256

SECTION .data
help:       DB "--->  Usage: beep <frequency> <milliseconds>  <---", 0Ah, 0Dh
            DB 0Ah, 0Dh
            DB "Copyright 2018 Electroduck", 0Ah, 0Dh
            DB "Redistribution and use in source and binary forms, "
            DB "with or without modification, are permitted provided that "
            DB "the following conditions are met:", 0Ah, 0Dh
            DB "1. Redistributions of source code must retain the above "
            DB "copyright notice, this list of conditions and the following "
            DB "disclaimer.", 0Ah, 0Dh
            DB "2. Redistributions in binary form must reproduce the above "
            DB "copyright notice, this list of conditions and the following "
            DB "disclaimer in the documentation and/or other materials "
            DB "provided with the distribution.", 0Ah, 0Dh
            DB "3. Neither the name of the copyright holder nor the names of "
            DB "its contributors may be used to endorse or promote products "
            DB "derived from this software without specific prior written "
            DB "permission.", 0Ah, 0Dh
            DB "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND "
            DB "CONTRIBUTORS ", '"', "AS IS", '"',
            DB " AND ANY EXPRESS OR IMPLIED WARRANTIES, "
            DB "INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF "
            DB "MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE "
            DB "DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR "
            DB "CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, "
            DB "SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT "
            DB "NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; "
            DB "LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) "
            DB "HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN "
            DB "CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR "
            DB "OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, "
            DB "EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.", 0

helptitle:  DB "Help and License", 0

SECTION .text

; *** Entry point ***
START:
    PUSH    EBP
    MOV     EBP, ESP
    
    SUB     ESP, 4                      ; Frequency
    
    PUSH    EBX
    PUSH    EDX
    PUSH    ESI
    PUSH    EDI
    
    CALL    _GetCommandLineA@0          ; EAX = command line
    
    ; Discard argv[0]
    MOV     ESI, EAX
    MOV     BL, ' '
    CALL    strtok_simple
    
    ; argv[1] is the frequency
    CMP     EDI, 0
    JZ      .help
    MOV     ESI, EDI
    CALL    strtok_simple
    PUSH    10
    PUSH    ESI
    CALL    _StrToInt
    ADD     ESP, 8
    MOV     [EBP - 4], EAX
    
    ; argv[2] is the duration
    CMP     EDI, 0
    JZ      .help
    MOV     ESI, EDI
    CALL    strtok_simple
    PUSH    10
    PUSH    ESI
    CALL    _StrToInt
    ADD     ESP, 8
    
    ; Beep
    PUSH    EAX
    PUSH    DWORD [EBP - 4]
    CALL    _Beep@16
    
    JMP     .end
    .help:
    ; Display help message
    PUSH    0x00000040
    PUSH    helptitle
    PUSH    help
    PUSH    0
    CALL    _MessageBoxA@16
    
    .end:
    POP     EDI
    POP     ESI
    POP     EDX
    POP     EBX
    
    ADD     ESP, 4
    XOR     EAX, EAX
    
    POP     EBP
    RET

; *** Simplified strtok (1 delim only) ***
; Inputs: String pointer in ESI, delimiter in BL
; Outputs: Pointer to next token (or 0 if none) in EDI
strtok_simple:
    PUSH    EBP
    MOV     EBP, ESP
    
    PUSH    ESI
    
    ; Ignore leading delimiters
    .leadingDelimsLoop:
        LODSB
        CMP     AL, 0
        JZ      .endOfString
        CMP     AL, BL
        JE      .leadingDelimsLoop
    
    DEC     ESI
    
    ; Find first delimiter
    .delimFindLoop:
        LODSB
        CMP     AL, 0
        JZ      .endOfString
        CMP     AL, BL
        JNE     .delimFindLoop
    
    ; Replace with null
    MOV     BYTE [ESI - 1], 0
    
    ; Ignore additional delimiters
    .extraDelimsLoop:
        LODSB
        CMP     AL, 0
        JZ      .endOfString
        CMP     AL, BL
        JE      .extraDelimsLoop
    
    ; Done
    DEC     ESI
    MOV     EDI, ESI
    JMP     .end
    
    .endOfString:
    XOR     EDI, EDI
    
    .end:
    POP     ESI
    
    POP     EBP
    RET
    


















    