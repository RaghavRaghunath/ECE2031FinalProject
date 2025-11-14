           ; =========================================================================
           ; Log2 Peripheral Interactive Demo
           ; Displays test inputs and results on 7-segment displays
           ; =========================================================================
           
           ORG 0
           
Main:  
           LOADI 0
           OUT Hex0 ; Clear displays
           OUT Hex1
           
TestLoop:  
; Test 1: log2(256) = 8
           LOADI 256
           OUT Hex0 ; Display input (0x0100)
           OUT 0x90 ; Send to log2 peripheral
           CALL Delay
           IN 0x90 ; Read result
           OUT Hex1 ; Display result (should be 8)
           CALL LongDelay
           
; Test 2: log2(1024) = 10
           LOADI 1024
           OUT Hex0 ; Display input (0x0400)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 10 = 0x0A)
           CALL LongDelay
           
; Test 3: log2(1) = 0
           LOADI 1
           OUT Hex0 ; Display input (0x0001)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 0)
           CALL LongDelay
           
; Test 4: log2(15) = 3
           LOADI 15
           OUT Hex0 ; Display input (0x000F)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 3)
           CALL LongDelay
           
; Test 5: log2(255) = 7
           LOADI 255
           OUT Hex0 ; Display input (0x00FF)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 7)
           CALL LongDelay
           
; Test 6: log2(32768) = 15
           LOADI 32768
           OUT Hex0 ; Display input (0x8000)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 15 = 0x0F)
           CALL LongDelay
           
; Test 7: log2(0) = Error (0xFFFF)
           LOADI 0
           OUT Hex0 ; Display input (0x0000)
           OUT 0x90
           CALL Delay
           IN 0x90
           OUT Hex1 ; Display result (should be 0xFFFF)
           CALL LongDelay
           
           ; Loop back to beginning
           JUMP TestLoop
           
           ; =========================================================================
           ; Delay Subroutines
           ; =========================================================================
Delay:  
           OUT Timer
WaitD:  
           IN Timer
           ADDI -10 ; 10ms delay
           JNEG WaitD
           RETURN
           
LongDelay:  
           OUT Timer
WaitLD:  
           IN Timer
           ADDI -200 ; 2 second delay
           JNEG WaitLD
           RETURN
           
           ; =========================================================================
           ; I/O Addresses (adjust these for your SCOMP configuration)
           ; =========================================================================
Hex0: EQU &H004 ; 7-segment display (input)
Hex1: EQU &H005 ; 7-segment display (result)
Timer: EQU &H003 ; Timer
           
           
           