global _start			

section .text
_start:
	xor eax, eax
	jmp two

one:
	pop ebx
	mov al, 5
	int 0x80
	mov esi, eax

read:
	mov ebx, esi
	mov al, 3
	mov ecx, esp
	mov dl, 1
	int 0x80
	or al, al
	jz exit
	mov al, 4
	mov bl, dl
	int 0x80
		
	jmp read

exit:
	inc eax
	int 0x80
	
two:
	call one
