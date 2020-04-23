@ Name:		Mohammad Amin
@ Program:	Remove_node
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 22, 2020 at 3:30 PM

@ +Remove_node(Head:*int, Tail:*int, KeyIndex:int, ByteCounter:int):bool

@ Subroutine Remove_node accepts addresses of pointers to head, and tail 
@ of the linked list, accepts an interger key index  that is being
@ deleted, and address of the allocated-byte counter. It will first look
@ to see where the keyNode is located. Once located the linked-list
@ is rearranged to take out the keyNode from the linked-list. Once
@ the node is isolated the string saved and the node itself will be 
@ freed and the deallocated bytes will be deducted allocted-byte 
@ counter. If the index passed in is not valid for removing the method
@ will return 0 to indict that the removal was not successful. Otherwise
@ it  will return 1 for successful execution.  


@    R0: Points to head pointer.
@    R1: Points to tail pointer.
@    R2: The index number being removed.
@    R3: Points to heap-allocated-byte counter.
@    LR: Contains the return address.

@ Returned register contents:
@    R0: 1 for succesful execution and 0 for unsuccessful execution.
@ All registers are preserved as per AAPCS
@***********************************************************************

.equiv null2, 		0	@ null2 pointer for linked list
.equiv node_size3, 	8	@ byte 0123 for string address | 4567 for *nextg
.equiv nextg,		4	@ the offset to the first byte of *nextg
.equiv NOT_FOUND,	-1	@ -1 indicts that no node with keyIndex exist
.equiv TRUE,		1	@ 1 indicts that the removal was successful
.equiv FALSE,		0	@ 0 indicts that the removal was not successful


.data

.text

	.global Remove_node 	@ Provide program starting address to Linker
	
	.extern free
	
	@ r4  -> *tail
	@ r5  -> *Head
	@ r6  -> &keyNode (currentNode)
	@ r7  -> &Head
	@ r8  -> &Tail
	@ r10 -> KeyIndex
	@ r11 -> &ByteCounter
	

Remove_node:

	push {r1-r11, lr}	@ push r1-r11 and lr to stack, to preserve

	@ Make a second copy of all arguments passed in
	mov r7, r0			@ copy address of pointer to Head into r7
	mov r8, r1			@ copy address of pointer to Tail into r8
	mov r10, r2			@ copy address of KeyIndex into r10
	mov r11, r3			@ copy address of ByteCounter into r11
	
	@ Get the address of the first byte of the node we want to remove
	mov r0, r7			@ r0 = pointer to head
	mov r1, r10			@ r1 = value of KeyIndex
	bl Find_node		@ r0 = address of the first byte of the node in index (keyIndex)
	
	@ Check what was returned from Find_node and save it to a register
	cmp r0, #NOT_FOUND	@ compare(returnValue, NOT_FOUND)
	beq notFound		@ if no node was found with keyIndex do nothing
	mov r6, r0			@ r6 = &node that is being removed
	
	
	ldr r5, =head		@ r5 = *head
	ldr r5, [r5]
	ldr r4, [r8]		@ r4 = *tail
	@ Checks to see if it is the firstNode of the linked list
	cmp r6, r5			@ compare(&node, *head)
	bne	lastNode		@ if(&node == *head)
firstNode:
	ldr r7, =head
	ldr r3, [r5, #nextg]	@ r3 = head->nextg
	str r3, [r7]		@ head = head->nextg
	
	ldr r4, =tail
	ldr r4, [r4]
	cmp r6, r4			@ compare(&node, *tail)
	bne	remove			@ if(*head == *tail)
	mov r0, #null2		@ r0 = nullptr
	str r0, [r8]		@ tail = nullptr
	b remove			@ we are now ready to actually free the node
	
	@ The node to remove is the last node of the linked list
lastNode:	
	cmp r6, r4			@ compare(&node, *tail)
	bne	middle			@ if(&node == *tail)
	
	mov r0, r7			@ r0 = head
	mov r1, r10			@ r1 = keyIndex
	sub r1, #1			@ r1 = keyIndex - 1
	bl Find_node		@ r0 = first byte of the node one before keyIndex, linked-list[keyIndex - 1], prevNode
	
	str r0, [r8]		@ tail = tial->prev
	mov r1, #null2		@ r1 = nullptr
	str r1, [r0, #nextg]	@ tail->nextg = nullptr
	b remove			@ we are now ready to actually free the node

	@ The node to remove is at the middle of linked list
middle:
	mov r0, r7			@ r0 = head
	mov r1, r10			@ r1 = keyIndex
	sub r1, #1			@ r1 = keyIndex - 1
	bl Find_node		@ r0 = first byte of the node one before keyIndex, linked-list[keyIndex - 1], prevNode
	
	ldr r1, [r6, #nextg]	@ r1 = currentNode->nextg
	str r1, [r0, #nextg] @ prevNode->nextg = currentNode->nextg
	b remove			@ we are now ready to actually free the node


remove:
	@ Get the number of bytes that were malloced for keyNode->string
	ldr r0, [r6]		@ copy address of infoString of keyNode into r0
	bl String_Length	@ r0 = InfoString.length()
	add r0, #1			@ +1 for the null at the end of string
	
	@ Decrement the ByteCounter by the number of freed bytes
	ldr r1, [r11]		@ r1 = ByteCounter
	sub r1, r0			@ r1 = ByteCounter - (InfoString.length() + 1)
	sub r1, #node_size3	@ r1 = ByteCounter - node_size3(8 Bytes)
	str r1, [r11]		@ store the new count into ByteCounter 
	
	@ Now free the infoString of keyNode
	ldr r0, [r6]		@ copy address of infoString of keyNode into r0
	bl free				@ deallocate the infoString
	
	@ Now free the keyNode
	mov r0, r6			@ copy address of first byte of keyNode into r0
	bl free				@ deallocate the keyNode
	
	@ Return the appropriate signal to the caller
	mov r0, #TRUE		@ RETURN true to indict that the removal was successful
	b finishhere			@ end the method
notFound:
	mov r0, #FALSE		@ RETURN false to indict that the removal was not successful
	
finishhere:
	pop {r1-r11, lr}	@ bring stack back to initial state.
	bx lr				@ return from subroutine
