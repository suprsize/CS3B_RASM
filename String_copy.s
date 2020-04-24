.data
.text
.global String_copy 
.extern malloc
.extern free

String_copy: 	        
    push {r4-r11, lr}  
	mov r8, r0
	bl String_Length
	mov r10, r0
	add r0, #5
	bl malloc
	mov r4, r0

string_copy_loop:
	cmp r10, #0
	beq end_copy
	ldrb r5, [r8], #1
	strb r5, [r4], #1
	sub r10, #1
	b string_copy_loop	

end_copy:
	mov r1, #0
	strb r1, [r4]
    mov r1, r0
	pop {r4-r11, lr}
	bx lr
