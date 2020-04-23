@ Name:		Mohammad Amin
@ Program:	Find_node
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 22, 2020 at 3:30 PM

@ +Find_node(Head:*int, keyIndex:int)

@ Subroutine Find_node accepts address of a pointer to head, and accepts
@ an index number. It will go through the linked-list and will return 
@ the address of the node in the specified index. If the index number 
@ does not exist it will return -1.

@    R0: Points to head pointer.
@    R1: The keyIndex number 
@    LR: Contains the return address.

@ Returned register contents:
@    R0: Points to the first byte of the node in the specified index or 
@		 -1 if keyIndex is out of bound.
@ All registers are preserved as per AAPCS
@***********************************************************************

.equiv NULLONE, 		0	@ NULLONE pointer for linked list
.equiv NOT_FOUND2, 	-1	@ -1 to indicate not found 
.equiv NEXT1,		4	@ the offset to the first byte of *NEXT1


.data

.text

	.global Find_node 	@ Provide program starting address to Linker
	
	
	@ r4  -> currentNode
	@ r5  -> prevNode
	@ r6  -> counter
	@ r7  -> &Head
	@ r8  -> keyIndex
	@ r10 -> 
	@ r11 -> 
	

Find_node:

	push {r1-r11, lr}	@ push r1-r11 and lr to stack, to preserve

	@ Make a second copy of all arguments passed in
	mov r7, r0			@ copy address of pointer to Head into r7
	mov r8, r1			@ copy the index number into r10


	@ Looks to see if the linked-list is not empty
	ldr r7, =head
	ldr r4, [r7]		@ r4(currentNode) = *head
	cmp	r4, #NULLONE		@ compare(*head, NULLONEptr)
	beq notFoundFind_node		@ if(*head != NULLONEptr)	
	

	@ Start the while loop to look for the node 
	mov r5, r4			@ r5(prevNode) = currentNode
	mov r6, #0			@ initialize the while-counter to zero
	ldr r4, [r4, #NEXT1]	@ r4(currentNode) = currentNode.NEXT1()

whileFind_node:
	cmp r6, r8			@ compare(while-counter, keyIndex)
	beq foundFind_node			@ while(counter != keyIndex && 
	cmp r4, #NULLONE		@ compare(currentNode, NULLONE)
	beq notFoundFind_node		@ 							    currentNode != NULLONE)
	
	add r6, #1			@ ++counter
	mov r5, r4			@ r5(prevNode) = currentNode
	ldr r4, [r4, #NEXT1]	@ r4(currentNode) = currentNode.NEXT1()
	b whileFind_node				@ go back to beginning of while loop
	
	
foundFind_node:
	mov r0, r5			@ return  prevNode
	b finishFind_node			@ go to the end
	
notFoundFind_node:
	mov r0, #NOT_FOUND2	@ return NOT_FOUND2
	
finishFind_node:
	pop {r1-r11, lr}	@ bring stack back to initial state.
	bx lr				@ return from subroutine

