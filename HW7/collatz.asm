;;===============================
;; CS 2110 Spring 2017
;; Homework 7 - Functions
;; Name: Pranshav Thakkar
;;===============================

; DO NOT REMOVE THIS LINE
;@plugin filename=lc3_udiv vector=x80

.orig x3000
	LD R6, STACK

	ADD R6, R6, -1		; make space for argument N
	LD R1, N		; load R1 with N to store onto the stack
	STR R1, R6, 0		; puts N into the appropriate parameter position on the stack

	JSR COLLATZ     	; call Collatz

    	LDR R1, R6, 0		; load the return value onto R1
	ST R1, ANSWER		; store the return value onto answer
	ADD R6, R6, 3		; move the SP back to original position  

	HALT


N       .fill 8
ANSWER  .fill 0
STACK   .fill xF000


COLLATZ
	
	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old Frame Pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -1		; allocate space on the stack for saving registers
	STR R0, R5, 0		
	STR R1, R5, -1		; save R0 and R1 onto the stack 
	LDR R0, R5, 4		; R0 = n, we will check if n == 1
	ADD R0, R0, -1		; R0 = n - 1, if n was 1 it should be zero now
	BRnp EXITIF		; if n != 1, we exit the if statement
	AND R0, R0, 0		; R0 = 0
	STR R0, R5, 3		; we want to return 0
	BR CLEANUP		; branch to cleanup
EXITIF	LDR R0, R5, 4		; R0 = n
	AND R1, R1, 0		
	ADD R1, R1, 2		; R1 = 2
	UDIV			; we call UDIV(n, 2)
	ADD R1, R1, 0		; checking if R1 == 0
	BRnp ELSE		; if it's not 0, we go to the else clause
	ADD R6, R6, -1		; getting ready for recursive call to collatz
	STR R0, R6, 0		; put R0 as the parameter for collatz
	JSR COLLATZ		; call Collatz(R0)
	LDR R0, R6, 0		; R0 = c = Collatz(R0)
	ADD R0, R0, 1		; R0 = c + 1
	STR R0, R5, 3		; we want to return c + 1
	BR CLEANUP		; branch to cleanup
ELSE	LDR R0, R5, 4		; R0 = n
	AND R1, R1, 0		; R1 = 0
	ADD R1, R1, R0		; R1 = n
	ADD R1, R1, R0
	ADD R1, R1, R0		; R1 = n*3
	ADD R1, R1, 1		; R1 = n*3 + 1	= m
	ADD R6, R6, -1		; getting ready for recursive call to collatz
	STR R1, R6, 0		; put m as the parameter for collatz
	JSR COLLATZ		; call Collatz(m)
	LDR R0, R6, 0		; R0 = c = Collatz(m)
	ADD R0, R0, 1		; R0 = c + 1
	STR R0, R5, 3		; return c + 1
	BR CLEANUP		; branch to cleanup
CLEANUP	LDR R1, R5, -1
	LDR R0, R5, 0		; load registers back
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET		

.end
