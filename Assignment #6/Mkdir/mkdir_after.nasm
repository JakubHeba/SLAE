global _start			

section .text
_start:
	xor eax, eax
	add al, 0x27
	push edi
	push word 0x6465
	push 0x6b636168
	mov ebx, esp
	mov cx, 0x1ed	; file mode, hex(1ed) = dec(493) = oct(755)
	int 0x80
	add al,0x1
	xor ebx, ebx
	int 0x80
