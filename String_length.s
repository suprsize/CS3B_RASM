@ Name:		Mohammad Amin
@ Program:	String_Length
@ Class:	CS3B
@ Lab:		RASM3
@ Date:		April 8, 2020 at 3:30 PM

@ +String_length(string1:String):int

@ Subroutine String_Length accepts the address of a string and counts 
@ the characters in the string, excluding the NULL character and returns
@ that value as an int (word) in the R0 register. will read a string of 
@ characters terminated by a null

@    R0: Points to first byte of string to count
@    LR: Contains the return address

@ Returned register contents:
@    R0: Number of characters in the string (does not include null).
@ All registers are preserved as per AAPCS
@***********************************************************************


.data

.text

	.global String_Length 	@ Provide program starting address to Linker

	@ r4  -> counter
	@ r5  -> 
	@ r6  -> string1[-]
	@ r7  -> 
	@ r8  -> 
	@ r9  -> 
	@ r10 ->
		
String_Length:

	push {r1-r11}		@ push r1-r11 to stack, to preserve


	
	mov r4, #0			@ initialize the counter (r4) to 0
	ldrb r6, [r0], #1	@ load a character from address stored in r0 and 
						@ and then increment r0 to point to next byte
while:
	cmp r6, #0			@ compare loaded byte to NULL
	beq endWhile		@ while(r6 != NULL)
	add r4, #1			@ increment the counter
	ldrb r6, [r0], #1	@ load the next character and update the address
	b while				@ go back to beginning of while loop
endWhile:	
	mov r0, r4			@ move the value of counter into r0
	
	
	
	pop {r1-r11}		@ bring stack back to initial state.
	bx lr				@ return from subroutine
