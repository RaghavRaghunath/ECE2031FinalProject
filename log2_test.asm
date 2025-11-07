; =========================================================================
; Log2 Peripheral Test Cases
; Tests the Log2 peripheral at I/O address 0x90
; =========================================================================

ORG 0

Main:
	; Initialize
	CALL TestPowersOf2
	CALL TestEdgeCases
	CALL TestNonPowersOf2
	CALL TestLargeValues
	JUMP EndTests

; =========================================================================
; Test 1: Powers of 2 (should give exact results)
; =========================================================================
TestPowersOf2:
	; Test log2(1) = 0
	LOADI  1
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 0
	
	; Test log2(2) = 1
	LOADI  2
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 1
	
	; Test log2(4) = 2
	LOADI  4
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 2
	
	; Test log2(8) = 3
	LOADI  8
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 3
	
	; Test log2(16) = 4
	LOADI  16
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 4
	
	; Test log2(32) = 5
	LOADI  32
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 5
	
	; Test log2(64) = 6
	LOADI  64
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 6
	
	; Test log2(128) = 7
	LOADI  128
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 7
	
	; Test log2(256) = 8
	LOADI  256
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 8
	
	; Test log2(512) = 9
	LOADI  512
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 9
	
	; Test log2(1024) = 10
	LOADI  1024
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 10
	
	; Test log2(2048) = 11
	LOADI  2048
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 11
	
	; Test log2(4096) = 12
	LOADI  4096
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 12
	
	; Test log2(8192) = 13
	LOADI  8192
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 13
	
	; Test log2(16384) = 14
	LOADI  16384
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 14
	
	; Test log2(32768) = 15
	LOADI  32768
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 15
	
	RETURN

; =========================================================================
; Test 2: Edge Cases
; =========================================================================
TestEdgeCases:
	; Test log2(0) = Error (should return 0xFFFF)
	LOADI  0
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 0xFFFF (65535)
	
	; Test log2(1) = 0 (smallest valid input)
	LOADI  1
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 0
	
	; Test log2(65535) = 15 (largest 16-bit value)
	LOADI  65535
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 15 (MSB is bit 15)
	
	RETURN

; =========================================================================
; Test 3: Non-Powers of 2 (should round down)
; =========================================================================
TestNonPowersOf2:
	; Test log2(3) = 1 (floor of 1.585)
	LOADI  3
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 1
	
	; Test log2(5) = 2 (floor of 2.322)
	LOADI  5
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 2
	
	; Test log2(7) = 2 (floor of 2.807)
	LOADI  7
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 2
	
	; Test log2(10) = 3 (floor of 3.322)
	LOADI  10
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 3
	
	; Test log2(15) = 3 (floor of 3.907)
	LOADI  15
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 3
	
	; Test log2(31) = 4 (floor of 4.954)
	LOADI  31
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 4
	
	; Test log2(63) = 5 (floor of 5.977)
	LOADI  63
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 5
	
	; Test log2(100) = 6 (floor of 6.644)
	LOADI  100
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 6
	
	; Test log2(127) = 6 (floor of 6.989)
	LOADI  127
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 6
	
	; Test log2(255) = 7 (floor of 7.994)
	LOADI  255
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 7
	
	; Test log2(1000) = 9 (floor of 9.966)
	LOADI  1000
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 9
	
	RETURN

; =========================================================================
; Test 4: Large Values
; =========================================================================
TestLargeValues:
	; Test log2(40000) = 15
	LOADI  40000
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 15
	
	; Test log2(50000) = 15
	LOADI  50000
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 15
	
	; Test log2(60000) = 15
	LOADI  60000
	OUT    0x90
	IN     0x90
	STORE  Result
	; Expected: 15
	
	RETURN

; =========================================================================
; End of Tests
; =========================================================================
EndTests:
	LOADI  &HDEAD     ; Load completion marker
	OUT    LEDs       ; Display on LEDs to show completion
	JUMP   EndTests   ; Infinite loop

; =========================================================================
; Variables
; =========================================================================
Result:   DW 0      ; Storage for test results

; =========================================================================
; I/O Addresses
; =========================================================================
LEDs:     EQU &H000 ; LED output address (adjust based on your SCOMP)


