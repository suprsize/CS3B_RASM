@***********************************************************************
@ Name:		Mohammad Amin & Khaja Zuhuruddin
@ Program:	Rasm4.s
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 29, 2020 at 3:30 PM
@***********************************************************************

.equiv LEN, 512	@ const that has the maximum bytes getstring readsequiv LEN, 32	

.macro PrintIndex Index

    push {r0, r1, r2}
    mov r2, #0 
    ldr r0, =rightParen
    bl putstring                     @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =\Index                  @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, [r0]                     @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =indexOut                @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    str r2, [r1]                     @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32                      @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =indexOut
    bl putstring                     @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =leftParen
    bl putstring                     @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0, r1, r2}

.endm

.macro printCount
    push {r0, r1}

    ldr r0, =nodeCount
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    ldr r0, =nodeCount2             @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, [r0]                    @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =outCount               @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32                     @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =outCount
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #0
    str r1, [r0]
    
    pop {r0, r1}
.endM
.macro ClearScreen String

        push {r0, r1}

        ldr r0, =enter  
        bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
        ldr r0, =szBuffer
        mov r1, #12
        bl getstring
        mov r1, #0
        str r1, [r0]
        ldr r0, =newLine

    _whileClear:
        
        cmp r1, #100
        beq _endC

        bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

        add r1, #1
        b _whileClear

    _endC:

            ldr r0, =cleared
            bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

            pop {r0, r1}
.endM

.macro output szOut
    
    mov r0, #1
    ldr r1, =\szOut
    mov r2, #30
    mov r7, #4
    svc 0

.endM

.macro openFileToRead FileName

    ldr r0, =\FileName
    mov r1, #00
    mov r7, #5
    svc 0

.endM

.macro readFile szReadBuffer
    
    ldr r1, =\szReadBuffer
    mov r7, #3
    mov r2, #LEN
    svc 0

.endm

.macro closeFile

    mov r7, #6 
    svc 0

.endM

.macro PrintNumNode
    push {r0, r1}

    ldr r0, =memoryUsage
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    
    ldr r0, =count           @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, [r0]             @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =outCount        @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32              @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =outCount
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #0
    str r1, [r0]

    ldr r0, =memoryUsageTwo
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0, r1}
.endm 
.macro printMenu

    push {r0}

    ldr r0, =menuOne
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuTwo
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuThree
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuFour
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuFive
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuSix
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuSeven
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0}

.endM

.data 

    rightParen: .asciz "[" 

    leftParen: .asciz "] "

    indexOut:   .skip 16

    message:    .asciz  "\n\n\tName:\t\tKhaja Zuhuruddin\n\tProgram:\trasm4.s\n\tClass:\t\tCS 3B\n\tDate:\t\t4/22/20\n\n"
    
    Prompt:     .asciz "\nClear Screen (Y/N):\t"
     
    noClear:    .asciz "\nThe screen has not been cleared. Closing...\n"

    cleared:    .asciz "The Screen has been cleared.\n"

    fileName:   .asciz "Output.txt"

    szToFile:   .asciz "Test."

    newLine:    .asciz "\n"

    outCount:   .skip 30
    
    /*** Menu part of data ***/

    enter:          .asciz "\nPress ENTER to continue.\t"

    memoryUsage:    .asciz "\nData Structure Memory Consumption: "

    memoryUsageTwo: .asciz " bytes"

    nodeCount:      .asciz "\nNumber of Nodes:\t"

    menuOne:        .asciz "\n<1> View all strings\n"

    menuTwo:        .asciz  "\n<2> Add string\n\t<a> from Keyboard\n\t<b> from File. Static file named input.txt\n"

    menuThree:      .asciz "\n<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n"

    menuFour:       .asciz "\n<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n"

    menuFive:       .asciz "\n<5> String search. Regardless of case, return all strings that match the substring given.\n"

    menuSix:        .asciz "\n<6> Save File (output.txt)\n"

    menuSeven:      .asciz "\n<7> Quit\n"

    inFileName:     .asciz "input.txt"

    outFileName:    .asciz "output.txt"

    ltError:        .asciz "\nInvalid Zero or Negative! Please re-enter a number between 1 and 7:\t"

    gtError:        .asciz "\nInvalid number greater then Seven! Please re-enter a number between 1 and 7:\t"

    finished:       .asciz "\nQuitting...\n\n"

    szPrompt:       .asciz "\nPlease enter a number:\t"

    twoA:           .asciz "\n'a' has been selected. Please enter a string:\t"

    twoB:           .asciz "\n'b' has been selected.\n"

    twoError:       .asciz "\nThe char following 2 is invalid, char must be a or b. Please re-enter your answer:\t"

    twoError2:      .asciz "The value 2 must have a char ('a' or 'b') following it. Please re-enter your answer:\t"

    invalidChar:    .asciz "\nInvalid char in string. Please re-enter the string:\t"
    
    szIn:  .skip 5

    szBuffer:   .skip LEN
    

.text
    	
    .extern malloc
    .extern free	

    .global _start

_start:
    
    ldr r0, =message
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    

    push {r1, r2}
    ldr r0, =szPrompt
    b _first

_whileInvalid:

    ClearScreen

_first:
    PrintNumNode
    printCount
    printMenu

    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =szIn
    mov r1, #4
    bl getstring

    mov r3, r0
    bl ascint32
    bcs checkTwo 
    mov r2, r0

    cmp r2, #7
    ldreq r0, =finished
    bleq putstring              @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    beq _deleteList
    
    cmp r2, #2
    ldreq r0, =twoError2
    beq _first

    cmp r2, #0
    ldrle r0, =ltError
    cmp r2, #0
    ble _first

    cmp r2, #7
    ldrgt r0, =gtError
    cmp r2, #7
    bgt _first

    cmp r2, #1 
    beq printList 
   
    cmp r2, #3
    beq getIndexToDel

    cmp r2, #4
    beq getIndexToEdit

    cmp r2, #5
    beq getStringForSearch

    cmp r2, #6
    beq saveToFile

_next: 

    pop {r1, r2}

end:
   
    mov r0, #0 		@ Exit Status code set to 0 indicates "normal completion"
	mov r7, #1 		@ Service command code (1) will terminate this program
	svc 0	   		@ Issue Linux command to terminate program
	.end


