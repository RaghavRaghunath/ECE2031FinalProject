; =========================================================================
; Simple Log2 Test - Quick verification
; Tests a few key values and displays results
; =========================================================================

ORG 0

Main:
	; === Test 1: log2(8) = 3 ===
	LOADI  8
	OUT    0x90       ; Write to log2 peripheral
	IN     0x90       ; Read result
	STORE  Test1      ; Store result (should be 3)
	OUT    Hex0       ; Display on 7-seg
	
	; === Test 2: log2(256) = 8 ===
	LOADI  256
	OUT    0x90
	IN     0x90
	STORE  Test2      ; Store result (should be 8)
	OUT    Hex0
	
	; === Test 3: log2(1024) = 10 ===
	LOADI  1024
	OUT    0x90
	IN     0x90
	STORE  Test3      ; Store result (should be 10 = 0x0A)
	OUT    Hex0
	
	; === Test 4: log2(100) = 6 ===
	LOADI  100
	OUT    0x90
	IN     0x90
	STORE  Test4      ; Store result (should be 6)
	OUT    Hex0
	
	; === Test 5: log2(0) = 0xFFFF (error) ===
	LOADI  0
	OUT    0x90
	IN     0x90
	STORE  Test5      ; Store result (should be 0xFFFF)
	OUT    Hex0
	
	; Display completion
	LOADI  &HBEEF
	OUT    Hex0
	
Done:
	JUMP   Done       ; Infinite loop

; === Variables to store results ===
Test1: DW 0           ; Expected: 3
Test2: DW 0           ; Expected: 8
Test3: DW 0           ; Expected: 10 (0x0A)
Test4: DW 0           ; Expected: 6
Test5: DW 0           ; Expected: 65535 (0xFFFF)

; === I/O Addresses ===
Hex0:  EQU &H004     ; 7-segment display


