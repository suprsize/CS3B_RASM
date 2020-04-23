@*****************************************************************************
@Name:      Khaja Zuhuruddin
@Program:   String_copy
@Class:     CS 3B
@Lab:       RASM2
@Date:      3/31/20 at 3:30  
@*****************************************************************************
/* 
    Coded by: 
            Khaja Zuhuruddin.
    Description:    
                --> Subroutine String_copy accepts the address of a string
                --> It will return a copy of the string in r1
                --> will read a string of characters terminated by a null
                --> R0: Points to first byte of string to copy
                --> LR: Contains the return address
                --> Returned register contents: r1 with a copy of the string
                --> All registers are preserved as per AAPCS
 */

.data 
   toFree:      .word 0
.text    

    .func String_copy
    
    .extern malloc 
    .extern free

String_copy:

    push {r0, r3-r12, lr}       @push aapcs register 

    mov r7, r0              @mov r7 with r0
    bl String_Length        @bl to String_length, pass in r0 which contains a pointer to a string that is null terminated, r0 will be returned with the length of the string not including the null

    add r0, #1              @add one to the lenght for malloc
    bl malloc               @bl to malloc
    
    mov r1, r0              @mov r1 with r0

_copy_loop:                 @loop for copy

    ldrb r4, [r7], #1       @load byte of r7 into r2 then add r7 by one

    cmp r4, #0              @cmp the byte with zero
    beq _end_String_copy    @if it equal then it is the end of the string and go to the end
    
    str r4, [r1], #1        @str r2 into r1 and r1 by #1

    b _copy_loop            @branch back to eh copy loop

_end_String_copy:           @lable for the end of the function

    mov r1, r0              @mov r1 with r0

    pop {r0, r3-r12, lr}        @pop aapcs register
    
    bx lr                   @go back to the call

    .endfunc                @end of the function
