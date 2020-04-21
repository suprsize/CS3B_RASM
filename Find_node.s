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

.equiv NULL, 		0	@ NULL pointer for linked list
.equiv NOT_FOUND, 	-1	@ -1 to indicate not found 
.equiv NEXT,		4	@ the offset to the first byte of *next


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
	ldr r4, [r7]		@ r4(currentNode) = *head
	cmp	r4, #NULL		@ compare(*head, nullptr)
	beq notFound		@ if(*head != nullptr)	
	

	@ Start the while loop to look for the node 
	mov r5, r4			@ r5(prevNode) = currentNode
	mov r6, #0			@ initialize the while-counter to zero
	ldr r4, [r4, #NEXT]	@ r4(currentNode) = currentNode.next()
while:
	cmp r6, r8			@ compare(while-counter, keyIndex)
	beq found			@ while(counter != keyIndex && 
	cmp r4, #NULL		@ compare(currentNode, NULL)
	beq notFound		@ 							    currentNode != NULL)
	
	add r6, #1			@ ++counter
	mov r5, r4			@ r5(prevNode) = currentNode
	ldr r4, [r4, #NEXT]	@ r4(currentNode) = currentNode.next()
	b while				@ go back to beginning of while loop
	
	
found:
	mov r0, r5			@ return  prevNode
	b finish			@ go to the end
	
notFound:
	mov r0, #NOT_FOUND	@ return NOT_FOUND
	
finish:
	pop {r1-r11, lr}	@ bring stack back to initial state.
	bx lr				@ return from subroutine

