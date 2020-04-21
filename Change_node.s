@ Name:		Mohammad Amin
@ Program:	Change_node
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 22, 2020 at 3:30 PM

@ +Change_node(Head:*int, newString:String, KeyIndex:int, ByteCounter:int):bool

@ Subroutine Change_node accepts address of pointer to the head, the   
@ address of newString, accepts an interger key index  that is being
@ modified, and address of the allocated-byte counter. It will first look
@ to see where the keyNode is located. Once located the current string is
@ freed and the deallocated bytes will be deducted from allocted-byte 
@ counter. Then the new string is copied onto heap and the address of
@ newString on heap replaces the oldString's address on the node. 
@ The allocated-byte counter is incremented by the bytes that were newly
@ allocated for the newString. If the index passed in is not valid for 
@ changing, the method will return 0 to indict that the removal was not 
@ successful. Otherwise, it  will return 1 for successful execution.  


@    R0: Points to head pointer.
@    R1: Points to a static string to be swapped with current string
@    R2: The index number being removed.
@    R3: Points to heap-allocated-byte counter.
@    LR: Contains the return address.

@ Returned register contents:
@    R0: 1 for succesful execution and 0 for unsuccessful execution.
@ All registers are preserved as per AAPCS
@***********************************************************************

.equiv NULL, 		0	@ NULL pointer for linked list
.equiv NODE_SIZE, 	8	@ byte 0123 for string address | 4567 for *next
.equiv NEXT,		4	@ the offset to the first byte of *next
.equiv NOT_FOUND,	-1	@ -1 indicts that no node with keyIndex exist
.equiv TRUE,		1	@ 1 indicts that the removal was successful
.equiv FALSE,		0	@ 0 indicts that the removal was not successful


.data

.text

	.global Change_node 	@ Provide program starting address to Linker
	
	.extern free
	
	@ r4  -> 
	@ r5  -> 
	@ r6  -> &keyNode (currentNode)
	@ r7  -> &Head
	@ r8  -> &newString
	@ r10 -> KeyIndex
	@ r11 -> &ByteCounter
	

Change_node:

	push {r1-r11, lr}	@ push r1-r11 and lr to stack, to preserve

	@ Make a second copy of all arguments passed in
	mov r7, r0			@ copy address of pointer to Head into r7
	mov r8, r1			@ copy address of address of newString into r8
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
	
	@ Get the number of bytes that were malloced for keyNode->string
	ldr r0, [r6]		@ copy address of infoString of keyNode into r0
	bl String_Length	@ r0 = InfoString.length()
	add r0, #1			@ +1 for the null at the end of string
	
	@ Decrement the ByteCounter by the number of freed bytes
	ldr r1, [r11]		@ r1 = ByteCounter
	sub r1, r0			@ r1 = ByteCounter - (InfoString.length() + 1)
	str r1, [r11]		@ store the new count into ByteCounter 
	
	@ Get the number of bytes that were malloced for newString
	mov r0, r8			@ copy address of infoString into r0
	bl String_Length	@ r0 = InfoString.length()
	add r0, #1			@ +1 for the null at the end of string
	
	@ Increment the ByteCounter by the number of newly malloced bytes
	ldr r1, [r11]		@ r1 = ByteCounter
	add r1, r0			@ r1 = ByteCounter + InfoString.length() + 1
	str r1, [r11]		@ store the new count into ByteCounter 
		
	@ Now free the infoString of keyNode
	ldr r0, [r6]		@ copy address of infoString of keyNode into r0
	bl free				@ deallocate the infoString
	
	@ Malloc the string and store the address into the new node 
	mov r0, r8			@ r0 = address of newString
	bl String_copy		@ r1 = new string{newString}
	str r1, [r6]		@ node.info = address of malloced string
	
	
	@ Return the appropriate signal to the caller
	mov r0, #TRUE		@ RETURN true to indict that the removal was successful
	b finish			@ end the method
notFound:
	mov r0, #FALSE		@ RETURN false to indict that the removal was not successful
	
finish:
	pop {r1-r11, lr}	@ bring stack back to initial state.
	bx lr				@ return from subroutine

