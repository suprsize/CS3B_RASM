@***********************************************************************
@ Name:		Mohammad Amin & Khaja Zuhuruddin
@ Program:	Rasm4.s
@ Class:	CS3B
@ Lab:		RASM3
@ Date:		April 8, 2020 at 3:30 PM
@***********************************************************************
/****************************************************Lable for One***************************************************/

.macro getStringInNode
    mov r3, r0
    ldr r0, [r0]
    push {r1, r2, r3}
    ldr r1, =return
whileNotEnd1:
    ldrb r2, [r0], #1
    cmp r2, #32
    strne r2, [r1], #1
    beq _endString
    b whileNotEnd1
_endString:
    ldr r0, =return
    pop {r1, r2, r3}
.endm

.macro NodeSize

    bl String_Length

_endSize:

.endm
.data  

    displayMessage:     .asciz "\nNow displaying the strings:\n\n"

    head:       .word 0
    tail:       .word 0
    index:      .word 0
    count:      .word 0

    out:        .skip 16
    return:     .skip 100
    
.text

printList:

    push {r0-r2, r3}
    
    ldr r0, =displayMessage
    bl putstring

    ldr r1, =head
    ldr r4, [r1]

    mov r6, #0
    ldr r3, =index

whileNotEnd:
    
    cmp r4, #0		
	beq _endOne		

    str r6, [r3]
    PrintIndex index
    add r6, #1		

    mov r0, r4
    ldr r0, [r0]
    bl putstring

    ldr r0, =newLine
    bl putstring
	
    ldr r4, [r4, #4]	
	b whileNotEnd				

_endOne:

    pop {r0-r2, r3}

    ldr r0, =szPrompt
    b _whileInvalid

/****************************************************End Lable for One***************************************************/
/****************************************************Lable for Two***************************************************/
checkTwo:
    
    push {r0, r1, r2}

    ldrb r1, [r3], #1
    cmp r1, #50
    bne endInvalid
    
    ldrb r1, [r3]
    
    cmp r1, #97
    ldreq r0, =twoA
    bleq putstring
    beq selA

    cmp r1, #98
    ldreq r0, =twoB
    bleq putstring
    beq selB

    ldrne r0, =twoError
    blne putstring
    bne _whileInvalid

endInvalid:

    ldr r0, =invalidChar
    bl putstring
    b _whileInvalid

selA:
    mov r1, #512
    ldr r0, =szBuffer
    bl getstring
    
    ldr r3, =count
    mov r2, r0
    ldr r0, =head
    
    ldr r1, =tail
    bl Push_back
    b endForTwo
   
selB:

    openFileToRead inFileName
    mov r4, r0
    ldr r1, =szBuffer  
    mov r5, r1 
    mov r8, #0

    whileNoteof:

        //add r6, #1
        mov r0, r4
        mov r7, #3
        mov r2, #1
        svc 0
       
        cmp r0, #0
        streq r8, [r1]
        beq addLast

        ldrb r2, [r1]
        cmp r2, #10
        streq r8, [r1]
        beq addToList
        addne r1, #1
        bne whileNoteof

    addToList:
        //mov r6, #0
        ldr r3, =count
        mov r2, r5
        ldr r0, =head
        ldr r1, =tail
        bl Push_back
        mov r2, #0
        ldr r1, =szBuffer
        str r2, [r1]
        mov r5, r1
        b whileNoteof

    addLast:
        //mov r6, #0
        ldr r3, =count
        mov r2, r5
        ldr r0, =head
        ldr r1, =tail
        bl Push_back
        mov r2, #0
        ldr r1, =szBuffer
        str r2, [r1]
        mov r5, r1
        b endForTwo
        
    @ nextFile:
        
    @     mov r0, r4
    @     mov r7, #3
    @     mov r2, #1
    @     svc 0
    @     ldrb r2, [r1]
    @     @ mov r6, #0
    @     @ mov r2, #0
    @     @ ldr r1, =szBuffer
    @     @ str r2, [r1]
    @     @ mov r5, r1
    @     b backtostart

    @ nextFile2:
    @     mov r6, #0
    @     mov r2, #0
    @     ldr r1, =szBuffer
    @     str r2, [r1]
    @     mov r5, r1
    @     b whileNoteof
endForTwo:
    
    @ mov r0, r6
    @ ldr r1, =out
    @ bl intasc32
    @ ldr r0, =out
    @ bl putstring

    pop {r0, r1, r2}
    ldr r0, =szPrompt
    b _whileInvalid

/****************************************************End lable for Two***************************************************/
/**************************************************** lable for Three ***************************************************/
.data  
    delMessage:     .asciz "\nEnter the index to delete:\t"
    
    indexBuff:      .skip 16
.text

getIndexToDel:
    push {r0-r2}
    
    ldr r0, =delMessage
    bl putstring
    
    mov r1, #12
    ldr r0, =indexBuff
    bl getstring
    bl ascint32
    mov r2, r0
    ldr r0, =tail
    //ldr r0, [r0]
    ldr r1, =head
   // ldr r1, [r1]
    ldr r3, =count
    bl Remove_node


    pop {r0-r2}
    ldr r0, =szPrompt
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
    push {r0-r2}
    
    ldr r0, =editMessage
    bl putstring
    
    mov r1, #12
    ldr r0, =indexBuff2
    bl getstring
    bl ascint32
    mov r5, r0
    ldr r0, =override
    bl putstring
    mov r1, #512
    ldr r0, =indexBuff4
    bl getstring
    mov r1, r5
    mov r3, r0
    bl editNode

    pop {r0-r2}
    ldr r0, =szPrompt
    b _whileInvalid
/**************************************************** End lable for Four ***************************************************/
/**************************************************** lable for Five ***************************************************/
.data  
    subStringM:     .asciz "\nEnter the string to search for:\t\t"
    outMessage5:    .asciz "\nThe amount of the string is:\t"
    index2:         .word 0
    stringBuff:     .skip 30
    szOut:          .skip 16
.text

getStringForSearch:
    push {r0-r2}
    
    ldr r0, =subStringM
    bl putstring
    
    mov r1, #100
    ldr r0, =stringBuff
    bl getstring

    ldr r1, =head
    ldr r4, [r1]

    mov r6, #0
    ldr r3, =index2
    mov r9, r0
    //push {r1}
whileNotEnd2:
    
    cmp r4, #0		
	beq _endFive	
    mov r0, #0
    ldr r1, =return
    str r0, [r1]
    
    //PrintIndex index2
    //add r6, #1		

    mov r0, r4
    ldr r0, [r0]
    NodeSize
    mov r3, r0
    mov r0, r4
    ldr r0, [r0]
    mov r7, #0
whilelessSize:
    cmp r3, r7
    ldreq r4, [r4, #4]
    beq whileNotEnd2
    	
           // mov r3, r0
            //ldr r0, [r0]
            push {r1, r2, r3}
            ldr r1, =return
        whileNotEnd1:
            ldrb r2, [r0], #1
            cmp r2, #0
            //addeq r7, #1
            beq _endString
            cmp r2, #32
            strne r2, [r1], #1
            add r7, #1
            beq _endString
            b whileNotEnd1
        _endString:
            ldr r0, =return
            pop {r1, r2, r3}
    mov r1, r9
    bl String_equalIgnoreCase
    cmp r0, #1
    addeq r6, #1
    mov r0, r4
    ldr r0, [r0]
    add r0, r7
	b whilelessSize				
_endFive:
    //bl subString
    mov r0, r6
    ldr r1, =szOut
    bl intasc32
    ldr r0, =outMessage5
    bl putstring
    ldr r0, =szOut
    bl putstring

    //pop {r1}
    pop {r0-r2}
    ldr r0, =szPrompt
    b _whileInvalid
/**************************************************** End lable for Five ***************************************************/
/**************************************************** lable for Six ***************************************************/
.data  
    szSaveMessage:     .asciz "\nNow saving to a file...\n"
.text
saveToFile:
    
    ldr r0, =szSaveMessage
    bl putstring

    ldr r0, =outFileName
    mov r7, #5
    mov r1, #0101
    mov r2, #0777
    svc 0
    mov r11, r0
    mov r9, #10
    mov r6, #0
    ldr r1, =head
    ldr r4, [r1]

whileNotEndSix:
    
    cmp r4, #0		
	beq _endSix	
    mov r6, #0	
    ldr r1, [r4]
    b len

backlen:

    mov r7, #4
    ldr r1, [r4]
    mov r2, r6
    mov r0, r11
    svc 0
    ldr r4, [r4, #4]	
	b whileNotEndSix				

len:
    add r6, #1
    ldrb r10, [r1]
    cmp r10, #0
    beq checkNull

backfromNull:
    cmp r10, #0
    addne r1, #1
    streq r9, [r1]
    bne len
    b backlen

checkNull:
    mov r12, r4
    add r12, #4
    ldr r3, [r12]
    cmp r3, #3
    mov r3, #0
    str r3, [r1]
    bne backfromNull
    b end1
@  restart:   

@     mov r1, r5
@     ldrb r10, [r1]
@     cmp r10, #0
@     moveq r8, #0
@     ldreq r1, =newLine
@     add r6, #1
@     mov r2, #1
@     svc 0

@     cmp r8, #0
@     addne r5, #1
@     bne restart

@     mov r8, #1
@     ldr r4, [r4, #4]	
@ 	b whileNotEndSix				
end1:
    @ mov r7, #4
    @ ldr r1, [r4]
    @ sub r6, #1
    @ mov r2, r6
    @ mov r0, r11
    @ svc 0
_endSix:
    //bl getList
    //openFileToRead outFileName
    //writeFile data
    //loseFile   
    ldr r0, =szPrompt
    b _whileInvalid
/**************************************************** End lable for Six ***************************************************/
