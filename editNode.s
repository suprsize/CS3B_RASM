@ Name:		
@ Program:	
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 22, 2020 at 3:30 PM


.text
    .global editNode

editNode:
    push {r4-r12, lr}

    //mov r1, r0
    ldr r0, =head
    //ldr r0, [r0]
    bl Find_node
    cmp r0, #-1
    beq endEditNode
    //ldr r0, [r0]
    str r3, [r0]

endEditNode:
    pop {r4-r12, lr}
    bx lr
