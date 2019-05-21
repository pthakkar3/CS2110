;;===============================
;; CS 2110 Spring 2017
;; Homework 7 - Functions
;; Name: Pranshav Thakkar
;;===============================

; DO NOT REMOVE THIS LINE
;@plugin filename=lc3_udiv vector=x80

.orig x3000
	LD R6, STACK

	ADD R6, R6, -2		; making space for parameters
	LD R1, B		; Load B into R1
	STR R1, R6, 1		; store B onto the stack in the correct place as a parameter
	LD R1, A		; load A into R1
	STR R1, R6, 0		; store A onto the stack in the correct place as a parameter

   	JSR GCD			; call GCD
	
	LDR R1, R6, 0		; load the return value onto R1
	ST R1, ANSWER		; store the return value onto answer
	ADD R6, R6, 3		; move the SP back to original position    

   	HALT


A       .fill 20
B       .fill 16
ANSWER  .blkw 1
STACK   .fill xF000



GCD
	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old Frame Pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -1		; allocate space on the stack for saving registers
	STR R0, R5, 0		
	STR R1, R5, -1		; save R0 and R1 onto the stack
	LDR R0, R5, 4		; R0 = a
	LDR R1, R5, 5		; R1 = b
	UDIV			; calls the UDIV trap (R0 = a/b, R1 = a % b)
	ADD R1, R1, 0		; checking if R1 == 0
	BRnp ELSE		; if it is not zero, we branch to the else clause
	LDR R1, R5, 5		; R1 = b
	STR R1, R5, 3		; b is the return value
	BR CLEANUP		; we have the return value, we want to clean up the stack
ELSE	LDR R0, R5, 5		; R0 = b
	ADD R6, R6, -2		; getting ready for recursive call to GCD
	STR R1, R6, 1		; storing R1 as the second paramter for GCD
	STR R0, R6, 0		; storing R0 = b as the first parameter for GCD
	JSR GCD			; recursive call to GCD
	LDR R0, R6, 0		; R0 = GCD(b, R1)
	STR R0, R5, 3		; we want to return GCD(b, R1)
	BR CLEANUP		; branch to clean
CLEANUP	LDR R1, R5, -1
	LDR R0, R5, 0		; load registers back
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET		
	
.end
