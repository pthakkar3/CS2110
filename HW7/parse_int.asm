;;===============================
;; CS 2110 Spring 2017
;; Homework 7 - Functions
;; Name: Pranshav Thakkar
;;===============================

.orig x3000
    LD R6, STACK

    ; You can test your functions individually here
    ; Alternatively, if you are confident in your own code,
    ; you can run the tester directly without anything here


    ; This part has been done for you
    ; When ParseInt is ready, you can uncomment the below lines

    JSR PARSE_INT   ; call PARSE_INT with no arguments
    LDR R0, R6, 0   ; load return value
    ADD R6, R6, 1   ; pop return value of stack
    ST R0, ANSWER   ; store answer

    HALT


ANSWER              .blkw 1
STACK               .fill xF000


; ======================== PARSE_INT ========================
PARSE_INT

	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old Frame Pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -4		; allocating space for local variables and registers
	STR R0, R5, -2		; saving r0 onto the stack
	STR R1, R5, -3		; saving r1 onto the stack
	STR R2, R5, -4 		; saving r2 onto the stack
	AND R1, R1, 0		; R1 = result = 0
	STR R1, R5, 0		; stored result as a local variable on the stack
	STR R1, R5, -1		; R1 is still 0, so R1 = 0 = isHex, and we store this as a local variable on the stack
	GETC
	OUT
	ADD R1, R0, 0		; R1 has the value of R0, now we can check the condition on R0 without changing its value
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10		; Checking if R1(equivalent to R0) == 'x' (ASCII = 120)
	BRnp WHILE_I		; if it is not equal to 'x' we skip to the while loop
	AND R1, R1, 0		; R1 will be isHex
	ADD R1, R1, 1		; isHex = 1
	STR R1, R5, -1		; storing the updated value of isHex onto the stack
	GETC
	OUT
WHILE_I	AND R2, R2, 0		; R2 = parsed
	LDR R1, R5, -1		; R1 = isHex
	BRnp ELSE1		; if isHex is not 0, we branch to the else
	LDR R1, R5, 0		; R1 = result, the first parameter in the call to parse decimal
	ADD R6, R6, -2		; we make space for the parameters for calling parse decimal
	STR R1, R6, 0		; store the first parameter
	STR R0, R6, 1		; store the second parameter
	LD R1, PARSE_DECIMAL_ADDR	; loading the address of parse decimal to R1
	JSRR R1			; call parse decimal
	LDR R2, R6, 0		; parsed = ParseDecimal(result, R0)
	BR EXIT1
ELSE1	LDR R1, R5, 0		; R1 = result, the first parameter in the call to parse decimal
	ADD R6, R6, -2		; we make space for the parameters for calling parse decimal
	STR R1, R6, 0		; store the first parameter
	STR R0, R6, 1		; store the second parameter
	LD R1, PARSE_HEX_ADDR	; loading the address of parse hex to R1
	JSRR R1			; call parse hex
	LDR R2, R6, 0		; parsed = ParseHex(result, R0)
EXIT1	AND R1, R1, 0		
	ADD R1, R1, R2		; R1 has the value of parsed
	ADD R1, R1, 1		; R1 = parsed + 1, to check if parsed was -1
	BRnp ELSE2		; if parsed is not zero after we add 1, we go to the else statement
	LDR R1, R5, 0		; R1 = result
	STR R1, R5, 3		; result is the return variable
	BR CLEAN_I
ELSE2	STR R2, R5, 0		; store parsed into the stack where result is (result = parsed)
	GETC
	OUT
	BR WHILE_I
CLEAN_I	LDR R2, R5, -4
	LDR R1, R5, -3
	LDR R0, R5, -2		; restoring registers from the stack
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET

PARSE_DECIMAL_ADDR  .fill x5000     ; the address of the ParseDecimal function
PARSE_HEX_ADDR      .fill x6000     ; the address of the ParseHex function
.end


; =========================== MULT ==========================
.orig x4000
MULT
	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old Frame Pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -2		; allocating space in the stack for registers
	STR R0, R5, 0		; saving r0 onto stack
	STR R1, R5, -1		; saving r1 onto stack
	STR R2, R5, -2		; saving r2 onto stack
	AND R0, R0, 0		; R0 is result, result = 0
	LDR R1, R5, 5		; R1 = b
WHILE_M	ADD R1, R1, 0		; R1 = b, to check for condition
	BRnz EXIT_M		; if B <= 0, the loop breaks
	LDR R2, R5, 4		; R2 = a
	ADD R0, R0, R2		; result = result + a
	ADD R1, R1, -1 		; b--
	BR WHILE_M		; the loop starts again
EXIT_M	STR R0, R5, 3		; storing result in the return value in the stack
CLEAN_M	LDR R2, R5, -2
	LDR R1, R5, -1
	LDR R0, R5, 0		; restoring registers from the stack
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET		
    

.end


; ====================== PARSE_DECIMAL ======================
.orig x5000
PARSE_DECIMAL

	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old frame pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -2		; allocating space in the stack for registers
	STR R0, R5, 0		; saving r0 onto stack
	STR R1, R5, -1		; saving r1 onto stack
	STR R2, R5, -2		; saving r2 onto stack
	LDR R0, R5, 5		; r0 = c
	ADD R0, R0, -10		
	ADD R0, R0, -10
	ADD R0, R0, -10
	ADD R0, R0, -10
	ADD R0, R0, -8		; r0 = c - '0' (c - 48) 
	BRn IF_D		; if c < '0', we enter the if statement
	ADD R0, R0, -9		; checking if c > '9'
	BRnz SKIP_D		; if c <='9', we skip the if statement
IF_D	AND R1, R1, 0		
	ADD R1, R1, -1		; R1 = -1
	STR R1, R5, 3		; store -1 in return value
	BR CLEAN_D		; we're done, we have what we want to return
SKIP_D	AND R1, R1, 0		
	ADD R1, R1, 10		; R1 = 10 (second parameter in call to mult)
	LDR R2, R5, 4		; R2 = acc (first parameter in call to mult)
	ADD R6, R6, -2		; making space for parameters for call to mult
	STR R1, R6, 1		; store second parameter
	STR R2, R6, 0		; store first parameter 
	LD R0, PD_MULT_ADDR	; store location of mult in R0
	JSRR R0			; call mult(acc, 10) from R0
	LDR R2, R6, 0		; R2 = m = mult(acc, 10)
	LDR R0, R5, 5		; R0 = c
	ADD R2, R2, R0		; R2 = m + c
	ADD R2, R2, -10		
	ADD R2, R2, -10
	ADD R2, R2, -10
	ADD R2, R2, -10
	ADD R2, R2, -8		; R2 = m + c - '0'   '0' = 48 in ASCII
	STR R2, R5, 3		; store R2 in the return value
CLEAN_D	LDR R2, R5, -2
	LDR R1, R5, -1
	LDR R0, R5, 0		; restoring registers from the stack
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET		

PD_MULT_ADDR    .fill x4000         ; the address of the Mult function
.end


; ======================== PARSE_HEX ========================
.orig x6000
PARSE_HEX

	ADD R6, R6, -4		; setting up stack frame
	STR R7, R6, 2		; storing the return address
	STR R5, R6, 1		; storing the old frame pointer
	ADD R5, R6, 0 		; setting the FP
	ADD R6, R6, -2		; allocating space in the stack for registers
	STR R0, R5, 0		; saving r0 onto stack
	STR R1, R5, -1		; saving r1 onto stack
	STR R2, R5, -2		; saving r2 onto stack
	LDR R0, R5, 4		; R0 = acc, first parameter in call to mult
	ADD R6, R6, -2		; making space for parameters in call to mult
	STR R0, R6, 0		; store first paramter onto stack
	AND R0, R0, 0
	ADD R0, R0, 10
	ADD R0, R0, 6		; R0 = 16, second parameter in call to mult
	STR R0, R6, 1		; store second parameter onto stack
	LD R0, PH_MULT_ADDR	; load mult address onto R0
	JSRR R0			; call mult(acc, 16)
	LDR R0, R6, 0		; R0 = m = mult(acc, 16)
	LDR R1, R5, 5		; R1 = c
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -8		; R1 = c - '0' (48 in ASCII)
	BRn SKIP1_H		; if c < '0', we skip the if statement
	ADD R1, R1, -9		; Now checking for c > '9'
	BRp SKIP1_H		; if c >'9', we skip the if statement
IF1_H	LDR R1, R5, 5		; R1 = c again because we are done with computations
	ADD R1, R1, R0		; R1 = m + c
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -8		; R1 = m + c - '0' (48 in ASCII)
	STR R1, R5, 3		; store R1 as the return value
	BR CLEAN_H		; we're done, need to clean the stack and exit
SKIP1_H	LDR R1, R5, 5		; R1 = c, for second if statement
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -5		; R1 = c - 'A', (65 in ASCII)
	BRn SKIP2_H		; if c < 'A', we skip the if statement
	ADD R1, R1, -5		; now checking for c > 'F' (70 in ASCII)
	BRp SKIP2_H		; if c > 'F', we skip the if statement
IF2_H	LDR R1, R5, 5		; R1 = c again because we are done with computations
	ADD R1, R1, R0		; R1 = m + c
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -10
	ADD R1, R1, -5		; R1 = m + c - 'A'
	ADD R1, R1, 10		; R1 = m + c - 'A' + 10
	STR R1, R5, 3		; store R1 as the return value
	BR CLEAN_H		; we're done, need to clean the stack and exit
SKIP2_H	AND R2, R2, 0		
	ADD R2, R2, -1		; R2 = -1
	STR R2, R5, 3		; store R2 as the return value
	BR CLEAN_H		; we're done, need to clean the stack and exit
CLEAN_H	LDR R2, R5, -2
	LDR R1, R5, -1
	LDR R0, R5, 0		; restoring registers from the stack
	ADD R6, R5, 1		; moving SP down to old FP
	LDR R5, R6, 0		; restoring old FP
	LDR R7, R6, 1		; restoring RA
	ADD R6, R6, 2		; point at RV
	RET		 

PH_MULT_ADDR    .fill x4000         ; the address of the Mult function
.end
