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
.macro printifFound                 @start of macro

    mov r10, r0                     @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    
    push {r0, r1}                   @push registers, i.e preserve the contents of the register for later use.                  
    cmp r10, #1                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.  
    cmpeq r6, #1                    @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.                
    ldreq r0, =foundat              @load if equal R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal     
    cmp r10, #1                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    cmpeq r6, #1                    @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    bleq putstring                  @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    cmp r10, #1                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    bne _endprint                   @branch not equal to end print

    cmp r8, #10                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r0, =newLine              @load if equal R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    cmp r8, #10                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    bleq putstring                  @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated            
    cmp r8, #10                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    moveq r8, #0                    @move a numeric value into Rn, Rn now == #x

    add r8, #1                      @add Rm to Rn or add #x to Rn

    ldr r0, =rightParen             @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r0, r11                     @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r1, =OUT                    @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl intasc32                     @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =OUT                    @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #0                      @move a numeric value into Rn, Rn now == #x
    str r1, [r0]                    @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    ldr r0, =leftParen              @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

_endprint: 
    pop {r0, r1}                    @pop registers, i.e return the contents of the register to their preserve state.
.endm                               @end of macro

.macro getStringInNode              @start of macro          

    mov r3, r0                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, [r0]                    @load Rn with Rn i.e get the value of Rn into Rn                     
    push {r1, r2, r3}               @push registers, i.e preserve the contents of the register for later use.
    ldr r1, =return                 @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal

whileNotEnd1:

    ldrb r2, [r0], #1               @load the first of R0 into R2 then add one to R0
    cmp r2, #32                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    strne r2, [r1], #1              @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    beq _endString                  @branch if equal to _end String 
    b whileNotEnd1                  @branch to while not end one

_endString:

    ldr r0, =return             @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    pop {r1, r2, r3}            @pop registers, i.e return the contents of the register to their preserve state.
.endm                           @end of macro

.macro NodeSize                 @start of macro

    bl String_Length            @branch and link to string length, string lenght takes r0, r0 --> 0xString --> val

_endSize:

.endm                           @end of macro

.data

    displayMessage:     .asciz "\nNow displaying the strings:\n\n"
    empty1:              .asciz "The list is empty.\n"
    head:       .word 0
    tail:       .word 0
    index:      .word 0
    count:      .word 0
    nodeCount2:  .word 0
    out:        .skip 16
    return:     .skip 100

.text

printList:

    push {r0-r2, r3}                     @push registers, i.e preserve the contents of the register for later use.

    ldr r0, =displayMessage              @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                         @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r1, =head                        @load r1 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r1, [r1]
    cmp r1, #0                           @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r0, =empty1                    @load if equal R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bleq putstring                       @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    beq _endOne
    ldr r1, =head                        @load r1 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r4, [r1]                         @load Rn with Rn i.e get the value of Rn into Rn 

    mov r6, #0                           @move a numeric value into Rn, Rn now == #x
    ldr r3, =index                       @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal

whileNotEnd:

    cmp r4, #0                          @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
	beq _endOne

    str r6, [r3]                        @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    PrintIndex index
    add r6, #1                          @add Rm to Rn or add #x to Rn               

    mov r0, r4                          @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, [r0]                        @load Rn with Rn i.e get the value of Rn into Rn 
    bl putstring                        @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =newLine                    @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                        @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r4, [r4, #4]                    @load Rn with Rn i.e get the value of Rn into Rn 
	b whileNotEnd

_endOne:

    pop {r0-r2, r3}                 @pop registers, i.e return the contents of the register to their preserve state.

    ldr r0, =szPrompt               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid

/****************************************************End Lable for One***************************************************/
/****************************************************Lable for Two***************************************************/
checkTwo:

    push {r0, r1, r2}               @push registers, i.e preserve the contents of the register for later use.

    ldrb r1, [r3], #1
    cmp r1, #50                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    bne endInvalid

    ldrb r1, [r3]                   @load the first of R3 into R1

    cmp r1, #97                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r0, =twoA                 @load if equal R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bleq putstring                  @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    beq selA

    cmp r1, #98                     @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r0, =twoB                 @load if equal R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bleq putstring                  @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated  
    beq selB                        @branch if equal to sel B 

    ldrne r0, =twoError
    blne putstring                  @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    bne _whileInvalid               @branch if not equal to while Invalid 

endInvalid:

    ldr r0, =invalidChar         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    b _whileInvalid

selA:
    mov r1, #512                @move a numeric value into Rn, Rn now == #x
    ldr r0, =szBuffer           @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl getstring                @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.

    ldr r3, =count              @load R3 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r2, r0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, =head               @load r0 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.

    ldr r1, =tail               @load r1 with the address of a word var named tail, tail contains the address of the begining of the linked list, tail --> 0xEndOfList.
    bl Push_back                @branch and link to push_back, push_back takes r0 --> head, r1 --> tail, r3 --> count
    b endForTwo                 @branch to end for two

selB:

    openFileToRead inFileName   
    mov r4, r0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r1, =szBuffer           @load r1 with the buffer
    mov r5, r1                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r8, #0                  @move a numeric value into Rn, Rn now == #x

whileNoteof:
    mov r0, r4                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r7, #3                  @move a numeric value into Rn, Rn now == #x
    mov r2, #1                  @move a numeric value into Rn, Rn now == #x
    svc 0                       @service command code zero                                                        

    cmp r0, #0                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.                  
    streq r8, [r1]              @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    beq addLast

    ldrb r2, [r1]               @load the first of R1 into R2
    cmp r2, #10                 @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    streq r8, [r1]              @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    beq addToList               @branch if equal to addTolist
    addne r1, #1                @add if not equal r1 with #1
    bne whileNoteof             @branch if not equal to while not end of file

addToList:

    ldr r3, =count                  @load R3 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r2, r5                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, =head                   @load r0 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r1, =tail                   @load r1 with the address of a word var named tail, tail contains the address of the begining of the linked list, tail --> 0xEndOfList.
    bl Push_back                    @branch and link to push_back, push_back takes r0 --> head, r1 --> tail, r3 --> count 
    mov r2, #0                      @move a numeric value into Rn, Rn now == #x
    ldr r1, =szBuffer               @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    str r2, [r1]                    @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    mov r5, r1                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    b whileNoteof                   @branch to while not end of 

addLast:

    ldr r3, =count                  @load R3 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r2, r5                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, =head                   @load r0 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r1, =tail                   @load r1 with the address of a word var named tail, tail contains the address of the begining of the linked list, tail --> 0xEndOfList.
    bl Push_back                    @branch and link to push_back, push_back takes r0 --> head, r1 --> tail, r3 --> count
    mov r2, #0                      @move a numeric value into Rn, Rn now == #x
    ldr r1, =szBuffer               @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    str r2, [r1]                    @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    mov r5, r1                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    b endForTwo                     @branch to end for two. Not needed but makes clearer 

endForTwo:

    pop {r0, r1, r2}                @pop registers, i.e return the contents of the register to their preserve state.
    ldr r0, =szPrompt               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid

/****************************************************End lable for Two***************************************************/
/**************************************************** lable for Three ***************************************************/
.data
    delMessage:     .asciz "\nEnter the index to delete:\t"

    indexBuff:      .skip 16
.text

getIndexToDel:
    push {r0-r2}                    @push registers, i.e preserve the contents of the register for later use.

    ldr r0, =delMessage             @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                    @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    mov r1, #12                     @move a numeric value into Rn, Rn now == #x
    ldr r0, =indexBuff              @load r0 with the address of indexBuff --> buffer
    bl getstring                    @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.
    bl ascint32                     @branch and link to ascint32, ascint32 takes r0 --> sting --> 0xStringStart, ascint32 takes nothing else int value of char is returned in r0
    mov r2, r0                      @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, =tail                   @load r0 with the address of a word var named tail, tail contains the address of the begining of the linked list, tail --> 0xEndOfList.
    ldr r1, =head                   @load r1 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r3, =count                  @load r3 with the address of count --> #NumNodes 
    bl Remove_node                  @branch and link to Remove_node, Remove_node takes a r1 --> tail --> 0xEndOfList and Remove_node takes r0 --> head --> 0xStarOfList and Remove_node takes r3 --> count --> #NUMNODES


    pop {r0-r2}                     @pop registers, i.e return the contents of the register to their preserve state.
    ldr r0, =szPrompt               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid
/****************************************************End lable for Three***************************************************/
/**************************************************** lable for Four ***************************************************/

.data
    editMessage:     .asciz "\nEnter the index to edit:\t"
    override:     .asciz "\nEnter the the string that you would like to replace the node with:\t"
    indexBuff2:      .skip 16
    indexBuff4:      .skip 512
.text

getIndexToEdit:
    push {r0-r2}                @push registers, i.e preserve the contents of the register for later use.
    
    ldr r0, =editMessage        @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    mov r1, #12                 @move a numeric value into Rn, Rn now == #x
    ldr r0, =indexBuff2         @load r0 with the address of indexBuff2 --> buffer
    bl getstring                @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.
    bl ascint32                 @branch and link to ascint32, ascint32 takes r0 --> sting --> 0xStringStart, ascint32 takes nothing else int value of char is returned in r0
    mov r5, r0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value         
    ldr r0, =override           @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    mov r1, #512                @move a numeric value into Rn, Rn now == #x
    ldr r0, =indexBuff4         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl getstring
    mov r1, r5                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r3, r0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    bl editNode                 @branch and link to edit node 

    pop {r0-r2}                @pop registers, i.e return the contents of the register to their preserve state.
    ldr r0, =szPrompt          @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid
/**************************************************** End lable for Four ***************************************************/
/**************************************************** lable for Five ***************************************************/
.data
    subStringM:     .asciz "\nEnter the string to search for:\t\t"
    outMessage5:    .asciz "\n\nThe amount of the string is:\t"
    index2:         .word 0
    stringBuff:     .skip 30
    szOut:          .skip 16
    OUT:            .skip 16
.text

getStringForSearch:
    push {r0-r2}            @push registers, i.e preserve the contents of the register for later use.
    mov r8, #-2             @move a numeric value into Rn, Rn now == #x
    ldr r0, =subStringM     @load r0 with the address of subStringM --> #x
    bl putstring            @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    mov r1, #100            @move a numeric value into Rn, Rn now == #x
    ldr r0, =stringBuff     @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl getstring            @branch and link to getstring, getstring takes r0, --> string --> 0xStringStart, getstring takes r1 --> numeric value to hold string buffer, the string is returned in r0.

    ldr r1, =head           @load r1 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r4, [r1]            @load Rn with Rn i.e get the value of Rn into Rn 

    mov r6, #0              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    ldr r3, =index2         @load r3 with the address of index2 --> #x
    mov r9, r0              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r11, #-1            @move a numeric value into Rn, Rn now == #x
whileNotEnd2:
    add r11, #1             @add Rm to Rn or add #x to Rn
    cmp r4, #0              @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
	beq _endFive            @branch if equal to end Five
    mov r0, #0              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value
    ldr r1, =return         @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    str r0, [r1]            @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x

    mov r0, r4              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, [r0]            @load Rn with Rn i.e get the value of Rn into Rn 
    NodeSize
    mov r3, r0              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r0, r4              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, [r0]            @load Rn with Rn i.e get the value of Rn into Rn 
    mov r7, #0              @move a numeric value into Rn, Rn now == #x

whilelessSize:

    cmp r3, r7              @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r4, [r4, #4]      @load if equal R4 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    beq whileNotEnd2
    push {r1, r2, r3}       @push registers, i.e preserve the contents of the register for later use.
    ldr r1, =return         @load R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal

whileNotEnd1:

    ldrb r2, [r0], #1       @load the first of R0 into R2 then add one to R0
    cmp r2, #0              @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
            
    beq _endString          @branch if equal to end String
    cmp r2, #32             @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    strne r2, [r1], #1      @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    add r7, #1              @add Rm to Rn or add #x to Rn
    beq _endString          @branch if equal to end string
    b whileNotEnd1          @branch to while not end one

_endString:

    ldr r0, =return             @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    pop {r1, r2, r3}            @pop registers, i.e return the contents of the register to their preserve state.

    mov r1, r9                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    bl String_equalIgnoreCase
    cmp r0, #1                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    addeq r6, #1
                   
    printifFound

    mov r0, r4                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r0, [r0]                @load Rn with Rn i.e get the value of Rn into Rn 
    add r0, r7                  @add Rm to Rn or add #x to Rn
	b whilelessSize             @branch while less then size

_endFive:
   
    mov r0, r6                   @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r1, =szOut               @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    bl intasc32                  @macro intasc32 is used to convert an interger to a asci char so it can printed to the consol via putstring, r0 must contain the value to be converted and r1 must have a buffer large enough to hold the conversion
    ldr r0, =outMessage5         @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated
    ldr r0, =szOut               @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    pop {r0-r2}                  @pop registers, i.e return the contents of the register to their preserve state.
    ldr r0, =szPrompt            @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid
/**************************************************** End lable for Five ***************************************************/
/**************************************************** lable for Six ***************************************************/
.data
    szSaveMessage:     .asciz "\nNow saving to a file...\n"
.text
saveToFile:

    ldr r0, =szSaveMessage       @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    bl putstring                 @use macro putstring to output the string pointed to in r0 to the consol, r0 must contain the address of a string of a string that is NULL terminated

    ldr r0, =outFileName        @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r7, #5                  @move a numeric value into Rn, Rn now == #x
    mov r1, #0101               @move a numeric value into Rn, Rn now == #x
    mov r2, #0777               @move a numeric value into Rn, Rn now == #x
    svc 0                       @service command code zero 

    mov r11, r0                 @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r9, #10                 @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r6, #0                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value                
    ldr r1, =head               @load r1 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r4, [r1]                @load Rn with Rn i.e get the value of Rn into Rn 

whileNotEndSix:

    cmp r4, #0                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
	beq _endSix                 @branch if equal to the end six
    push {r1}                   @push registers, i.e preserve the contents of the register for later use.
    mov r1, r4                  @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    ldr r1, [r1, #4]            @load Rn with Rn i.e get the value of Rn into Rn 

    cmp r1, #0                  @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    ldreq r1, [r4]              @load if equal R1 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    beq _endBefore              @branch if equal to the end 

    pop {r1}                    @pop registers, i.e return the contents of the register to their preserve state.

    mov r6, #0                  @move a numeric value into Rn, Rn now == #x
    ldr r1, [r4]                @load Rn with Rn i.e get the value of Rn into Rn 
    b len                       @branch to len 

backlen:

    mov r7, #4              @move a numeric value into Rn, Rn now == #x
    ldr r1, [r4]            @load Rn with Rn i.e get the value of Rn into Rn 
    mov r2, r6              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r0, r11             @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    svc 0                   @service command code zero
    ldr r4, [r4, #4]        @load Rn with Rn i.e get the value of Rn into Rn 
	b whileNotEndSix        @branch to the end of the program

len:
    add r6, #1              @add Rm to Rn or add #x to Rn
    ldrb r10, [r1]          @load the first of R1 into R10
    cmp r10, #0             @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.

backfromNull:
    cmp r10, #0             @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags
    addne r1, #1            @add if not equal r1 to #1
    streq r9, [r1]          @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    bne len                 @branch to not equal len 
    b backlen               @branch to backlen 
_endBefore:                

_LAST:
    mov r0, r1              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    bl String_Length        @branch and link to string length, string lenght takes r0, r0 --> 0xString --> val
    mov r6, r0              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    bne _LAST
    mov r7, #4              @move a numeric value into Rn, Rn now == #x
    ldr r1, [r4]            @load Rn with Rn i.e get the value of Rn into Rn 
    mov r2, r6              @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    mov r0, r11             @mov the contents of register Rn into Rm, i.e if Rn --> 0xStringOne, mov Rm, Rn, Rm now ---> 0xStringOne, this is the same if Rn has a numeric value 
    svc 0                   @service command code zero

_endSix:
    ldr r0, =szPrompt       @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    b _whileInvalid         @branch to while invalid 
/**************************************************** End lable for Six ***************************************************/
/**************************************************** lable for seven ***************************************************/
_deleteList:
    push {r0, r1}               @push registers, i.e preserve the contents of the register for later use.
    ldr r0, =head               @load r0 with the address of a word var named head, head contains the address of the begining of the linked list, head --> 0xStartList.
    ldr r1, =tail               @load r1 with the address of a word var named tail, tail contains the address of the begining of the linked list, tail --> 0xEndOfList.
    ldr r3, =count              @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    
_loopSeven:
    
    ldr r2, =nodeCount2         @load R2 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    ldr r2, [r2]
    cmp r2, #-1                 @cmp register Rn to a numeric value, operation is Rn - #x, and then it sets the cpsr flags.
    beq _endSeven
    
    bl Remove_node              @branch and link to Remove_node, Remove_node takes a r1 --> tail --> 0xEndOfList and Remove_node takes r0 --> head --> 0xStarOfList and Remove_node takes r3 --> count --> #NUMNODES 
    
    b _loopSeven                @branch to _loop seven 


_endSeven:
    ldr r0, =nodeCount2 @load R0 with te address of a varible, i.e R0 --> 0xVar --> VarVal
    mov r1, #0          @move a numeric value into Rn, Rn now == #x
    str r1, [r0]        @Store the contents of Rn into Rm, Rn --> #x, Rm --> 0xAddress --> #x
    pop {r0, r1}        @pop registers, i.e return the contents of the register to their preserve state.
    b _next

/**************************************************** End lable for seven ***************************************************/
