@*****************************************************************************
@Name:      Khaja Zuhuruddin
@Program:   String_equalIgnoreCase
@Class:     CS 3B
@Lab:       RASM2
@Date:      3/31/20 at 3:30  
@*****************************************************************************
/* 
    Coded by: 
            Khaja Zuhuruddin.
     Description:    
                --> Subroutine String_equalIgnoreCase accepts the address of a string and another string
                --> will read the strings to see if they are equal 
                --> will read a string of characters terminated by a null
                --> R0: Points to first byte of string to read, R1 points to the first byte of the second string
                --> LR: Contains the return address
                --> Returned register contents:
                --> R0: ONE or ZERO
                --> All registers are preserved as per AAPCS
 */
.data 

.text

    .func String_equalIgnoreCase

String_equalIgnoreCase:

    push {r2-r12, lr}                       @push aapcs registers

    mov r3, r1                              @mov r3 r1 to get the second string
    mov r4, r0                              @mov r4 r0 to get the first string

    bl String_Length                        @bl to String_length, pass in r0 which contains a pointer to a string that is null terminated, r0 will be returned with the length of the string not including the null
    mov r2, r0                              @store the length of the first string in r2

    mov r1, #0                              @mov r1, #0 i.e clear r1

    mov r0, r3                              @mov r0, r3 with the address of the second string
    bl String_Length                        @bl to String_length, pass in r0 which contains a pointer to a string that is null terminated, r0 will be returned with the length of the string not including the null

    cmp r2, r0                              @if the lengths of the strings are not equal the strings cannot be equal
    movne r0, #0                            @if the lengths of the strings are not equal the strings cannot be equal
    bne _end_String_equalIgnoreCase         @if the lengths of the strings are not equal the strings cannot be equal

    mov r0, r4                              @give r0 back the first string
    mov r1, r3                              @give r1 back the second string

_checkCaseEqual:                            @loop to check for equal

    mov r5, r0                              @Check to see if the next char is NULL
    add r5, #1                              @Check to see if the next char is NULL
    ldrb r6, [r5]                           @Check to see if the next char is NULL
    cmp r6, #0                              @Check to see if the next char is NULL

    beq _last_String_equalIgnoreCase        @Check to see if the next char is NULL

    ldrb r2, [r0], #1                       @ldrb r2 with the first string and add #1
    ldrb r3, [r1] ,#1                       @ldrb r3 with the second string and add #1
        
    cmp r2, r3                              @cmp the two bytes                                
    bne _checkCase                          @if they are not equal then check the case
    
    b _checkCaseEqual                       @branch back to the top of the loop

_checkCase:                                 @lable to check the case

    cmp r2, r3                              @cmp the two bytes to see what you need to add
    addlt r2, #32                           @if it less then r3 then add r2 by #32
    addgt r3, #32                           @if it greate then r2 then add r3 by #32

    cmp r2, r3                              @compare them

    movne r0, #0                            @if they are not equal then move #0 or false into r0
    bne _end_String_equalIgnoreCase         @branch to the end if they are not equal

    moveq r4, #1                            @if they are equal the move r4 #1
    beq _checkCaseEqual                     @branch back to checking the case

_last_String_equalIgnoreCase:               @label to check the last byte
    
    ldrb r2, [r0]                           @ldrb r2 with the first string                    
    ldrb r3, [r1]                           @ldrb r3 with the second string 

    cmp r2, r3                              @cmp the two bytes to see what you need to add  
    addlt r2, #32                           @if it less then r3 then add r2 by #32
    addgt r3, #32                           @if it greate then r2 then add r3 by #32

    cmp r2, r3                              @compare them now
    moveq r4, #1                            @if they are equal then give r4 a 1 or true
    movne r4, #0                            @if they are not equal then give r4 a zero or false.

    b good_String_equalIgnoreCase           @branch to the good check

good_String_equalIgnoreCase:                @lable for the good case
    
    mov r0, r4                              @mov r0 with r4
    b _end_String_equalIgnoreCase           @branch to the end

_end_String_equalIgnoreCase:                @lable forn the end

    pop {r2-r12, lr}                        @pop aapcs register

    bx lr                                   @go back to the caller

    .endfunc                                @end if the function

