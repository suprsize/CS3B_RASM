@ Name:		Mohammad Amin
@ Program:	Push_back
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 22, 2020 at 3:30 PM

@ +push_back(Head:*int, Tail:*int, InfoString:string, ByteCounter:int)

@ Subroutine push_back accepts addresses of pointers to head, and tail 
@ of the linked list, accepts address of a static string that is being
@ pushed, and address of the allocated-byte counter. It will create a
@ new node of struct{string, *next} then it will copy the InfoString on
@ to the heap and will strore the first byte into the node.string(). 
@ After that it will update the byte-counter with number of bytes 
@ allocated on the heap for the InfoString. At the end it will push the
@ node to the end of linked list

@    R0: Points to head pointer.
@    R1: Points to tail pointer.
@    R2: Points to first byte of the static string to be pushed.
@    R3: Points to heap-allocated-byte counter.
@    LR: Contains the return address.

@ Returned register contents:
@    NOTHING.
@ All registers are preserved as per AAPCS
@***********************************************************************

.equiv NULL, 		0	@ NULL pointer for linked list
.equiv NODE_SIZE, 	8	@ byte 0123 for string address | 4567 for *next
.equiv NEXT,		4	@ the offset to the first byte of *next


.data

.text

	.global Push_back 	@ Provide program starting address to Linker
	
	.extern malloc
	
	@ r4  -> 
	@ r5  -> 
	@ r6  -> &newNode
	@ r7  -> &Head
	@ r8  -> &Tail
	@ r10 -> &InfoString
	@ r11 -> &ByteCounter
	

Push_back:

	push {r0-r11, lr}	@ push r1-r11 and lr to stack, to preserve

	@ Make a second copy of all arguments passed in
	mov r7, r0			@ copy address of pointer to Head into r7
	mov r8, r1			@ copy address of pointer to Tail into r8
	mov r10,  r2		@ copy address of InfoString into r10
	mov r11, r3			@ copy address of ByteCounter into r11
	
	
	@ Make the new node & point the node->next to NULL 
	mov r0, #NODE_SIZE	@ r0 = number of bytes needed for a node
	bl malloc			@ r0 = address of first byte of malloced space
	mov r6, r0			@ r6 = address of the new node(malloced space)
	mov r1, #NULL		@ r1 = nullptr
	str r1, [r6, #NEXT]	@ node->next = nullptr
	 
	@ Malloc the string and store the address into the new node 
	mov r0, r10			@ r0 = address of InfoString
	bl String_copy		@ r1 = new String{InfoString}
	str r1, [r6]		@ node.info = address of malloced string
	
	@ Get the number of bytes that were malloced
	mov r0, r10			@ copy address of infoString into r0
	bl String_Length	@ r0 = InfoString.length()
	add r0, #1			@ +1 for the null at the end of string
	
	@ Increment the ByteCounter by the number of newly malloced bytes
	ldr r1, [r11]		@ r1 = ByteCounter
	add r1, r0			@ r1 = ByteCounter + InfoString.length() + 1
	add r1, #NODE_SIZE	@ r1 = ByteCounter + NODE_SIZE(8 Bytes)
	str r1, [r11]		@ store the new count into ByteCounter 
	
	
	/* Store the new node into the Linked List */
	ldr r0, [r7]		@ r0 = *head
	cmp	r0, #NULL		@ compare(*head, nullptr)
	bne notEmpty		@ if(*head == nullptr)		
empty:
	str r6, [r7]		@ head = &newNode
	str r6, [r8]		@ tail = &newNode
	b finish			@ go to the end
notEmpty:
	ldr r0, [r8]		@ r0 = *tail
	str r6, [r0, #NEXT] @ tail->next = &newNode
	str r6, [r8]		@ tail = &newNode
	
	
finish:
	pop {r0-r11, lr}	@ bring stack back to initial state.
	bx lr				@ return from subroutine

