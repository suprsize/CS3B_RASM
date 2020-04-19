@***********************************************************************
@ Name:		Mohammad Amin & Khaja Zuhuruddin
@ Program:	Rasm4.s
@ Class:	CS3B
@ Lab:		RASM3
@ Date:		April 8, 2020 at 3:30 PM
@***********************************************************************
/****************************************************Lable for One***************************************************/

/****************************************************End Lable for One***************************************************/
.data  
    displayMessage:     .asciz "\nNow displaying the strings\n"
.text

printList:

    push {r0-r2}
    
    ldr r0, =displayMessage
    bl putstring

    //bl displayList

    pop {r0-r2}

    ldr r0, =szPrompt
    b _whileInvalid
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
    mov r1, #30
    ldr r0, =szBuffer
    bl getstring
selB:

endForTwo:

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
    //bl deleteNode

    pop {r0-r2}
    ldr r0, =szPrompt
    b _whileInvalid
/****************************************************End lable for Three***************************************************/
/**************************************************** lable for Four ***************************************************/

.data  
    editMessage:     .asciz "\nEnter the index to edit:\t"
    indexBuff2:      .skip 16
.text

getIndexToEdit:
    push {r0-r2}
    
    ldr r0, =editMessage
    bl putstring
    
    mov r1, #12
    ldr r0, =indexBuff2
    bl getstring
    bl ascint32
    //bl editNode

    pop {r0-r2}
    ldr r0, =szPrompt
    b _whileInvalid
/**************************************************** End lable for Four ***************************************************/
/**************************************************** lable for Five ***************************************************/
.data  
    subStringM:     .asciz "\nEnter the string to search for:\t\t"
    stringBuff:      .skip 30
.text

getStringForSearch:
    push {r0-r2}
    
    ldr r0, =subStringM
    bl putstring
    
    mov r1, #30
    ldr r0, =stringBuff
    bl getstring
    //bl subString

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
    //bl getList
    //openFileToRead outFileName
    //writeFile data
    //loseFile   
    ldr r0, =szPrompt
    b _whileInvalid
/**************************************************** End lable for Six ***************************************************/
