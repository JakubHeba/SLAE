global _start			

section .text
_start:

  jmp short caller
  
function: 
  pop esi
  xor eax, eax
  mov [esi+6],al
  mov al, 0x27
  lea ebx, [esi]
  mov cx, 0x1ed
  int 0x80
  
  mov al, 0x1
  xor ebx, ebx
  int 0x80

caller:  
  call function
  push dword 0x656b6361
  fs
  db 0x23
