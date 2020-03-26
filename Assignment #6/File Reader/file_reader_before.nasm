global _start			

section .text
_start:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	jmp two

one:
	pop ebx
	
	mov byte al, 5
	xor ecx, ecx
	int 0x80
	
	mov esi, eax
	jmp read

exit:
	mov byte al, 1
	xor ebx, ebx
	int 0x80

read:
	mov ebx, esi
	mov byte al, 3
	sub esp, 1
	lea ecx, [esp]
	mov byte dl, 1
	int 0x80

	xor ebx, ebx
	cmp ebx, eax
	je exit

	mov byte al, 4
	mov byte bl, 1
	mov byte  dl, 1
	int 0x80
	
	add esp, 1
	jmp read

two:
	call one
