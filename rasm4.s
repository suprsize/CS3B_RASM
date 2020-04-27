@***********************************************************************
@ Name:		Mohammad Amin & Khaja Zuhuruddin
@ Program:	Rasm4.s
@ Class:	CS3B
@ Lab:		RASM4
@ Date:		April 29, 2020 at 3:30 PM
@***********************************************************************
@       Purpose:  
@                 Give the user the option to read in from the file or keyboard, the user can then edit the contents 
@                 of the list and therefore we have a created a very basic text editor.
/****************************************************Lable for One***************************************************/
.equiv LEN, 512	@ const that has the maximum bytes getstring readsequiv LEN, 32	

.macro PrintIndex Index              @start of macro 

    push {r0, r1, r2}                @push registers, i.e preserve the contents of the register for later use. 
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

    pop {r0, r1, r2}                 @pop registers, i.e return the contents of the register to their preserve state.

.endm

.macro printCount
    push {r0, r1}                   @push registers, i.e preserve the contents of the register for later use.

    ldr r0, =nodeCount
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    ldr r0, =nodeCount2             @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, [r0]                    @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =outCount               @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32                     @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =outCount               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal          
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #0                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    str r1, [r0]                    @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    
    pop {r0, r1}                    @pop registers, i.e return the contents of the register to their preserve state.
.endM
.macro ClearScreen String

        push {r0, r1}               @push registers, i.e preserve the contents of the register for later use.

        ldr r0, =enter  
        bl putstring                @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
        ldr r0, =szBuffer           
        mov r1, #12                 @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
        bl getstring                @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.
        mov r1, #0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
        str r1, [r0]
        ldr r0, =newLine

    _whileClear:
        
        cmp r1, #100                @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
        beq _endC

        bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

        add r1, #1
        b _whileClear

    _endC:

            ldr r0, =cleared         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
            bl putstring            @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

            pop {r0, r1}            @pop registers, i.e return the contents of the register to their preserve state.
.endM

.macro output szOut
    
    mov r0, #1                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    ldr r1, =\szOut             @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r2, #30                 @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    mov r7, #4                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    svc 0

.endM

.macro openFileToRead FileName

    ldr r0, =\FileName          @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r1, #00                 @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    mov r7, #5                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    svc 0

.endM

.macro readFile szReadBuffer
    
    ldr r1, =\szReadBuffer      @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r7, #3                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    mov r2, #LEN                @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    svc 0

.endm

.macro closeFile

    mov r7, #6                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    svc 0                       @service call with code zero

.endM

.macro PrintNumNode
    push {r0, r1}            @push registers, i.e preserve the contents of the register for later use.

    ldr r0, =memoryUsage      @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    
    ldr r0, =count           @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, [r0]             @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =outCount        @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32              @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =outCount
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #0               @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    str r1, [r0]

    ldr r0, =memoryUsageTwo   @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0, r1}            @pop registers, i.e return the contents of the register to their preserve state.
.endm 
.macro printMenu

    push {r0}                @push registers, i.e preserve the contents of the register for later use.

    ldr r0, =menuOne         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuTwo         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuThree       @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuFour        @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuFive        @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuSix         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal    
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =menuSeven       @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring             @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0}                 @pop registers, i.e return the contents of the register to their preserve state.

.endM

.data 

    foundat:     .asciz "\nFound at:\n"

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
    
    ldr r0, =message             @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    

    push {r1, r2}                @push registers, i.e preserve the contents of the register for later use.
    ldr r0, =szPrompt            @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal              
    b _first                     @branch to the _first lable 

_whileInvalid:

    ClearScreen                    @clear the screen using macro clearScreen

_first:
    PrintNumNode                  @print the number of nodes
    printCount                    @print the number of bytes  
    printMenu                     @print the menu

    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =szIn               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r1, #4                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value               
    bl getstring                @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.

    mov r3, r0
    bl ascint32
    bcs checkTwo 
    mov r2, r0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value

    cmp r2, #7                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    ldreq r0, =finished         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bleq putstring              @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    beq _deleteList             @branch if equal to lable that goes with the numeric value entered
    
    cmp r2, #2                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    ldreq r0, =twoError2        @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    beq _first                  @branch if equal to lable that goes with the numeric value entered

    cmp r2, #0                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    ldrle r0, =ltError          @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    cmp r2, #0
    ble _first

    cmp r2, #7                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    ldrgt r0, =gtError          @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    cmp r2, #7                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    bgt _first                  @branch if equal to lable that goes with the numeric value entered 

    cmp r2, #1                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    beq printList               @branch if equal to lable that goes with the numeric value entered 
   
    cmp r2, #3                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    beq getIndexToDel           @branch if equal to lable that goes with the numeric value entered

    cmp r2, #4                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    beq getIndexToEdit          @branch if equal to lable that goes with the numeric value entered

    cmp r2, #5                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    beq getStringForSearch      @branch if equal to lable that goes with the numeric value entered

    cmp r2, #6                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    beq saveToFile              @branch if equal to lable that goes with the numeric value entered

_next: 

    pop {r1, r2}    @pop registers, i.e return the contents of the register to their preserve state.

end:
   
    mov r0, #0 		@ Exit Status code set to 0 indicates "normal completion"
	mov r7, #1 		@ Service command code (1) will terminate this program
	svc 0	   		@ Issue Linux command to terminate program
	.end


